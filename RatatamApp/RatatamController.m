// (The MIT License)
//
// Copyright (c) 2013 Christophe Hamerling <christophe.hamerling@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// 'Software'), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RatatamController.h"

#import "InstagramClient.h"
#import "PhotoCellView.h"
#import "EGOCache.h"
#import "EGOImageView.h"
#import "PhotoCommentsWindowController.h"
#import "NotificationManager.h"

@interface RatatamController (Private)
- (void) doAddPhotoAtPosition:(NSDictionary *) photo;
- (void) doStartStatusMessage:(NSString *) message;
- (void) doStopStatusMessage:(NSString *) message;
- (void) hideAll:(id) sender;
- (NSInteger) getCommentCount:(NSDictionary *) photo;
@end

@implementation RatatamController

@synthesize photos;
@synthesize tableView;

- (id)init {
    self = [super init];
    if (self) {
        photos = [[NSMutableArray alloc] init];
        unread = 0;
        client = [[InstagramClient alloc] init];
        selfPhotos = [[NSMutableDictionary alloc] init];
        commentsCache = [[NSMutableDictionary alloc] init];
    }
         
    return self;
}

// called by the fetcher...
- (void) addPhoto:(InstagramPhoto*) photo at:(int)index {
    if (photo) {
        
        // lock it, we can not add photos while enumerating. Waiting on last method fixes the problem but cleaner integration will be better...
        
        for (NSDictionary *available in photos) {
    
            NSString *photoId = [[available valueForKey:@"properties"] valueForKey:@"id"];
            NSString *newPhotoId = [[photo valueForKey:@"properties"] valueForKey:@"id"];
         
            if ([photoId isEqualToString:newPhotoId]) {
                // already in
                return;
            } else {
                // not in, tell that we have a new photo!
            }
        }
        
        NSMutableDictionary *arg = [[NSMutableDictionary alloc] init];
        NSNumber *position = [[NSNumber alloc] initWithInt:index];
        [arg setValue:position forKey:@"position"];
        [arg setValue:photo forKey:@"photo"];
        
        [self performSelectorOnMainThread:@selector(doAddPhotoAtPosition:) withObject:arg waitUntilDone:YES];
    }    
}

// add photo to the array and then notify the table that there is a new photo. 
// This works with KVO and bindings.
- (void) doAddPhotoAtPosition:(NSDictionary *) dict {
    
    InstagramPhoto *photo = [dict valueForKey:@"photo"];
    NSNumber *position = [dict valueForKey:@"position"];
        
    [self incrementBadgeCount];
    [photos insertObject:photo atIndex:[position intValue]];
    [[self tableView] reloadData];
}

- (void) removeAllPhotos {
    photos = [[NSMutableArray alloc] init];
    [[EGOCache currentCache] clearCache];
    [[self tableView] reloadData];  
}

- (void) incrementBadgeCount {
    // only increments when the window is not visible
    if (![mainWindow isVisible]) {
        unread ++;
        [[[NSApplication sharedApplication] dockTile] setBadgeLabel:[NSString stringWithFormat:@"%d", unread]];
    }
}

- (void) clearBadgeCount {
    unread = 0;
    [[[NSApplication sharedApplication] dockTile] setBadgeLabel:nil];    
}

- (void) showRootView:(BOOL)show {
    [rootView setHidden:!show];
}

- (void) startProgress:(NSString *) message {
    //[toolbarLabel setStringValue:message];
    //[toolbarLabel setHidden:NO];
    [toolbarProgress startAnimation:nil];
}

- (void) stopProgress {
    [toolbarLabel setHidden:YES];
    [toolbarProgress stopAnimation:nil];
    [toolbarLabel setStringValue:@""];
}

- (void) startStatusMessage:(NSString *)message {
    [self performSelectorOnMainThread:@selector(doStartStatusMessage:) withObject:message waitUntilDone:YES];
}

- (void) doStartStatusMessage:(NSString *)message {
    [toolbarLabel setStringValue:message];
    [toolbarLabel setHidden:NO];
    [toolbarProgress startAnimation:nil];
}

- (void) stopStatusMessage:(NSString *)message withDelay:(NSInteger) delay {
    [self performSelectorOnMainThread:@selector(doStopStatusMessage:) withObject:message waitUntilDone:NO];    
}

- (void) doStopStatusMessage:(NSString *)message {
    [toolbarLabel setStringValue:message];
    //[toolbarLabel setHidden:NO];
    //[toolbarProgress startAnimation:nil];
    
    [self performSelector:@selector(hideAll:) withObject:nil afterDelay:1.0];
}

- (void) hideAll:(id)sender {
    [toolbarLabel setHidden:YES];
    [toolbarProgress stopAnimation:nil];
}

