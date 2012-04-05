//
//  BulkDownloadOperation.h
//  Ratatam
//
//  Created by Christophe Hamerling on 05/04/12.
//  Copyright 2012 christophehamerling.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BulkDownloadOperation;

@protocol BulkDownloadOperationDelegate 
- (void)photoDownloaded:(id)sender;
@end

@interface BulkDownloadOperation : NSOperation {
    NSObject<BulkDownloadOperationDelegate> *delegate;
    NSString *downloadPath;
    NSDictionary *photo;
}

@property (readwrite, assign) NSObject <BulkDownloadOperationDelegate> *delegate;
@property (readonly, copy) NSString *downloadPath;
@property (readonly, copy) NSDictionary *photo;

- (id) initWithPhoto:(NSDictionary *)photo downloadPath:(NSString *)downloadPath;

@end
