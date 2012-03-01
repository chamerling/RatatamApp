//
//  Preferences.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 01/03/12.
//  Copyright 2012 christophehamerling.com. All rights reserved.
//

#import "Preferences.h"

static Preferences *sharedInstance = nil;

@implementation Preferences

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)setDefault {
}

- (NSString *)oauthToken {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *result = [prefs stringForKey:@"org.chamerling.ratatamapp.oauth"];
    
    if (!result) {
        result = [NSString stringWithString:@""];
    }
    return result;
}

- (void) storeToken:(NSString*)token {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:token forKey:@"org.chamerling.ratatamapp.oauth"];
}


+ (Preferences *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[Preferences alloc] init];
    }
    return sharedInstance;
}


@end
