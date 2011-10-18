//
//  NXOperation.m
//  AutomationClient
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import "NXOperation.h"

#import "NXOperationDefinition.h"

@implementation NXOperation

@synthesize parameters, input, definition, delegate;

- (void)dealloc {
    [parameters release];
    [input release];
    [definition release];
    [super dealloc];
}

@end
