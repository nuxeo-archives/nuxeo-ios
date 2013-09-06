//
//  NXObjectMapping.m
//  NuxeoSDK
//
//  Created by Arnaud Kervern on 9/5/13.
//  Copyright (c) 2013 Nuxeo. All rights reserved.
//

#import "NXObjectMapping.h"

@implementation NXObjectMapping

#pragma mark Convenience method for generating RKObjectMapping

+(RKObjectMapping *) document
{
    return [NXObjectMapping mappingForType:[NXDocument class]];
}
+(RKObjectMapping *) documents
{
    return [NXObjectMapping mappingForType:[NXDocuments class]];
}

+(RKMapping *) dynamic
{
    RKDynamicMapping *map = [RKDynamicMapping new];
    [map addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"entity-type" expectedValue:@"document" objectMapping:[[self class] document]]];
    [map addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"entity-type" expectedValue:@"documents" objectMapping:[[self class] documents]]];
    return map;
}

#pragma mark -
#pragma mark Private methods

+(RKObjectMapping *)mappingForType: (Class<NXObject>)type
{
    RKObjectMapping *map = [RKObjectMapping mappingForClass:type];
    [map addAttributeMappingsFromDictionary:[type mapping]];
    return map;
}

@end
