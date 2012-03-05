//
//  PhotoAddCommentWindowController.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 27/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

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
