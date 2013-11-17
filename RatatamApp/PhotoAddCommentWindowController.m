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

#import "PhotoAddCommentWindowController.h"
#import "InstagramClient.h"

@implementation PhotoAddCommentWindowController
@synthesize titleField;
@synthesize photoView;
@synthesize progress;
@synthesize captionText;
@synthesize commentText;
@synthesize  photoData;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        //[self setWindow:window];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [titleField setStringValue:[NSString stringWithFormat:@"Comment %@'s photo", [[photoData valueForKey:@"user"] valueForKey:@"username"]]];
    [captionText setStringValue:[[photoData valueForKey:@"caption"] valueForKey:@"text"]];
    NSString *url = [[[photoData valueForKey:@"images"] valueForKey:@"thumbnail"] valueForKey:@"url"];
    [photoView setImage:[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]]];
}

- (IBAction)comment:(id)sender {
    NSString *text = [[commentText stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *photoId = [photoData valueForKey:@"id"];

    if (text && photoId) {
        [progress startAnimation:self];
        InstagramClient *client = [[InstagramClient alloc] init];
        [client commentPhoto:photoId commnent:text];
        [progress stopAnimation:self];
    } else {
        // i
        NSBeep();
    }
    
    [NSApp endSheet: [self window]];
    [[self window] orderOut: self];
}

- (void)cancel:(id)sender {
    [NSApp endSheet: [self window]];
    [[self window] orderOut: self];
}

@end
