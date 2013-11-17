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

#import "BulkDownloadWindowController.h"
#import "InstagramClient.h"
#import "BulkDownloadOperation.h"

@interface BulkDownloadWindowController (Private)
- (void) getData:(id) sender;
- (void) gettingData:(id) sender;
- (void) dataReceived:(id) sender;
- (void) updateStatus:(NSInteger)current total:(NSInteger)total;
- (void) handleError;
- (void) downloadImageReferences;
@end

@implementation BulkDownloadWindowController
@synthesize label;
@synthesize progress;
@synthesize cancelButton;
@synthesize startButton;
@synthesize importTo;
@synthesize operationQueue;
@synthesize downloadPathLabel;
@synthesize popupButton;
@synthesize selectedPath;
@synthesize downloadFolder;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [label setStringValue:@"Click the 'Start...' button to backup your photos"];
}

- (IBAction)cancelAction:(id)sender {
    // need to stop, if not download continues in the background...
    [operationQueue cancelAllOperations];
    [label setStringValue:@"Click the 'Start...' button to backup your photos"];
    
    if (nbDownloads > 0 && self.downloadFolder) {
        [[NSWorkspace sharedWorkspace] openFile:self.downloadFolder];
    }
    
    [[self window]close];
}

- (IBAction)startAction:(id)sender {
    [startButton setEnabled:NO];
    [self performSelectorInBackground:@selector(getData:) withObject:sender];
}

- (void)getData:(id) sender {    
    // create a thread or NSOperation which can download all...
    
    [self performSelectorOnMainThread:@selector(gettingData:) withObject:nil waitUntilDone:YES];
    
    [operationQueue cancelAllOperations];  
    self.operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:8];
    
    InstagramClient *client = [[InstagramClient alloc] init];
    NSMutableSet *photoSet = [client getAllSelfPhotos];
    [client release];
    
    [self performSelectorOnMainThread:@selector(dataReceived:) withObject:nil waitUntilDone:YES];
    
    if (self.selectedPath) {
        // custom
        NSURL *folder = [NSURL fileURLWithPath:self.selectedPath];
        NSURL *createFolder = [folder URLByAppendingPathComponent:@"Instagram"];
        self.downloadFolder = [createFolder path];
        [[NSFileManager defaultManager] createDirectoryAtPath:downloadFolder withIntermediateDirectories:YES attributes:nil error:nil];

    } else {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
        self.downloadFolder = [[searchPaths lastObject] stringByAppendingPathComponent:@"Instagram"];
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:self.downloadFolder] ) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.downloadFolder attributes:nil];
        }
    }
    
    // let's download...
    if (photoSet) {
        nbDownloads = 0;
        nbPhotos = [photoSet count];
                
        for(NSDictionary* photo in photoSet) {
            BulkDownloadOperation *operation = [[BulkDownloadOperation alloc] initWithPhoto:photo downloadPath:downloadFolder];
            operation.delegate = self;
            [operationQueue addOperation:operation];
        }
    }
}

- (void)gettingData:(id) sender {
    [label setStringValue:@"Retrieving photo data..."];   
    [progress setDoubleValue:0];
    [progress setIndeterminate:YES];
    [progress startAnimation:nil];
}

- (void)dataReceived:(id) sender {
    [label setStringValue:@"Data retrieved, downloading photos..."];
    [progress setIndeterminate:NO];
    [progress startAnimation:nil];
    [progress setDoubleValue:0];
}

- (void)updateStatus:(NSInteger)current total:(NSInteger)total {
    [label setStringValue:[NSString stringWithFormat:@"Getting photo %d/%d", current, total]];
    double state = (current * 100) / total;
    if (state > 100) {
        state = 100;
    }
    
    [progress setDoubleValue:state];
}

- (IBAction)chooseDownloadTarget:(id)sender{
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setCanCreateDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setTitle:@"Choose Backup Destination Folder"];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg URLs];
        NSURL *url = [files objectAtIndex:0];
        self.selectedPath = [NSString stringWithFormat:@"%@", [url path]];  
        
        [importTo setStringValue:[NSString stringWithFormat:@"Importing photos to %@/Instagram", self.selectedPath]];
        [importTo setHidden:NO];
        
        // let's download
        [self startAction:self];
    }
}

#pragma mark - delegate
- (void)photoDownloaded:(id)sender {
    nbDownloads ++;
    [self updateStatus:nbDownloads total:nbPhotos];
    if (nbDownloads >= nbPhotos) {
        // download complete
        [label setStringValue:@"Download complete!"];
        [cancelButton setEnabled:NO];
        [startButton setEnabled:YES];
        
        [[self window] close];
        [[NSWorkspace sharedWorkspace] openFile:self.downloadFolder];
        NSBeep();
        // open the folder...
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
