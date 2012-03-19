//
//  PhotoCellView.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "EGOImageView.h"
#import "InstagramPhoto.h"

@interface PhotoCellView : NSTableCellView<EGOImageViewDelegate> {

@private
    IBOutlet EGOImageView *image;
    IBOutlet NSTextField *username;
    IBOutlet NSTextField *date;
    IBOutlet NSTextField *caption;
    IBOutlet NSButton *likeButton;
    IBOutlet NSButton *commentButton;
    IBOutlet EGOImageView *contactImage;
    IBOutlet NSBox *box;
    
    InstagramPhoto *instagramPhoto;
}

@property(assign) InstagramPhoto *instagramPhoto;

@property(assign) NSBox *box;
@property(assign) EGOImageView *image;
@property(assign) EGOImageView *contactImage;
@property(assign) NSTextField *username;
@property(assign) NSTextField *date;
@property(assign) NSTextField *caption;
@property(assign) NSButton *commentButton;
@property(assign) NSButton *likeButton;

- (void)setPhoto:(NSString*)photo;
- (void)setAvatar:(NSString*)url;

- (IBAction)like:(id)sender;
- (IBAction)comment:(id)sender;

@end
