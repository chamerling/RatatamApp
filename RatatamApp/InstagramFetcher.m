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

#import "InstagramFetcher.h"
#import "NotificationManager.h"

@interface InstagramFetcher (Private)
- (void) doStart:(id) sender;
- (void) hideProgress:(id) sender;
@end

@implementation InstagramFetcher

@synthesize ratatamController;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        client = [[InstagramClient alloc] init];
        notificationManager = [[NotificationManager alloc] init];
        
        photoCache = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) pause {
    
}

- (void) resume {
    
}

- (void)start {
    [ratatamController startProgress:@"Loading data..."];
    [self performSelectorInBackground:@selector(doStart:) withObject:nil];        
}

- (void)stop {
    [newPhotoTimer invalidate];
    //[newCommentTimer invalidate];
    lastId = nil;
}

- (void) doStart:(id) sender {
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    newPhotoTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getNewPhotos:) userInfo:nil repeats:YES];
    //newCommentTimer = [NSTimer scheduledTimerWithTimeInterval:100 target:self selector:@selector(getNewComments:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:newPhotoTimer forMode:NSRunLoopCommonModes];
    [newPhotoTimer setFireDate: [NSDate dateWithTimeIntervalSinceNow:1]];
    //[[NSRunLoop currentRunLoop] addTimer:newCommentTimer forMode:NSRunLoopCommonModes];
    //[newCommentTimer setFireDate: [NSDate dateWithTimeIntervalSinceNow:5]];
    
    [runLoop run];
    [pool release];
}

- (void)getNewPhotos:(id)sender {
    
    BOOL firstCall = (lastId == nil);
    if (firstCall) {
        [ratatamController showRootView:NO];    
    }
    
    NSDictionary *photos = nil;
    if (!lastId) {
        // first call, we get 20 photos for now...
        photos = [client getNPhotos:20];
        // update lastId
    } else {
        // for tests
        //photos = [client getNPhotos:3];
        photos = [client getPhotosSince:lastId];
    }
    
    if (!photos) {
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:YES];
        return;
    }
     
    NSDictionary *data = [photos valueForKey:@"data"];
    
    if (!data) {
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:YES];
        return;
    }
    
    int i = 0;
    for (NSDictionary *photo in data) {
        if (photo && i == 0) {
            lastId = [photo valueForKey:@"id"];
        }
        
        InstagramPhoto *ip = [[InstagramPhoto alloc] init];
        [ip setProperties:[[NSMutableDictionary alloc] initWithDictionary:photo]];
        
        if (!firstCall) {
            [notificationManager notifyNewImage:photo];
        }
        
        [ratatamController addPhoto:ip at:i];
        i++;
    }
    
    if (firstCall) {
        // first call, we show the final view when all is loaded
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:YES];
        [ratatamController showRootView:YES];
    }
}

- (void)getNewComments:(id)sender {
    DLog(@"Getting new comments for self photos");
    NSDictionary *photos = nil;
    BOOL firstCall = (lastCommentId == nil);


    if (firstCall) {
        photos = [client getNSelfPhotos:20];
    } else {
        photos = [client getSelfPhotosSince:lastCommentId];
    }
    
    if (!photos) {
        return;
    }
    
    NSDictionary *data = [photos valueForKey:@"data"];

    if (!data) {
        return;
    }
    
    int i = 0;
    for (NSDictionary *photo in data) {
        // cache the first photo we get...
        lastCommentId = [photo valueForKey:@"id"];
        [ratatamController addPhotoForComment:photo notify:!firstCall];
        i++;
    }
}

- (void)hideProgress:(id)sender {
    [ratatamController stopProgress];
}

@end
