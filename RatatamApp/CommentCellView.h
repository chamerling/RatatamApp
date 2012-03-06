//
//  CommentCellView.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 06/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface CommentCellView : NSTableCellView {
    @private
        IBOutlet NSTextField *comment;
        IBOutlet NSTextField *name;
        IBOutlet NSImageView *image;
}

@property (assign) NSTextField *comment;
@property (assign) NSTextField *name;
@property (assign) NSImageView *image;

@end
