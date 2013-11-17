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

#import <Foundation/Foundation.h>

@interface PhotoCommentsWindowController : NSWindowController {
    NSDictionary *photoData;
    NSDictionary *comments;
    NSMutableArray *array;
    
    NSScrollView *scrolllView;
    NSView *rootView;
    NSButton *disclosureButton;
    NSTextField *titleField;
    NSTextField *captionField;
    NSTextField *disclosureField;
    NSTextField *commentsCountField;
    NSTextField *commentText;
    NSImageView *photoView;
    NSProgressIndicator *progress;
}

@property (assign) IBOutlet NSProgressIndicator *progress;
@property (assign) IBOutlet NSImageView *photoView;
@property (assign) IBOutlet NSTextField *titleField;
@property (assign) IBOutlet NSTextField *captionField;
@property (assign) IBOutlet NSTextField *disclosureField;
@property (assign) IBOutlet NSTextField *commentsCountField;
@property (assign) IBOutlet NSTextField *commentText;

@property (assign) NSDictionary *photoData;
@property (assign) NSDictionary *comments;
@property (assign) IBOutlet NSButton *disclosureButton;
@property (assign) IBOutlet NSScrollView *scrolllView;
@property (assign) IBOutlet NSView *rootView;

- (IBAction) showHideAction:(id)sender;
- (IBAction) comment:(id)sender;
- (IBAction) cancel:(id)sender;

@end
