//
//  PhotoAddCommentWindowController.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 27/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoAddCommentWindowController.h"

@implementation PhotoAddCommentWindowController

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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)comment:(id)sender {
    [NSApp endSheet: [self window]];
    [[self window] orderOut: self];
}

- (void)cancel:(id)sender {
    [NSApp endSheet: [self window]];
    [[self window] orderOut: self];
}

@end
