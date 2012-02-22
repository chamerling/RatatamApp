//
//  InstagramFetcher.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstagramClient.h"

@interface InstagramFetcher : NSObject
{
    NSDictionary *latest;
    InstagramClient *client;    
}

- (void) pause;
- (void) resume;
- (void) start;

@end
