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

#import <AppKit/AppKit.h>
#import "EGOImageView.h"
#import "InstagramPhoto.h"
#import "InstagramClient.h"
#import "RatatamController.h"

@interface PhotoCellView : NSTableCellView<EGOImageViewDelegate> {

@private
    BOOL initialized;
    
    IBOutlet EGOImageView *image;
    IBOutlet NSTextField *username;
    IBOutlet NSTextField *date;
    IBOutlet NSTextField *caption;
    IBOutlet NSButton *likeButton;
    IBOutlet NSButton *commentButton;
    IBOutlet EGOImageView *contactImage;
    IBOutlet NSBox *box;
    
    InstagramPhoto *instagramPhoto;
    InstagramClient *client;
    RatatamController *controller;
    NSWindow *mainWindow;
}

@property(assign) InstagramPhoto *instagramPhoto;
@property(assign) InstagramClient *client;
@property(assign) RatatamController *controller;
@property(assign) NSWindow *mainWindow;

@property(assign) NSBox *box;
@property(assign) EGOImageView *image;
@property(assign) EGOImageView *contactImage;
@property(assign) NSTextField *username;
@property(assign) NSTextField *date;
@property(assign) NSTextField *caption;
@property(assign) NSButton *commentButton;
@property(assign) NSButton *likeButton;

- (void)setPhoto:(NSString*)photo;
- (void)setAvatar:(NSString*)url;

- (void)initialize:(id)sender;

- (IBAction)like:(id)sender;
- (IBAction)comment:(id)sender;

@end
