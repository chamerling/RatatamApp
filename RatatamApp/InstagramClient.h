//
//  InstagramClient.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramClient : NSObject


- (NSDictionary*) getSelfUser:(NSString*) token;
- (NSDictionary*) getPhotosForUser:(NSString*) token nb:(int)size;
- (NSDictionary*) getCommentsForUser:(NSString*) token nb:(int)size;
- (NSDictionary*) getLikesForUser:(NSString*) token nb:(int)size;

@end
