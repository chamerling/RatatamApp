//
//  PhotoAddCommentWindowController.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 27/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PhotoAddCommentWindowController : NSWindowController {
    NSProgressIndicator *progress;
    NSTextField *captionText;
    NSImageView *photoView;
    NSTextField *titleField;
    
    NSDictionary *photoData;
    NSTextField *commentText;
}

- (IBAction) comment:(id)sender;
- (IBAction) cancel:(id)sender;

@property (assign) IBOutlet NSTextField *commentText;
@property (assign) NSDictionary *photoData;
@property (assign) IBOutlet NSTextField *titleField;
@property (assign) IBOutlet NSImageView *photoView;
@property (assign) IBOutlet NSProgressIndicator *progress;
@property (assign) IBOutlet NSTextField *captionText;

@end
