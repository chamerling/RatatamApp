//
//  InstagramPhoto.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 23/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InstagramPhoto : NSObject {
    NSMutableDictionary *properties;
    NSString *name;
}    

@property (assign) NSMutableDictionary *properties;
@property (assign) NSString *name;

@end
