//
//  NXOperation.h
//  AutomationClient
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NXOperationDefinition;
@class NXOperationResult;
@protocol NXOperationDelegate;

@interface NXOperation : NSObject

@property (copy) NSDictionary* parameters;
@property (copy) id input;
@property (retain) NXOperationDefinition* definition;
@property (assign) id <NXOperationDelegate> delegate;

@end

@protocol NXOperationDelegate

- (void)operation:(NXOperation *)operation didFailWithError:(NSError *)error;
- (void)operation:(NXOperation *)operation didFinishWithResult:(NXOperationResult *)result;

@end
