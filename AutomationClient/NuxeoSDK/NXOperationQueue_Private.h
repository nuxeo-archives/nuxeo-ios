//
//  NXOperationQueue_Private.h
//  AutomationClient
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import "NXOperationQueue.h"

@class NXOperationResult;

@interface NXOperationQueue () <NSURLConnectionDelegate>

+ (NSURLRequest *)requestForOperation:(NXOperation *)operation forServerURL:(NSURL *)serverURL error:(NSError **)error;
+ (NXOperationResult *)operationResultForJSONObject:(id)object;

@end
