//
//  PhotoCellView.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCellView.h"
#import "PhotoAddCommentWindowController.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "PhotoCommentsWindowController.h"

@implementation PhotoCellView
@synthesize image;
@synthesize contactImage;
@synthesize username;
@synthesize date;
@synthesize caption;
@synthesize likeButton;
@synthesize commentButton;
@synthesize box;
@synthesize instagramPhoto;
@synthesize client;
@synthesize controller;
@synthesize mainWindow;

- (id)init {
    self = [super init];
    if (self) {
        // not called
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // not called...
        
        image = [[EGOImageView alloc] initWithPlaceholderImage:[NSImage imageNamed:@"loading.gif"] delegate:self];
        [self addSubview:image];
    }
    
    return self;
}

- (void)initialize:(id)sender {
    if (!initialized) {
        NSLog(@"Initializing...");
        image = [[EGOImageView alloc] initWithPlaceholderImage:[NSImage imageNamed:@"loading.gif"] delegate:self];
        [self addSubview:image];

        initialized = YES;
    }
}

- (void)setPhoto:(NSString*)photo {
	image.imageURL = [NSURL URLWithString:photo];
}

- (void)setAvatar:(NSString*)url {
    contactImage.imageURL = [NSURL URLWithString:url];
}

- (void)drawRect:(NSRect)dirtyRect {
    // This is called each time a cell is displayed...
    
    /*
    CGSize size = box.bounds.size;
	CGFloat curlFactor = 15.0f;
	CGFloat shadowDepth = 5.0f;
    
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path moveToPoint:CGPointMake(0.0f, 0.0f)];
	[path lineToPoint:CGPointMake(size.width, 0.0f)];
	[path lineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
	[path curveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
			controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
			controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
    
    box.layer.shadowPath = path.CGPath;
     */
}

- (void)imageViewLoadedImage:(EGOImageView*)imageView {
    NSLog(@"Image has been loaded : %@", imageView.imageURL);
}

#pragma mark - Instagram interaction
- (IBAction)like:(id)sender {
    [self performSelectorInBackground:@selector(doLike:) withObject:sender];            
}

- (void) doLike:(id)sender {
    [controller startStatusMessage:@"Liking..."];
        
    BOOL liked = [client likePhoto:[[instagramPhoto properties] valueForKey:@"id"]];
    if (liked) {
        [controller stopStatusMessage:@"Done!" withDelay:0];
    } else {
        [controller stopStatusMessage:@"Problem while liking!" withDelay:0];
    }
}

- (IBAction)comment:(id)sender {
    
    PhotoCommentsWindowController *commentsWindow = [[PhotoCommentsWindowController alloc] initWithWindowNibName:@"PhotoCommentsWindow"];
    
    [controller startProgress:nil];
    NSDictionary *data = [instagramPhoto properties];
    NSDictionary *comments = [client getCommentsForPhoto:[data valueForKey:@"id"]];
    [controller stopProgress];
    
    NSDictionary *commentsData = nil;
    if (comments) {
        commentsData = [comments valueForKey:@"data"];
    } else {
        commentsData = [[data valueForKey:@"comments"] valueForKey:@"data"];
    }
    
    NSMutableDictionary *photoData = [[NSMutableDictionary alloc] initWithDictionary:data copyItems:NO];
    
    [commentsWindow setPhotoData:photoData];
    [commentsWindow setComments:commentsData];
    [NSApp beginSheet:[commentsWindow window] modalForWindow:mainWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

@end
