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

#import <Foundation/Foundation.h>

@interface InstagramClient : NSObject

- (NSString *) getAuthToken;


- (NSDictionary*) getSelfUser;
- (NSDictionary*) getNPhotos:(int)size;
- (NSDictionary*) getPhotosSince:(NSString*)lastId;
- (NSDictionary*) getCommentsForUser:(int)size;
- (NSDictionary*) getLikesForUser:(int)size;
- (NSDictionary*) getCommentsForPhoto:(NSString*)photo;

// self photos
- (NSDictionary*) getNSelfPhotos:(int) size;
- (NSDictionary*) getSelfPhotosSince:(NSString*) lastId;
- (NSMutableSet*) getAllSelfPhotos;
// get all the photos for a given URL. This URL is generally retrived from a pagination object...
- (NSDictionary*) getPartSelfPhotos:(NSString *) baseURL;


- (BOOL) likePhoto:(NSString*)photo;
- (void) disLikePhoto:(NSString*)photo;

- (void) commentPhoto:(NSString*)photo commnent:(NSString*) comment;

@end
