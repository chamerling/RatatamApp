//
//  NotificationManager.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager


- (id)init
{
    self = [super init];
    if (self) {
        [GrowlApplicationBridge setGrowlDelegate:self];
    }
    
    return self;
}

- (void) notifyNewImage:(NSDictionary *)dictionary {
    //NSImage *image = [[[NSImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForImageResource:growllogo]] autorelease];
    
    NSString *url = [[[dictionary valueForKey:@"images"] valueForKey:@"thumbnail"]valueForKey:@"url"];
    
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *user = [dictionary valueForKey:@"user"];
    
    NSString *description = [NSString stringWithFormat:@"%@ added a photo", [user valueForKey:@"full_name"]];
    
    [GrowlApplicationBridge notifyWithTitle:@"New photo"
								description:description
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
