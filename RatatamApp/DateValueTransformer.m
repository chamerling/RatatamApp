//
//  DateValueTransformer.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 27/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DateValueTransformer.h"

@implementation DateValueTransformer

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
    return [NSDate dateWithTimeIntervalSince1970:[value longLongValue]];    
}

@end
