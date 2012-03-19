//
//  RatatamController.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 23/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RatatamController.h"

#import "InstagramClient.h"
#import "PhotoCellView.h"
#import "EGOCache.h"

@interface RatatamController (Private)
- (void) doAddPhotoAtPosition:(NSDictionary *) photo;
- (void) doStartStatusMessage:(NSString *) message;
- (void) doStopStatusMessage:(NSString *) message;
- (void) hideAll:(id) sender;
@end

@implementation RatatamController

@synthesize photos;
@synthesize tableView;

- (id)init {
    self = [super init];
    if (self) {
        photos = [[NSMutableArray alloc] init];
        unread = 0;
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
    
    return cell;
}

@end
