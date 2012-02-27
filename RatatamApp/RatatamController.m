//
//  RatatamController.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 23/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RatatamController.h"

#import "InstagramClient.h"

@interface RatatamController (Private)
- (void) doAddPhoto:(InstagramPhoto *) photo;
@end

@implementation RatatamController

@synthesize photos;

- (id)init {
    self = [super init];
    if (self) {
        photos = [[NSMutableArray alloc] init];
        
        /*
        InstagramClient *client = [[InstagramClient alloc] init];
        NSDictionary *result = [client getPhotosForUser:nil nb:5];
        
        NSDictionary *data = [result valueForKey:@"data"];
        for (NSDictionary *photo in data) {
                InstagramPhoto *ip = [[InstagramPhoto alloc] init];
                [ip setProperties:[[NSMutableDictionary alloc] initWithDictionary:photo]];
                [self addPhoto:ip];
            }
         */
         
        }
         
    return self;
}

- (void) addPhoto:(InstagramPhoto*) photo {
    if (photo) {
        
        for (NSDictionary *available in photos) {
            NSString *photoId = [[available valueForKey:@"properties"] valueForKey:@"id"];
            NSString *newPhotoId = [[photo valueForKey:@"properties"] valueForKey:@"id"];
            
            if ([photoId isEqualToString:newPhotoId]) {
                NSLog(@"Already in! %@", photoId);
                return;
            } else {
                // not in, tell that we have a new photo!
            
            }
        }
        
        [self performSelectorOnMainThread:@selector(doAddPhoto:) withObject:photo waitUntilDone:YES];
    }
}

// add photo to the array and then notify the table that there is a new photo. 
// This works with KVO and bindings.
- (void) doAddPhoto:(InstagramPhoto *) photo {
    
    // works but just for init, same with add object...
    //[photos insertObject:photo atIndex:0];
    
    // works in init too...
   // NSMutableArray *array = [[NSMutableArray alloc] initWithArray:photos];
    //[array addObject:photo];
    //[photos release];
    //photos = array;
    
    // this proxy is KVO enabled, not the photos array itself...
    id proxy = [self mutableArrayValueForKey:@"photos"];
    [proxy insertObject:photo atIndex:[proxy count]];
}

@end