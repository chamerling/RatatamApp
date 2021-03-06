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

#import "InstagramClient.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "Preferences.h"
#import "NotificationManager.h"

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
        [[NotificationManager get] notifyError:@"Error while sending request"];
        return nil;
    } 
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getNPhotos:(int)size {
    Preferences *pref = [Preferences sharedInstance];

    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?count=%ld&access_token=%@", size, [pref oauthToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    if ([request responseStatusCode] == 0) {
        // fail!!!
        [[NotificationManager get] notifyError:@"Error while sending request"];
        return nil;
    } 
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getNSelfPhotos:(int)size {
    Preferences *pref = [Preferences sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?count=%ld&access_token=%@", size, [pref oauthToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    if ([request responseStatusCode] == 0) {
        // fail!!!
        [[NotificationManager get] notifyError:@"Error while sending request"];
        return nil;
    } 
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getCommentsForPhoto:(NSString*)photo {
    Preferences *pref = [Preferences sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/comments?access_token=%@", photo, [pref oauthToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    if ([request responseStatusCode] == 0) {
        // fail!!!
        [[NotificationManager get] notifyError:@"Error while sending request"];
        return nil;
    } 
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getPhotosSince:(NSString*)lastId {
    Preferences *pref = [Preferences sharedInstance];

    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?min_id=%@&access_token=%@", lastId, [pref oauthToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    if ([request responseStatusCode] == 0) {
        // fail!!!
        [[NotificationManager get] notifyError:@"Error while sending request"];
        return nil;
    } 
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    return dict;
}

- (NSDictionary*) getSelfPhotosSince:(NSString*)lastId {
    Preferences *pref = [Preferences sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?min_id=%@&access_token=%@", lastId, [pref oauthToken]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startSynchronous];
    
    if ([request responseStatusCode] == 0) {
        // fail!!!
        [[NotificationManager get] notifyError:@"Error while sending request"];
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

- (BOOL) likePhoto:(NSString*)photo {
    // /media/{media-id}/likes/
    Preferences *pref = [Preferences sharedInstance];

    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes/", photo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:[pref oauthToken] forKey:@"access_token"];
    [request setDelegate:self];
    [request startSynchronous];
    
    int code = [request responseStatusCode];
    
    if (code == 0) {
        [[NotificationManager get] notifyError:@"Error while sending request"];
        return NO;
    }
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    
    if (code != 200 && dict) {
        // ouch!
        NSString *error = [dict valueForKey:@"data"];
        [[NotificationManager get] notifyError:@"Error while liking image"];
        return NO;

    } else {
        // well done...
        [[NotificationManager get] notifyOK:@"Image liked"];
        return YES;
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
        [[NotificationManager get] notifyError:@"Error while sending request"];
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
        [[NotificationManager get] notifyError:@"Error while sending request"];
        return;    
    }
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];

    if (code != 200 && dict) {
        // ouch!
        NSString *error = [dict valueForKey:@"data"];
        [[NotificationManager get] notifyError:@"Error while commenting image"];

    } else {
        // well done...
        [[NotificationManager get] notifyOK:@"Photo commented"];
    }
}

- (NSMutableSet*) getAllSelfPhotos {
    Preferences *pref = [Preferences sharedInstance];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    
    // initial URL
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?access_token=%@", [pref oauthToken]];
    
    while (url) {
        NSDictionary *dict = [self getPartSelfPhotos:url];
        if (dict) {
            NSDictionary *data = [dict valueForKey:@"data"];
            if (data) {
                for (NSDictionary *photo in data) {
                    [set addObject:photo];
                }
            }
            
            if ([dict valueForKey:@"pagination"] && [[dict valueForKey:@"pagination"] valueForKey:@"next_url"]) {
                url = [[dict valueForKey:@"pagination"] valueForKey:@"next_url"];
            } else{
                url = nil;
            }
        } else {
            url = nil;
        }
    }
    return set;
}

- (NSDictionary*) getPartSelfPhotos:(NSString *) baseURL {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:baseURL]];
    [request setDelegate:self];
    [request startSynchronous];
    
    if ([request responseStatusCode] == 0) {
        // fail!!!
        //[[NotificationManager get] notifyError:@"Error while sending request"];
        return nil;
    } 
    
    NSDictionary* dict = [[request responseString] objectFromJSONString];
    
    return dict;
}

@end
