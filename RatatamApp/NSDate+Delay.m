// (The MIT License)
//
// Copyright (c) 2013 Christophe Hamerling <christophe.hamerling@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// 'Software'), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
