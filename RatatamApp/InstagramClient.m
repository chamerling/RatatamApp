//
//  InstagramClient.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "InstagramClient.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@implementation InstagramClient

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSDictionary*) getSelfUser:(NSString*) token {
    NSString *url = @"https://api.instagram.com/v1/users/self/?access_token=714184.f59def8.cd491d15143d4f349095b2e960538e8a";
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getPhotosForUser:(NSString*) token nb:(int)size {
    NSString *tk = @"714184.f59def8.cd491d15143d4f349095b2e960538e8a";
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?count=%ld&access_token=%@", size, tk];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getPhotosForUser:(NSString*) token since:(NSString*)lastId {
    NSString *tk = @"714184.f59def8.cd491d15143d4f349095b2e960538e8a";

    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?min_id=%@&access_token=%@", lastId, tk];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getCommentsForUser:(NSString*) token nb:(int)size {
    return nil;
}

- (NSDictionary*) getLikesForUser:(NSString*) token nb:(int)size {
    return nil;
}

- (void) likePhoto:(NSString*) token photoId:(NSString*)photo {
    // /media/{media-id}/likes/
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes/", photo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:@"714184.f59def8.cd491d15143d4f349095b2e960538e8a" forKey:@"access_token"];
    //[request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startSynchronous];
    
    NSLog(@"Response %@", [request responseString]);
    NSLog(@"Code %d", [request responseStatusCode]);
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    NSLog(@"%@", dict);
}

- (void) disLikePhoto:(NSString*) token photoId:(NSString*)photo {
    // /media/{media-id}/likes/
    // /media/{media-id}/likes/
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes/&access_token=714184.f59def8.cd491d15143d4f349095b2e960538e8a", photo];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"DELETE"];
    [request setDelegate:self];
    [request startSynchronous];
    
    int code = [request responseStatusCode];
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    
    if (code != 200 && dict) {
        // ouch!
        NSString *error = [dict valueForKey:@"data"];
    } else {
        // well done...
    }
}

- (void) commentPhoto:(NSString*) token photoId:(NSString*)photo commnent:(NSString*) commennt {
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/comments", photo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:@"714184.f59def8.cd491d15143d4f349095b2e960538e8a" forKey:@"access_token"];
    [request setPostValue:commennt forKey:@"text"];

    [request setDelegate:self];
    [request startSynchronous];
    
    int code = [request responseStatusCode];
    NSDictionary* dict = [[request responseString] objectFromJSONString];

    if (code != 200 && dict) {
        // ouch!
        NSString *error = [dict valueForKey:@"data"];
    } else {
        // well done...
    }
}

@end
