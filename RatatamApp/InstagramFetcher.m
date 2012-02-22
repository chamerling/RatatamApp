//
//  InstagramFetcher.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "InstagramFetcher.h"

@implementation InstagramFetcher

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        client = [[InstagramClient alloc] init];
        
    }
    
    return self;
}

- (void) pause {
    
}

- (void) resume {
    
}

- (void) start {
    
    // get data
    
    // save last for future cache
    
    // compare with last
    
    // send notifications
    
}

@end
