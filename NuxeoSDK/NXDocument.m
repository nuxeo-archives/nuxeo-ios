//
//  NXDocument.m
//  NuxeoSDK
//
//  Created by Arnaud Kervern on 9/4/13.
//  Copyright (c) 2013 Nuxeo. All rights reserved.
//

#import "NXDocument.h"

@implementation NXDocument

+(NSDictionary *)mapping {
    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    [map addEntriesFromDictionary: @{@"repository": @"repository",
                                     @"uid": @"uid",
                                     @"name": @"name",
                                     @"path": @"path",
                                     @"type": @"type",
                                     @"entity-type": @"entityType",
                                     @"state": @"state",
                                     @"versionLabel": @"versionLabel",
                                     @"title": @"title",
                                     @"lastModified": @"lastModified",
                                     @"facets": @"facets",
                                     @"changeToken": @"changeToken",
                                     @"contextParameters": @"contextParameters",
                                     @"properties": @"properties"}];
    return map;
}

@end
