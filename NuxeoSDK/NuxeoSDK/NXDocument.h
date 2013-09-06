//
//  NXDocument.h
//  NuxeoSDK
//
//  Created by Arnaud Kervern on 9/4/13.
//  Copyright (c) 2013 Nuxeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXDocument : NSObject <NXObject>
@property NSString *entityType;

@property NSString *repository;
@property NSString *uid;
@property NSString *path;
@property NSString *type;
@property NSString *name;

@property NSString *state;
@property NSString *versionLabel;

@property NSString *title;
@property NSDate *lastModified;

@property NSArray *facets;
@property NSString *changeToken;

@property NSDictionary *properties;
@property NSDictionary *contextParameters;

@end