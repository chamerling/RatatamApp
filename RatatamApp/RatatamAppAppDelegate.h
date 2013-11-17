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

    IBOutlet NSScrollView *scrollView;
    
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

# pragma mark - navigate
- (IBAction)goToTopAction:(id)sender;

@end
