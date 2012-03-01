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
#import "Preferences.h"

@implementation InstagramClient

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)getAuthToken {
    NSString* clientID = @"";
    NSString* redirectURI = @"";
    
    NSString* url = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token", clientID, redirectURI];
    
    // http://your-redirect-uri#access_token=ACCESS-TOKEN
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    int code = [request responseStatusCode];
    if (code == 200) {
        
    } else {
        
    }
    
    return nil;
    
    // https://instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=token

}

- (NSDictionary*) getSelfUser {
    Preferences *pref = [Preferences sharedInstance];
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/?access_token=%@", [pref oauthToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    if ([request responseStatusCode] == 0) {
        // fail!!!
        return nil;
    } 
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getNPhotos:(int)size {
    Preferences *pref = [Preferences sharedInstance];

    //NSString *tk = @"714184.f59def8.cd491d15143d4f349095b2e960538e8a";
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?count=%ld&access_token=%@", size, [pref oauthToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    if ([request responseStatusCode] == 0) {
        // fail!!!
        return nil;
    } 
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getPhotosSince:(NSString*)lastId {
    Preferences *pref = [Preferences sharedInstance];

    //NSString *tk = @"714184.f59def8.cd491d15143d4f349095b2e960538e8a";

    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?min_id=%@&access_token=%@", lastId, [pref oauthToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    if ([request responseStatusCode] == 0) {
        // fail!!!
        return nil;
    } 
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getCommentsForUser:(int)size {
    //Preferences *pref = [Preferences sharedInstance];

    return nil;
}

- (NSDictionary*) getLikesForUser:(int)size {
    //Preferences *pref = [Preferences sharedInstance];

    return nil;
}

- (void) likePhoto:(NSString*)photo {
    // /media/{media-id}/likes/
    Preferences *pref = [Preferences sharedInstance];

    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes/", photo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:[pref oauthToken] forKey:@"access_token"];
    //[request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startSynchronous];
    
    int code = [request responseStatusCode];
    
    if (code == 0) {
        return;
    }
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    
    if (code != 200 && dict) {
        // ouch!
        NSString *error = [dict valueForKey:@"data"];
    } else {
        // well done...
    }
}

- (void) disLikePhoto:(NSString*)photo {
    // /media/{media-id}/likes/
    // /media/{media-id}/likes/
    Preferences *pref = [Preferences sharedInstance];

    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes/&access_token=%@", photo, [pref oauthToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"DELETE"];
    [request setDelegate:self];
    [request startSynchronous];
    
    int code = [request responseStatusCode];
    if (code == 0) {
        return;
    }
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    
    if (code != 200 && dict) {
        // ouch!
        NSString *error = [dict valueForKey:@"data"];
    } else {
        // well done...
    }
}

- (void) commentPhoto:(NSString*)photo commnent:(NSString*) commennt {
    Preferences *pref = [Preferences sharedInstance];

    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/comments", photo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:[pref oauthToken] forKey:@"access_token"];
    [request setPostValue:commennt forKey:@"text"];

    [request setDelegate:self];
    [request startSynchronous];
    
    int code = [request responseStatusCode];
    
    if (code == 0) {
        return;    
    }
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];

    if (code != 200 && dict) {
        // ouch!
        NSString *error = [dict valueForKey:@"data"];
    } else {
        // well done...
    }
}

@end
