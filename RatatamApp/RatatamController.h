//
//  RatatamController.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 23/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstagramPhoto.h"

@interface RatatamController : NSObject {
    NSMutableArray *photos;
    
    IBOutlet NSArrayController *arrayController;
}

@property (nonatomic, retain) NSMutableArray *photos;

- (void) addPhoto:(InstagramPhoto*) photo;

@end
