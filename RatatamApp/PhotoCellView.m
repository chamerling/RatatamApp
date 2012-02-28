//
//  PhotoCellView.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCellView.h"
#import "PhotoAddCommentWindowController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotoCellView
@synthesize image;
@synthesize contactImage;
@synthesize username;
@synthesize date;
@synthesize likeButton;
@synthesize commentButton;
@synthesize box;

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
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

@end
