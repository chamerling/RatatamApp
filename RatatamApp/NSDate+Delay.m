//
//  NSDate+Delay.m
//  Ratatam
//
//  Created by Christophe Hamerling on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Delay.h"

@implementation NSDate (Delay)

- (NSString *)delay:(NSDate *)date {
    NSTimeInterval ti = -[date timeIntervalSinceNow];
    
    const NSTimeInterval kOneDay = 60 * 60 * 24;
    NSInteger days = floor(ti / kOneDay);
    if (days >= 1) {
        NSString *unit = (days == 1) ? @"day" : @"days";
        return [NSString stringWithFormat:@"%d %@ ago", days, unit];
    }
    
    const NSTimeInterval kOneHour = 60 * 60;
    if (ti >= kOneHour) {
        NSInteger hours = floor(ti / kOneHour + 0.5);
        NSString *unit = (hours == 1) ? @"hour" : @"hours";
        return [NSString stringWithFormat:@"%d %@ ago", hours, unit];
    }
    
    const NSTimeInterval kOneMinute = 60;
    if (ti >= kOneMinute) {
        NSInteger minutes = floor(ti / kOneMinute + 0.5);
        NSString *unit = (minutes == 1) ? @"minute" : @"minutes";
        return [NSString stringWithFormat:@"%d %@ ago", minutes, unit];
    }
    
    return @"less than a minute ago";
}

@end
