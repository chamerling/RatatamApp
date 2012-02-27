//
//  PhotoCellView.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface PhotoCellView : NSTableCellView {

@private
    IBOutlet NSImageView *image;
    IBOutlet NSTextField *username;
    IBOutlet NSTextField *date;
    IBOutlet NSButton *likeButton;
    IBOutlet NSButton *commentButton;
    IBOutlet NSImageView *contactImage;
    IBOutlet NSBox *box;
}

@property(assign) NSBox *box;
@property(assign) NSImageView *image;
@property(assign) NSImageView *contactImage;
@property(assign) NSTextField *username;
@property(assign) NSTextField *date;
@property(assign) NSButton *commentButton;
@property(assign) NSButton *likeButton;

@end
