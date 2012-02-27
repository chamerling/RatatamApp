//
//  PhotoCellView.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCellView.h"
#import "PhotoAddCommentWindowController.h"

@implementation PhotoCellView
@synthesize image;
@synthesize contactImage;
@synthesize username;
@synthesize date;
@synthesize likeButton;
@synthesize commentButton;
@synthesize box;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        NSLog(@"BOXXXXXX %@", box);
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    NSLog(@"Init with frame %@", box);
    return self;
}

@end
