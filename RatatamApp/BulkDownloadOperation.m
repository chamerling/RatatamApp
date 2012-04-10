//
//  BulkDownloadOperation.m
//  Ratatam
//
//  Created by Christophe Hamerling on 05/04/12.
//  Copyright 2012 christophehamerling.com. All rights reserved.
//

#import "BulkDownloadOperation.h"

@interface BulkDownloadOperation ()
@property (readwrite, copy) NSString *downloadPath;
@property (readwrite, copy) NSDictionary *photo;
@end

@implementation BulkDownloadOperation

@synthesize delegate;
@synthesize downloadPath;
@synthesize photo;


- (id) initWithPhoto:(NSDictionary *)newPhoto downloadPath:(NSString *)newDownloadPath {
    if (self = [super init]) {
        self.photo = newPhoto;
        self.downloadPath = newDownloadPath;
    }
    return self;
}

-(void)main {
    if ( self.isCancelled ) return;
        
    NSURL *url = [NSURL URLWithString:[[[photo valueForKey:@"images"] valueForKey:@"standard_resolution"] valueForKey:@"url"]];
    if (nil == url) return;
    
    NSData *imageData = [NSData dataWithContentsOfURL:url]; 
    if ( self.isCancelled ) return;
    
    NSString *filename = [NSString stringWithFormat:@"Image %@ - %@.%@", [photo valueForKey:@"created_time"], [photo valueForKey:@"id"], [[url path] pathExtension]];
    NSString *targetFolder = [self.downloadPath stringByAppendingPathComponent:filename];
    
    [imageData writeToFile:targetFolder atomically:NO];
    if (nil != delegate) {
        [delegate performSelectorOnMainThread:@selector(photoDownloaded:) withObject:self waitUntilDone:YES];
    }
}

@end
