//
//  InstagramFetcher.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstagramClient.h"
#import "RatatamController.h"
#import "NotificationManager.h"

@interface InstagramFetcher : NSObject
{
    NSDictionary *latest;
    NSTimer* newPhotoTimer;
    NSTimer* newCommentTimer;
    
    NSMutableArray *photoCache;
    
    // used for new comments processing
    NSString *lastCommentId;
    
    NSString *lastId;

    InstagramClient *client;    
    NotificationManager *notificationManager;
    RatatamController *ratatamController;
}

@property (assign) RatatamController *ratatamController;

- (void) getNewPhotos:(id) sender;
- (void) getNewComments:(id) sender;

- (void) pause;
- (void) resume;
- (void) start;
- (void) stop;

@end
