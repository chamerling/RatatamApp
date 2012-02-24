//
//  PhotoCellView.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCellView.h"

@implementation PhotoCellView
@synthesize image;
@synthesize contactImage;
@synthesize username;
@synthesize date;
@synthesize likes;
@synthesize comments;
@synthesize likeButton;
@synthesize commentButton;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)likeAction:(id)sender {
    
}

- (IBAction)commentAction:(id)sender{
    
}

- (IBAction)downloadAction:(id)sender {
    
}

- (IBAction)tweetAction:(id)sender {
    
}

@end
