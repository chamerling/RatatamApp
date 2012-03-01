//
//  Preferences.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 01/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

- (void) setDefault;

// use oauth
- (NSString *) oauthToken;
- (void) storeToken:(NSString*)token;

+ (Preferences *)sharedInstance;

@end
