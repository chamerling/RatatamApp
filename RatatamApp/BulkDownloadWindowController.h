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
    
    NSString *selectedPath;
    NSString *downloadFolder;
    
    NSButton *cancelButton;
    NSButton *startButton;
    NSMenu *importToMenu;
    NSProgressIndicator *progress;
    NSTextField *label;
    
    NSOperationQueue *operationQueue;
    NSTextField *downloadPathLabel;
    NSMenuItem *targetMenuItem;
    NSMenuItem *separator;
    NSPopUpButton *popupButton;
    NSInteger nbPhotos;
    NSInteger nbDownloads;
}

@property (nonatomic, retain) NSString *selectedPath;
@property (nonatomic, retain) NSString *downloadFolder;

@property (assign) IBOutlet NSTextField *label;
@property (assign) IBOutlet NSProgressIndicator *progress;
@property (assign) IBOutlet NSButton *cancelButton;
@property (assign) IBOutlet NSButton *startButton;
@property (assign) IBOutlet NSMenu *importToMenu;

@property (readwrite, retain) NSOperationQueue *operationQueue;
@property (assign) IBOutlet NSTextField *downloadPathLabel;
@property (assign) IBOutlet NSMenuItem *targetMenuItem;
@property (assign) IBOutlet NSMenuItem *separator;
@property (assign) IBOutlet NSPopUpButton *popupButton;

- (IBAction)cancelAction:(id)sender;
- (IBAction)startAction:(id)sender;
- (IBAction)chooseDownloadTarget:(id)sender;

@end
