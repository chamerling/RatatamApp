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
#import "BulkDownloadOperation.h"

@interface BulkDownloadWindowController : NSWindowController<BulkDownloadOperationDelegate> {
    
    NSString *selectedPath;
    NSString *downloadFolder;
    
    NSButton *cancelButton;
    NSButton *startButton;
    NSTextField *importTo;
    NSMenu *importToMenu;
    NSProgressIndicator *progress;
    NSTextField *label;
    
    NSOperationQueue *operationQueue;
    NSTextField *downloadPathLabel;
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
@property (assign) IBOutlet NSTextField *importTo;

@property (readwrite, retain) NSOperationQueue *operationQueue;
@property (assign) IBOutlet NSTextField *downloadPathLabel;
@property (assign) IBOutlet NSPopUpButton *popupButton;

- (IBAction)cancelAction:(id)sender;
- (IBAction)startAction:(id)sender;
- (IBAction)chooseDownloadTarget:(id)sender;

@end
