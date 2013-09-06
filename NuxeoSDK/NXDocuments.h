//
//  NXDocuments.h
//  NuxeoSDK
//
//  Created by Arnaud Kervern on 9/5/13.
//  Copyright (c) 2013 Nuxeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXDocuments : NSObject <NXObject>
@property NSString *entityType;

@property NSString *isPaginable;
@property NSNumber *totalSize;
@property NSNumber *pageIndex;
@property NSNumber *pageSize;
@property NSNumber *pageCount;

@property NSMutableArray *entries;

@end
