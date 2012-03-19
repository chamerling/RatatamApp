//
//  RatatamController.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 23/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstagramPhoto.h"

@interface RatatamController : NSObject {
    NSInteger unread;
    NSMutableArray *photos;
    
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSView *rootView;
    IBOutlet NSProgressIndicator *toolbarProgress;
    IBOutlet NSTextField *toolbarLabel;
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

@end
