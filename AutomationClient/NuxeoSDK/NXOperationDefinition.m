//
//  NXOperationDefinition.m
//  AutomationClient
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import "NXOperationDefinition.h"

@implementation NXOperationDefinition

@synthesize identifier, URI;

- (void)dealloc {
    [identifier release];
    [URI release];
    [super dealloc];
}

@end
