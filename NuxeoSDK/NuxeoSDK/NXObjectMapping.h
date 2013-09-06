//
//  NXObjectMapping.h
//  NuxeoSDK
//
//  Created by Arnaud Kervern on 9/5/13.
//  Copyright (c) 2013 Nuxeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NXObject <NSObject>

@required
+(NSDictionary *) mapping;

@end

@interface NXObjectMapping : NSObject

+(RKObjectMapping *) document;
+(RKObjectMapping *) documents;

+(RKMapping *) dynamic;

@end