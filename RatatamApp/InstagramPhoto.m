//
//  InstagramPhoto.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 23/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstagramPhoto.h"


@implementation InstagramPhoto
@synthesize properties;
@synthesize name;

- (id)init {
    if (self = [super init]) {
        NSArray * keys      = [NSArray arrayWithObjects: @"username", @"photo", @"date", @"body", nil];
        NSArray * values    = [NSArray arrayWithObjects: @"test@test.com", @"http://distillery.s3.amazonaws.com/media/2011/02/03/efc502667a554329b52d9a6bab35b24a_7.jpg", [NSDate date], [NSString string], nil];
        properties = [[NSMutableDictionary alloc] initWithObjects: values forKeys: keys];
        name = @"ABC";
    }
    return self; 
}

@end
