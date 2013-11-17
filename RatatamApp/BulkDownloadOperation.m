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
