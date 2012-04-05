//
//  BulkDownloadWindowController.m
//  Ratatam
//
//  Created by Christophe Hamerling on 04/04/12.
//  Copyright 2012 christophehamerling.com. All rights reserved.
//

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
@synthesize operationQueue;
@synthesize downloadPathLabel;

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
    [label setStringValue:@"Click the 'Start' button to backup your photos"];
}

- (IBAction)cancelAction:(id)sender {
    // need to stop, if not download continues in the background...
    [operationQueue cancelAllOperations];
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
    
    // Create download folder
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *downloadFolder = [[searchPaths lastObject] stringByAppendingPathComponent:@"Image Download"];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:downloadFolder] ) {
        [[NSFileManager defaultManager] createDirectoryAtPath:downloadFolder attributes:nil];
    }
    
    // let's download...
    if (photoSet) {
        NSInteger current = 1;
        nbDownloads = 0;
        nbPhotos = [photoSet count];
        
        for(NSDictionary* photo in photoSet) {
            NSURL* url = [NSURL URLWithString:[[[photo valueForKey:@"images"] valueForKey:@"standard_resolution"] valueForKey:@"url"]];
            // maybe we can use a HTTP stream to get status and progress...
            NSString *extension = [[url path] pathExtension];
            NSString *filename = [NSString stringWithFormat:@"Image %d.%@", current++, extension];
            NSString *downloadPath = [downloadFolder stringByAppendingPathComponent:filename];
            BulkDownloadOperation *operation = [[BulkDownloadOperation alloc] initWithPhoto:photo downloadPath:downloadPath];
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
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg URLs];
        
        for (NSURL *url in files) {
            NSLog(@"URL %@", url);
            [downloadPathLabel setStringValue:[NSString stringWithFormat:@"%@", url]];
        }
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
        // open the folder...
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
