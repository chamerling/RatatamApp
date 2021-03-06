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

#import "RatatamAppAppDelegate.h"
#import "NotificationManager.h"
#import "PhotoCellView.h"
#import "InstagramFetcher.h"
#import "PhotoAddCommentWindowController.h"
#import "Preferences.h"
#import "AccountPreferencesViewController.h"
#import "UserPreferences.h"
#import "NSString+JavaAPI.h"
#import "PhotoCommentsWindowController.h"
#import "EGOCache.h"
#import "BulkDownloadWindowController.h"

#define mainToolbarItemID     @"DefaultToolbarItem"

@implementation RatatamAppAppDelegate

@synthesize window;
@synthesize view = _view;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [window setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"background"]]];
    
    [self registerURLHandler:nil];
            
    fetcher = [[InstagramFetcher alloc] init];
    if (fetcher && ratatamController) {
        [fetcher setRatatamController:ratatamController];
    }
        
    Preferences* preferences = [Preferences sharedInstance];
    if ([[preferences oauthToken]length] == 0) {
        [self openPreferences:nil];
    } else {
        [fetcher start];   
    }
}

/**
    Returns the directory the application uses to store the Core Data store file. This code uses a directory named "RatatamApp" in the user's Library directory.
 */
- (NSURL *)applicationFilesDirectory {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *libraryURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    return [libraryURL URLByAppendingPathComponent:@"RatatamApp"];
}

/**
    Creates if necessary and returns the managed object model for the application.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel) {
        return __managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RatatamApp" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
    Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }

    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
        
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else {
        if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] != YES) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]]; 
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"RatatamApp.storedata"];
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        [__persistentStoreCoordinator release], __persistentStoreCoordinator = nil;
        return nil;
    }

    return __persistentStoreCoordinator;
}

/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext) {
        return __managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];

    return __managedObjectContext;
}

/**
    Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}

/**
    Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
 */
- (IBAction)saveAction:(id)sender {
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    // Save changes in the application's managed object context before the application terminates.

    if (!__managedObjectContext) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        [alert release];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

#pragma mark - Custom URL handling
- (void)registerURLHandler:(id) sender
{
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    OSStatus httpResult = LSSetDefaultHandlerForURLScheme((CFStringRef)@"ratatam", (CFStringRef)bundleID);
    //NSLog(@"Result : %@", httpResult);
	[[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(getUrl:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)getUrl:(NSAppleEventDescriptor *)event {
	NSString *url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];

    if (url) {
        NSString* expectedURL = @"ratatam://oauth#access_token=";
        
        if ([url startsWith:expectedURL]) {
            // for now we do not support N operations, so 'oauth' is the only one. Will need to add more...
            // ratatam://oauth#access_token=ACCESS-TOKEN
            //NSLog(@"query %@", query);
            
            if ([[[Preferences sharedInstance] oauthToken]length] > 0) {
                [[NotificationManager get] notifyError:@"Error while getting OAuth token"];
                return;
            }
            
            NSString* oauth = [url substringFromIndex:[expectedURL length]];
            
            if (oauth) {
                [[Preferences sharedInstance]storeToken:oauth];
                // TODO = show window
                [fetcher start];
            } else {
                // display error
            }
        } else {
            // ?
        }
    }
}

#pragma mark - window management

- (IBAction)openPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps: YES];
    [self.preferencesWindowController showWindow:nil];
}

- (MASPreferencesWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
        AccountPreferencesViewController *accountViewController = [[AccountPreferencesViewController alloc] init];
        UserPreferences *userPreferences = [[UserPreferences alloc] init];
        [userPreferences setFetcher:fetcher];
        [userPreferences setRatatamController:ratatamController];
        
        NSArray *controllers = [[NSArray alloc] initWithObjects:userPreferences, accountViewController, nil];
        
        [accountViewController release];
        [userPreferences release];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
        
        [_preferencesWindowController selectControllerAtIndex:0];
        [controllers release];
    } else {
        [_preferencesWindowController selectControllerAtIndex:0];        
    }
    return _preferencesWindowController;
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    // hack to show window when it is closed.
    // This method is only called when there is no visible window
    [self showMainWindow:self];
    return NO;
}

- (IBAction)showMainWindow:(id)sender {
    [window makeKeyAndOrderFront:nil];
    [ratatamController clearBadgeCount];
    [NSApp activateIgnoringOtherApps:YES];
}

#pragma mark - toolbar delegate
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
    [item setView:toolbarView];
    
    return item;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects:   mainToolbarItemID,
            nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects:   mainToolbarItemID,
            nil];
    // note:
    // that since our toolbar is defined from Interface Builder, an additional separator and customize
    // toolbar items will be automatically added to the "default" list of items.
}

#pragma mark - debug
- (IBAction)clearCache:(id)sender {
    NSLog(@"Remove all photos and clear cache");
    //[ratatamController removeAllPhotos];
    [[EGOCache currentCache] clearCache];
}

#pragma mark - menu
- (IBAction)downloadAction:(id)sender {
    BulkDownloadWindowController *dlController = [[BulkDownloadWindowController alloc] initWithWindowNibName:@"BulkDownloadWindow"];
    [dlController showWindow:self];
}

- (IBAction)goToTopAction:(id)sender {
    // http://stackoverflow.com/questions/4506391/nsscrollview-jumping-to-bottom-on-scroll
    if ([scrollView hasVerticalScroller]) {
        scrollView.verticalScroller.floatValue = 0;
    }
    [[scrollView contentView] scrollToPoint: NSMakePoint(0, 0)];
}

#pragma mark - memory management
- (void)dealloc
{
    [__managedObjectContext release];
    [__persistentStoreCoordinator release];
    [__managedObjectModel release];
    [super dealloc];
}

@end
