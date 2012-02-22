//
//  NotificationManager.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Growl/GrowlApplicationBridge.h>

@interface NotificationManager : NSObject<GrowlApplicationBridgeDelegate>

- (void) notifyNewImage:(NSDictionary *)dictionary;

@end
