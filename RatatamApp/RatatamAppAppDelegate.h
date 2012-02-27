//
//  RatatamAppAppDelegate.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RatatamController.h"

@interface RatatamAppAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSView *_view;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;
    
    NSArrayController *_arrayController;
    IBOutlet RatatamController *ratatamController;
    
}
@property (assign) IBOutlet NSArrayController *arrayController;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *view;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

- (IBAction)like:(id)sender;
- (IBAction)comment:(id)sender;

@end
