//
//  NotificationManager.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationManager.h"

static NotificationManager *sharedInstance = nil;

@implementation NotificationManager

- (id)init
{
    self = [super init];
    if (self) {
        [GrowlApplicationBridge setGrowlDelegate:self];
    }
    
    return self;
}

+ (NotificationManager *)get {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[NotificationManager alloc] init];
    }
    return sharedInstance;
}

- (void) notifyNewImage:(NSDictionary *)dictionary {
    if (![GrowlApplicationBridge isGrowlRunning]) {
        // return now if growl is not installed not running, looks like it can cause problems...
        return;
    }
    
    NSString *url = [[[dictionary valueForKey:@"images"] valueForKey:@"thumbnail"]valueForKey:@"url"];
    
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *user = [dictionary valueForKey:@"user"];
    
    NSString *description = [NSString stringWithFormat:@"%@ added a photo", [user valueForKey:@"full_name"]];
    
    [GrowlApplicationBridge notifyWithTitle:@"New photo on Instagram"
								description:description
						   notificationName:@"Ratatam"
								   iconData:[image TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:nil]; 
}

- (void) notifyNewComment:(NSDictionary *)comment forPhoto:(NSDictionary*)photo {
    if (![GrowlApplicationBridge isGrowlRunning]) {
        // return now if growl is not installed not running, looks like it can cause problems...
        return;
    }
    
    NSString *url = [[[photo valueForKey:@"images"] valueForKey:@"thumbnail"]valueForKey:@"url"];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *from = [comment valueForKey:@"from"];
    
    NSString *title = [NSString stringWithFormat:@"%@ commented your photo", [from valueForKey:@"username"]];
    NSString *description = [NSString stringWithFormat:@"%@", [comment valueForKey:@"text"]];    
    [GrowlApplicationBridge notifyWithTitle:title
								description:description
						   notificationName:@"Ratatam"
								   iconData:[image TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:nil]; 
}

- (void) notifyNewLike:(NSDictionary *)dictionary {
    // NOP 
}

- (void) notifyError:(NSString *)error {
    if (![GrowlApplicationBridge isGrowlRunning]) {
        // return now if growl is not installed not running, looks like it can cause problems...
        return;
    }
    
    NSImage *image = [NSImage imageNamed:@"RatatamApp"];
    
    [GrowlApplicationBridge notifyWithTitle:@"Ratatam Error"
								description:error
						   notificationName:@"Ratatam"
								   iconData:[image TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

- (void) notifyOK:(NSString *)message {
    if (![GrowlApplicationBridge isGrowlRunning]) {
        // return now if growl is not installed not running, looks like it can cause problems...
        return;
    }
    
    NSImage *image = [NSImage imageNamed:@"RatatamApp"];
    
    [GrowlApplicationBridge notifyWithTitle:@"Ratatam Status"
								description:message
						   notificationName:@"Ratatam"
								   iconData:[image TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

#pragma mark - growl delegate
- (NSDictionary *)registrationDictionaryForGrowl {
    NSArray *notifications = [NSArray arrayWithObject: @"Ratatam"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          notifications, GROWL_NOTIFICATIONS_ALL,
                          notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
    return dict;
}


@end
