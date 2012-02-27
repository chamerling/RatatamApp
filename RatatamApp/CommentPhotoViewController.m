//
//  CommentPhotoViewController.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 27/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentPhotoViewController.h"

@implementation CommentPhotoViewController
@synthesize commentButton;
@synthesize commentTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)cancelAction:(id)sender {
}

- (IBAction)commentAction:(id)sender {
}
@end
