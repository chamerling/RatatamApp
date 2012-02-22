//
//  InstagramClient.m
//  RatatamApp
//
//  Created by Christophe Hamerling on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "InstagramClient.h"
#import "ASIHTTPRequest.h"
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
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?count=%ld&access_token=714184.f59def8.cd491d15143d4f349095b2e960538e8a", size];
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

@end
