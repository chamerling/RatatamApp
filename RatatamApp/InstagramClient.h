//
//  InstagramClient.h
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramClient : NSObject

- (NSString *) getAuthToken;


- (NSDictionary*) getSelfUser;
- (NSDictionary*) getNPhotos:(int)size;
- (NSDictionary*) getPhotosSince:(NSString*)lastId;
- (NSDictionary*) getCommentsForUser:(int)size;
- (NSDictionary*) getLikesForUser:(int)size;
- (NSDictionary*) getCommentsForPhoto:(NSString*)photo;

- (BOOL) likePhoto:(NSString*)photo;
- (void) disLikePhoto:(NSString*)photo;

- (void) commentPhoto:(NSString*)photo commnent:(NSString*) comment;

@end
