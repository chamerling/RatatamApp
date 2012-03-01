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
- (void) doAddPhoto:(NSDictionary *) photo;
@end

@implementation RatatamController

@synthesize photos;

- (id)init {
    self = [super init];
    if (self) {
        photos = [[NSMutableArray alloc] init];
    }
         
    return self;
}

- (void) addPhoto:(InstagramPhoto*) photo atTop:(BOOL)top {
    if (photo) {
        
        for (NSDictionary *available in photos) {
            NSString *photoId = [[available valueForKey:@"properties"] valueForKey:@"id"];
            NSString *newPhotoId = [[photo valueForKey:@"properties"] valueForKey:@"id"];
            
            if ([photoId isEqualToString:newPhotoId]) {
                //NSLog(@"Already in! %@", photoId);
                return;
            } else {
                // not in, tell that we have a new photo!
                //NSLog(@"Not in, let's add!!!!");
            }
        }
        
        NSMutableDictionary *arg = [[NSMutableDictionary alloc] init];
        NSNumber *toptop = [[NSNumber alloc] initWithBool:top];
        [arg setValue:toptop forKey:@"top"];
        [arg setValue:photo forKey:@"photo"];
    
        [self performSelectorOnMainThread:@selector(doAddPhoto:) withObject:arg waitUntilDone:YES];
    }
}

// add photo to the array and then notify the table that there is a new photo. 
// This works with KVO and bindings.
- (void) doAddPhoto:(NSDictionary *) dict {
    
    // works but just for init, same with add object...
    //[photos insertObject:photo atIndex:0];
    
    // works in init too...
   // NSMutableArray *array = [[NSMutableArray alloc] initWithArray:photos];
    //[array addObject:photo];
    //[photos release];
    //photos = array;
    
    InstagramPhoto *photo = [dict valueForKey:@"photo"];
    NSNumber *top = [dict valueForKey:@"top"];
    
    // this proxy is KVO enabled, not the photos array itself...
    id proxy = [self mutableArrayValueForKey:@"photos"];
    NSInteger index = 0;
    if([top boolValue]) {
        index = [proxy count];
    } else {
        
    }
    
    [proxy insertObject:photo atIndex:index];
}

- (void) removeAllPhotos {
    NSLog(@"Remove all");
    id proxy = [self mutableArrayValueForKey:@"photos"];
    [proxy removeAllObjects];    
}

@end
