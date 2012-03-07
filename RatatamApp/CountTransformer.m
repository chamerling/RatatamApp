//
//  CountTransformer.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 07/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CountTransformer.h"

@implementation CountTransformer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (!value) {
        return @"0";
    }
    
    NSDictionary *dict = value;
    if (dict && [dict valueForKey:@"count"]) {
        return [NSString stringWithFormat:@"%@", [dict valueForKey:@"count"]];
    }
    
    return @"0";
}

@end
