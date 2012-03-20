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
#import "InstagramClient.h"
#import "RatatamController.h"

@interface PhotoCellView : NSTableCellView<EGOImageViewDelegate> {

@private
    BOOL initialized;
    
    IBOutlet EGOImageView *image;
    IBOutlet NSTextField *username;
    IBOutlet NSTextField *date;
    IBOutlet NSTextField *caption;
    IBOutlet NSButton *likeButton;
    IBOutlet NSButton *commentButton;
    IBOutlet EGOImageView *contactImage;
    IBOutlet NSBox *box;
    
    InstagramPhoto *instagramPhoto;
    InstagramClient *client;
    RatatamController *controller;
    NSWindow *mainWindow;
}

@property(assign) InstagramPhoto *instagramPhoto;
@property(assign) InstagramClient *client;
@property(assign) RatatamController *controller;
@property(assign) NSWindow *mainWindow;

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

- (void)initialize:(id)sender;

- (IBAction)like:(id)sender;
- (IBAction)comment:(id)sender;

@end
