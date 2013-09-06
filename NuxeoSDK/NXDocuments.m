//
//  NXDocuments.m
//  NuxeoSDK
//
//  Created by Arnaud Kervern on 9/5/13.
//  Copyright (c) 2013 Nuxeo. All rights reserved.
//

#import "NXDocuments.h"

@implementation NXDocuments

+(NSDictionary *)mapping {
    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    [map addEntriesFromDictionary:@{@"entity-type": @"entityType",
                                    @"isPaginable": @"isPaginable",
                                    @"totalSize" : @"totalSize",
                                    @"pageIndex" : @"pageIndex",
                                    @"pageSize" : @"pageSize",
                                    @"pageCount" : @"pageCount"}];
    return map;
}

@end
