//
//  RatatamAppAppDelegate.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RatatamController.h"
#import "MASPreferencesWindowController.h"
#import "InstagramFetcher.h"
#import "NotificationManager.h"
#import "InstagramClient.h"

@interface RatatamAppAppDelegate : NSObject <NSApplicationDelegate, NSToolbarDelegate> {
    NSWindow *window;
    NSView *_view;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;
    
    IBOutlet RatatamController *ratatamController;
    
    MASPreferencesWindowController *_preferencesWindowController;
    
    InstagramFetcher *fetcher;

    // toolbar
    IBOutlet NSView *toolbarView;
    IBOutlet NSToolbar *toolbar;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *view;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

# pragma mark - preferences
@property (nonatomic, readonly) MASPreferencesWindowController *preferencesWindowController;

# pragma mark - app actions
- (IBAction)saveAction:(id)sender;

# pragma mark - URL handling
- (void)getUrl:(NSAppleEventDescriptor *)event;
- (void) registerURLHandler:(id) sender;

- (IBAction)openPreferences:(id)sender;

# pragma mark - Window management
- (IBAction)showMainWindow:(id)sender;

# pragma mark - debug
- (IBAction)clearCache:(id)sender;

# pragma mark - tools
- (IBAction)downloadAction:(id)sender;


@end
