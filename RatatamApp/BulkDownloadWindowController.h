//
//  BulkDownloadWindowController.h
//  Ratatam
//
//  Created by Christophe Hamerling on 04/04/12.
//  Copyright 2012 christophehamerling.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BulkDownloadOperation.h"

@interface BulkDownloadWindowController : NSWindowController<BulkDownloadOperationDelegate> {
    NSButton *cancelButton;
    NSButton *startButton;
    NSProgressIndicator *progress;
    NSTextField *label;
    
    NSOperationQueue *operationQueue;
    NSTextField *downloadPathLabel;
    NSInteger nbPhotos;
    NSInteger nbDownloads;
}
@property (assign) IBOutlet NSTextField *label;
@property (assign) IBOutlet NSProgressIndicator *progress;
@property (assign) IBOutlet NSButton *cancelButton;
@property (assign) IBOutlet NSButton *startButton;

@property (readwrite, retain) NSOperationQueue *operationQueue;
@property (assign) IBOutlet NSTextField *downloadPathLabel;

- (IBAction)cancelAction:(id)sender;
- (IBAction)startAction:(id)sender;
- (IBAction)chooseDownloadTarget:(id)sender;

@end