- (void) addPhotoForComment:(NSDictionary *)photo notify:(BOOL)notify {
    if (!photo) {
        DLog(@"Photo is null, do not process it");
        return;
    }
    
    DLog(@"Add photo for comment...");
    
    // check if the dictionary already contains the photo
    
    NSString *photoId = [photo valueForKey:@"id"];
    if ([selfPhotos valueForKey:photoId]) {
        // the photo is not new
        DLog(@"Photo %@ is not new", photoId);
        
        NSDictionary *oldPhoto = [selfPhotos valueForKey:photoId];
        
        DLog(@"Found old photo? %d", (oldPhoto != nil));
        
        // compare the nb of comments
            DLog(@"Will notify if new comments");
            
            NSInteger oldCount = [self getCommentCount:oldPhoto];
            NSInteger newCount = [self getCommentCount:photo];
            
            DLog(@"Old comments %ld, new comments %ld", oldCount, newCount);
            
            if (newCount > oldCount) {
                // so we need to compare comments. Remember to not notify my own comments...
                // get the new comments
                NSDictionary *newCommentsPayload = [client getCommentsForPhoto:photoId];
                if (newCommentsPayload && [newCommentsPayload valueForKey:@"data"]) {
                    NSDictionary *newComments = [newCommentsPayload valueForKey:@"data"];
                    
                    DLog(@"Got new comments from instagram %@", newComments);
                    
                    // make a diff between old and new comments...
                    // get the cached comments
                    NSDictionary *oldComments = [commentsCache valueForKey:photoId];
                    if (oldComments) {
                        DLog(@"Got old comments from cache");
                        
                        // diff between oldComments and newComments
                        NSMutableSet* newSet = [[NSMutableSet alloc] init];
                        for (NSDictionary *d in newComments) {
                            [newSet addObject:[d valueForKey:@"id"]];
                        }
                        
                        NSMutableSet* oldSet = [[NSMutableSet alloc] init];
                        for (NSDictionary *d in oldComments) {
                            [oldSet addObject:[d valueForKey:@"id"]];
                        }
                        
                        [newSet minusSet:oldSet];
                        DLog(@"New comments remains %@", newSet);
                        
                        // loop on remaining
                        for (NSString *commentId in newSet) {
                            // loop on comments we just get from instagram
                            for (NSDictionary *comment in newComments) {
                                if ([[comment valueForKey:@"id"] isEqual:commentId]) {
                                    if (notify) {
                                        [self notifyNewComment:comment forPhoto:photo];
                                    }
                                }
                            }
                        }
                        
                        [oldSet release];
                        [newSet release];
                    }
                    
                    DLog(@"Replace old comments with new ones");
                    // replace the comments in the cache
                    [commentsCache setObject:newComments forKey:photoId];
                }
            }
        
        // replace the photo so that the next call compares with the updated photo...
        [selfPhotos setObject:photo forKey:photoId];
        
    } else {
        // the photo is new, we add it to the dictionary cache
        [selfPhotos setObject:photo forKey:photoId];
        
        // if the photo is new and if there are already comments (ie comments have been added between the creation and the self photo poll, let's send notification
        if ([photo valueForKey:@"comments"] && [[photo valueForKey:@"comments"] valueForKey:@"count"] && [[photo valueForKey:@"comments"] valueForKey:@"count"] > 0) {
            DLog(@"Need to get the comments from the photo to compare with the cache one...");
            
            // get all the comments
            NSDictionary *comments = [client getCommentsForPhoto:[photo valueForKey:@"id"]];
            if (comments) {
                // loop on data
                NSDictionary *data = [comments valueForKey:@"data"];
                
                for (NSDictionary *comment in data) {
                    // Not me...
                    //if ([[comment valueForKey:@"from"] valueForKey:@"username"]) {
                    if (notify) {
                        [self notifyNewComment:comment forPhoto:photo];
                    }
                    //}
                }
                
                // cache the comments for future comments compare...
                [commentsCache setObject:data forKey:photoId];
            }
        } else {
           // NOP 
        }
    }
    
}

- (void) notifyNewComment:(NSDictionary *)comment forPhoto:(NSDictionary *)photo {
    DLog(@"There is a new comment %@ on a photo %@", comment, photo);
    if (photo && comment) {
        [[NotificationManager get] notifyNewComment:comment forPhoto:photo];
        // can do more on the UI side...
    }
}

- (NSInteger) getCommentCount:(NSDictionary *) photo {
    NSInteger result = 0;
    
    if (photo && [photo valueForKey:@"comments"] && [[photo valueForKey:@"comments"] valueForKey:@"count"]) {
        id count = [[photo valueForKey:@"comments"] valueForKey:@"count"];
        result = [count intValue];
    }
    
    return result;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return photos.count;
}

- (NSView *)tableView:(NSTableView *)_tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    InstagramPhoto *photo = [photos objectAtIndex:row];
    if (!photo) {
        return nil;
    }
    NSDictionary *data = [photo properties];
    
    PhotoCellView *cell = [_tableView makeViewWithIdentifier:@"PhotoCell" owner:self];
    [cell setInstagramPhoto:photo];
    [[cell image] setDelegate:cell];
    
    [[cell username] setStringValue:[[data valueForKey:@"user"] valueForKey:@"full_name"]];
    NSString *userAvatar = [[[photo properties] valueForKey:@"user"] valueForKey:@"profile_picture"];
    [cell setAvatar:userAvatar];
    
    if ([data valueForKey:@"caption"] != [NSNull null]) {
        [[cell caption] setStringValue:[[data valueForKey:@"caption"] valueForKey:@"text"]];
    } else {
        [[cell caption] setStringValue:@""];        
    }    
    
    NSString *createdAt = [[photo properties] valueForKey:@"created_time"];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterLongStyle];
    [f setTimeStyle:NSDateFormatterMediumStyle];
    NSString *date = [f stringFromDate:[NSDate dateWithTimeIntervalSince1970:[createdAt longLongValue]]];
    [[cell date] setStringValue:date];
    
    NSString *url = [[[[photo properties] valueForKey:@"images"] valueForKey:@"standard_resolution"] valueForKey:@"url"];
    [cell setPhoto:url];
    
    [[cell likeButton] setAction:@selector(like:)];
    [[cell likeButton] setTarget:cell];
    
    [[cell commentButton] setAction:@selector(comment:)];
    [[cell commentButton] setTarget:cell];
    
    [cell setMainWindow:mainWindow];
    [cell setClient:client];
    [cell setController:self];
    
    return cell;
}

@end
