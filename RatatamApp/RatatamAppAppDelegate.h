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

@interface RatatamAppAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSView *_view;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;
    
    NSArrayController *_arrayController;
    IBOutlet RatatamController *ratatamController;
    
    MASPreferencesWindowController *_preferencesWindowController;
    InstagramFetcher *fetcher;
    
}
@property (assign) IBOutlet NSArrayController *arrayController;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *view;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

# pragma mark - preferences
@property (nonatomic, readonly) MASPreferencesWindowController *preferencesWindowController;

# pragma mark - app actions
- (IBAction)saveAction:(id)sender;

# pragma mark - instagram actions
- (IBAction)like:(id)sender;
- (IBAction)comment:(id)sender;

# pragma mark - URL handling
- (void)getUrl:(NSAppleEventDescriptor *)event;
- (void) registerURLHandler:(id) sender;

- (IBAction)openPreferences:(id)sender;


@end
