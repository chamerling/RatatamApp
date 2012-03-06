//
//  PhotoCommentsWindowController.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 06/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

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
    [disclosureField setStringValue:[[photoData valueForKey:@"caption"] valueForKey:@"text"]];
    NSString *url = [[[photoData valueForKey:@"images"] valueForKey:@"thumbnail"] valueForKey:@"url"];
    [photoView setImage:[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]]];
    
    NSDictionary *comments = [[photoData valueForKey:@"comments"] valueForKey:@"data"];
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

- (void)hideComments {
    NSRect frameWinOld = [[self window] frame];
    CGFloat newHeight = frameWinOld.size.height - 180;
    
    [[self window] setFrame:NSMakeRect(frameWinOld.origin.x, frameWinOld.origin.y, frameWinOld.size.width, newHeight) display:YES animate:YES];
    [scrolllView setHidden:YES];
    [disclosureButton setHidden:YES];
    [commentsCountField setHidden:YES];
}
@end
