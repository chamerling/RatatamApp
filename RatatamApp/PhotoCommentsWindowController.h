//
//  PhotoCommentsWindowController.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 06/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoCommentsWindowController : NSWindowController {
    NSDictionary *photoData;
    NSMutableArray *array;
    
    NSScrollView *scrolllView;
    NSView *rootView;
    NSButton *disclosureButton;
    NSTextField *titleField;
    NSTextField *captionField;
    NSTextField *disclosureField;
    NSTextField *commentsCountField;
    NSTextField *commentText;
    NSImageView *photoView;
    NSProgressIndicator *progress;
}

@property (assign) IBOutlet NSProgressIndicator *progress;
@property (assign) IBOutlet NSImageView *photoView;
@property (assign) IBOutlet NSTextField *titleField;
@property (assign) IBOutlet NSTextField *captionField;
@property (assign) IBOutlet NSTextField *disclosureField;
@property (assign) IBOutlet NSTextField *commentsCountField;
@property (assign) IBOutlet NSTextField *commentText;

@property (assign) NSDictionary *photoData;
@property (assign) IBOutlet NSButton *disclosureButton;
@property (assign) IBOutlet NSScrollView *scrolllView;
@property (assign) IBOutlet NSView *rootView;

- (IBAction) showHideAction:(id)sender;
- (IBAction) comment:(id)sender;
- (IBAction) cancel:(id)sender;

@end
