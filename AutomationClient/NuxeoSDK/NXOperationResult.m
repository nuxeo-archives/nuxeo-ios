//
//  NXOperationResult.m
//  AutomationClient
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import "NXOperationResult.h"

@implementation NXOperationResult

@synthesize output;

- (void)dealloc {
    [output release];
    [super dealloc];
}

@end
