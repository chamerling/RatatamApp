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
    
    IBOutlet NSArrayController *arrayController;
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSView *rootView;
    IBOutlet NSProgressIndicator *toolbarProgress;
    IBOutlet NSTextField *toolbarLabel;
}

@property (nonatomic, retain) NSMutableArray *photos;

- (void) addPhoto:(InstagramPhoto*) photo atTop:(BOOL)top;
- (void) removeAllPhotos;
- (void) incrementBadgeCount;
- (void) clearBadgeCount;
- (void) showRootView:(BOOL)show;

- (void) startProgress:(NSString *) message;
- (void) stopProgress;

@end
