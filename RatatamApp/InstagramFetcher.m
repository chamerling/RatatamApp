//
//  InstagramFetcher.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "InstagramFetcher.h"

@interface InstagramFetcher (Private)
- (void) doStart:(id) sender;
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
    [self performSelectorInBackground:@selector(doStart:) withObject:nil];        
}

- (void) doStart:(id) sender {
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    newPhotoTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getNewPhotos:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:newPhotoTimer forMode:NSRunLoopCommonModes];
    [newPhotoTimer setFireDate: [NSDate dateWithTimeIntervalSinceNow:1]];
    
    [runLoop run];
    [pool release];

}

- (void)getNewPhotos:(id)sender {
    
    BOOL firstCall = (lastId == nil);
    
    NSDictionary *photos = nil;
    if (!lastId) {
        // first call, we get 10 photos for now...
        photos = [client getPhotosForUser:nil nb:10];
        // update lastId
    } else {
        photos = [client getPhotosForUser:nil since:lastId];
    }
     
    NSDictionary *data = [photos valueForKey:@"data"];
    
    int i = 0;
    for (NSDictionary *photo in data) {
        //NSLog(@"Processing photo %@ from %@", [photo valueForKey:@"id"], [photo valueForKey:@"user"]);
        if (photo && i == 0) {
            lastId = [photo valueForKey:@"id"];
        }
        i++;
        
        // check if this image is new
        // we whould already be here if only the photo is new...
        
        if (!firstCall) {
            [notificationManager notifyNewImage:photo];
        }
        
        InstagramPhoto *ip = [[InstagramPhoto alloc] init];
        [ip setProperties:[[NSMutableDictionary alloc] initWithDictionary:photo]];
        [ratatamController addPhoto:ip atTop:YES];
    }
}

@end
