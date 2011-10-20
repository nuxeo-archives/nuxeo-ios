//
//  NXOperationQueue.h
//  AutomationClient
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NXOperation;
@class NXOperationResult;

@protocol NXOperationQueueDelegate;

@interface NXOperationQueue : NSObject
{
@private
    NSURL* _baseURL;
    CFMutableDictionaryRef _connectionToOperation;
    CFMutableDictionaryRef _operationToConnection;
    CFMutableDictionaryRef _connectionToData;
}

- (id)initWithServerURL:(NSURL *)anURL;

@property (readonly) NSURL* baseURL;

@property (assign) id <NXOperationQueueDelegate> delegate;

- (void)executeOperation:(NXOperation *)operation;
- (void)cancelOperation:(NXOperation *)operation;

@end

@protocol NXOperationQueueDelegate <NSObject>

@optional

- (BOOL)queue:(NXOperationQueue *)queue canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
- (void)queue:(NXOperationQueue *)queue didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
