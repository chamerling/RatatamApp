//
//  RatatamController.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 23/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstagramPhoto.h"
#import "InstagramClient.h"

@interface RatatamController : NSObject {
    NSInteger unread;
    NSMutableArray *photos;
    NSMutableDictionary *selfPhotos;
    
    NSMutableDictionary *commentsCache;
    
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSView *rootView;
    IBOutlet NSProgressIndicator *toolbarProgress;
    IBOutlet NSTextField *toolbarLabel;
    
    IBOutlet NSTableView *tableView;
    
    InstagramClient *client;
}

@property (nonatomic, retain) NSMutableArray *photos;
@property (assign) IBOutlet NSTableView *tableView;

- (void) addPhoto:(InstagramPhoto*) photo at:(int)index;

- (void) removeAllPhotos;
- (void) incrementBadgeCount;
- (void) clearBadgeCount;
- (void) showRootView:(BOOL)show;

- (void) startProgress:(NSString *) message;
- (void) stopProgress;

- (void) startStatusMessage:(NSString *)message;
- (void) stopStatusMessage:(NSString *)message withDelay:(NSInteger) delay;

// comment processing
- (void) addPhotoForComment:(NSDictionary *)photo notify:(BOOL)status;
- (void) notifyNewComment:(NSDictionary *)comment forPhoto:(NSDictionary *)photo;

@end
