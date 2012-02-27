//
//  CommentPhotoViewController.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 27/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CommentPhotoViewController : NSViewController {
    NSScrollView *commentTextView;
    NSButton *commentAction;
    NSButton *commentButton;
}
@property (assign) IBOutlet NSButton *commentButton;
@property (assign) IBOutlet NSScrollView *commentTextView;

- (IBAction)cancelAction:(id)sender;
- (IBAction)commentAction:(id)sender;

@end
