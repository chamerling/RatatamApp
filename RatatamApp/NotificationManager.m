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

#import "NotificationManager.h"

static NotificationManager *sharedInstance = nil;

@implementation NotificationManager

- (id)init
{
    self = [super init];
    if (self) {
        [GrowlApplicationBridge setGrowlDelegate:self];
    }
    
    return self;
}

+ (NotificationManager *)get {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[NotificationManager alloc] init];
    }
    return sharedInstance;
}

- (void) notifyNewImage:(NSDictionary *)dictionary {
    if (![GrowlApplicationBridge isGrowlRunning]) {
        // return now if growl is not installed not running, looks like it can cause problems...
        return;
    }
    
    NSString *url = [[[dictionary valueForKey:@"images"] valueForKey:@"thumbnail"]valueForKey:@"url"];
    
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *user = [dictionary valueForKey:@"user"];
    
    NSString *description = [NSString stringWithFormat:@"%@ added a photo", [user valueForKey:@"full_name"]];
    
    [GrowlApplicationBridge notifyWithTitle:@"New photo on Instagram"
								description:description
						   notificationName:@"Ratatam"
								   iconData:[image TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:nil]; 
}

- (void) notifyNewComment:(NSDictionary *)comment forPhoto:(NSDictionary*)photo {
    if (![GrowlApplicationBridge isGrowlRunning]) {
        // return now if growl is not installed not running, looks like it can cause problems...
        return;
    }
    
    NSString *url = [[[photo valueForKey:@"images"] valueForKey:@"thumbnail"]valueForKey:@"url"];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *from = [comment valueForKey:@"from"];
    
    NSString *title = [NSString stringWithFormat:@"%@ commented your photo", [from valueForKey:@"username"]];
    NSString *description = [NSString stringWithFormat:@"%@", [comment valueForKey:@"text"]];    
    [GrowlApplicationBridge notifyWithTitle:title
								description:description
						   notificationName:@"Ratatam"
								   iconData:[image TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:nil]; 
}

- (void) notifyNewLike:(NSDictionary *)dictionary {
    // NOP 
}

- (void) notifyError:(NSString *)error {
    if (![GrowlApplicationBridge isGrowlRunning]) {
        // return now if growl is not installed not running, looks like it can cause problems...
        return;
    }
    
    NSImage *image = [NSImage imageNamed:@"RatatamApp"];
    
    [GrowlApplicationBridge notifyWithTitle:@"Ratatam Error"
								description:error
						   notificationName:@"Ratatam"
								   iconData:[image TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

- (void) notifyOK:(NSString *)message {
    if (![GrowlApplicationBridge isGrowlRunning]) {
        // return now if growl is not installed not running, looks like it can cause problems...
        return;
    }
    
    NSImage *image = [NSImage imageNamed:@"RatatamApp"];
    
    [GrowlApplicationBridge notifyWithTitle:@"Ratatam Status"
								description:message
						   notificationName:@"Ratatam"
								   iconData:[image TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

#pragma mark - growl delegate
- (NSDictionary *)registrationDictionaryForGrowl {
    NSArray *notifications = [NSArray arrayWithObject: @"Ratatam"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          notifications, GROWL_NOTIFICATIONS_ALL,
                          notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
    return dict;
}


@end
