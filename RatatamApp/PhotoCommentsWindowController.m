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
#import "PhotoCommentsWindowController.h"
#import "CommentCellView.h"
#import "InstagramClient.h"

@interface PhotoCommentsWindowController (Private)
- (void) hideComments;
@end

@implementation PhotoCommentsWindowController
@synthesize progress;
@synthesize photoView;

@synthesize disclosureButton;
@synthesize scrolllView;
@synthesize rootView;
@synthesize titleField;
@synthesize captionField;
@synthesize disclosureField;
@synthesize commentsCountField;
@synthesize commentText;
@synthesize photoData;
@synthesize comments;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        //[self setWindow:window];
        array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)windowWillLoad {
    
}

- (void)windowDidLoad
{
    [super windowDidLoad];
        
    [titleField setStringValue:[NSString stringWithFormat:@"Comment %@'s photo", [[photoData valueForKey:@"user"] valueForKey:@"username"]]];
    
    if ([photoData valueForKey:@"caption"] != [NSNull null]) {
        [disclosureField setStringValue:[[photoData valueForKey:@"caption"] valueForKey:@"text"]];
    } else {
        [disclosureField setStringValue:@""];        
    }
    
    NSString *url = [[[photoData valueForKey:@"images"] valueForKey:@"thumbnail"] valueForKey:@"url"];
    [photoView setImage:[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]]];
    
    //NSDictionary *comments = [[photoData valueForKey:@"comments"] valueForKey:@"data"];
    NSInteger index = 0;
    for (NSDictionary *comment in comments) {
        [array insertObject:comment atIndex:index];
        index ++;
    }
    
    if (index == 0) {
        [self hideComments];
    } else {
        [commentsCountField setStringValue:[NSString stringWithFormat:@"Comments (%ld)", index]];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
   return [array count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    CommentCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    NSDictionary *comment = [array objectAtIndex:row];
    [result.name setStringValue:[[comment valueForKey:@"from"] valueForKey:@"username"]];
    [result.comment setStringValue:[comment valueForKey:@"text"]];   
        
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[[comment valueForKey:@"from"] valueForKey:@"profile_picture"]]];
    [result.imageView setImage:image];
        
    return result;
}

- (IBAction)showHideAction:(id)sender {
    
    NSRect frameWinOld = [[self window] frame];

    switch ([sender state]) {
        case NSOnState:
            [scrolllView setHidden:NO];
            
            [[self window] setFrame:NSMakeRect(frameWinOld.origin.x, frameWinOld.origin.y, frameWinOld.size.width, frameWinOld.size.height + 180) display:YES animate:YES];
            break;
            
        case NSOffState:            
            [[self window] setFrame:NSMakeRect(frameWinOld.origin.x, frameWinOld.origin.y, frameWinOld.size.width, frameWinOld.size.height - 180) display:YES animate:YES];
            [scrolllView setHidden:YES];

            break;
        default:
            break;
    }
}

- (IBAction)comment:(id)sender {
    NSString *text = [[commentText stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *photoId = [photoData valueForKey:@"id"];
    
    if (text && [text length] > 0 && photoId) {
        [progress startAnimation:self];
        InstagramClient *client = [[InstagramClient alloc] init];
        [client commentPhoto:photoId commnent:text];
        [progress stopAnimation:self];
        
        [NSApp endSheet: [self window]];
        [[self window] orderOut: self];
    } else {
        // i
        NSBeep();
    }
}

- (void)cancel:(id)sender {
    [NSApp endSheet: [self window]];
    [[self window] orderOut: self];
}

- (void)hideComments {
    NSRect frameWinOld = [[self window] frame];
    CGFloat newHeight = frameWinOld.size.height - 180;
    
    [[self window] setFrame:NSMakeRect(frameWinOld.origin.x, frameWinOld.origin.y, frameWinOld.size.width, newHeight) display:YES animate:YES];
    [scrolllView setHidden:YES];
    [disclosureButton setHidden:YES];
    [commentsCountField setHidden:YES];
}
@end
