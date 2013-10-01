//
//  NuxeoSDKTests.m
//  NuxeoSDKTests
//
//  Created by Arnaud Kervern on 9/4/13.
//  Copyright (c) 2013 Nuxeo. All rights reserved.
//

#import <XCTest/XCTest.h>
#include <stdlib.h>

@interface NuxeoSDKTests : XCTestCase
@end

@implementation NuxeoSDKTests

#pragma mark -

- (void)setUp
{
    [super setUp];
    [RKTestFixture setFixtureBundle:[NSBundle bundleForClass:[self class]]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark -
#pragma mark Mappings ! SHOULD BE MOVED

+(id) documentsMapping
{
    RKObjectMapping *map = [RKObjectMapping mappingForClass:[NXDocuments class]];
    [map addAttributeMappingsFromDictionary:[NXDocuments mapping]];
    [map addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"entries" toKeyPath:@"entries" withMapping:[[self class] documentMapping]]];
    return map;
}

+(id) documentMapping
{
    RKObjectMapping *map = [RKObjectMapping mappingForClass:[NXDocument class]];
    [map addAttributeMappingsFromDictionary:[NXDocument mapping]];

    return map;
}

+(RKObjectManager *) nxManager
{
    NSURL *URL = [NSURL URLWithString:@"http://localhost:8080/nuxeo/site/api/v1"];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:URL];
    [manager.HTTPClient setAuthorizationHeaderWithUsername:@"Administrator" password:@"Administrator"];
    [manager.HTTPClient setDefaultHeader:@"X-NXDocumentProperties" value:@"*"];
    [manager setRequestSerializationMIMEType:RKMIMETypeJSON];

    RKResponseDescriptor *response = [RKResponseDescriptor responseDescriptorWithMapping:[[self class] dynamicMapping] method:RKRequestMethodAny pathPattern:Nil keyPath:Nil statusCodes:Nil];
    [manager addResponseDescriptor:response];

    return manager;
}

+(RKDynamicMapping *) dynamicMapping
{
    RKDynamicMapping *map = [RKDynamicMapping new];
    [map addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"entity-type" expectedValue:@"document" objectMapping:[[self class] documentMapping]]];
    [map addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"entity-type" expectedValue:@"documents" objectMapping:[[self class] documentsMapping]]];
    return map;
}

+(NXDocument *) createDocument: (NXDocument *)document inParent: (NSString *)path {
    RKObjectManager *manager = [[self class] nxManager];

    RKObjectMapping *truc = [RKObjectMapping requestMapping];
    [truc addAttributeMappingsFromDictionary:[NXDocument mapping]];

    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[truc inverseMapping] objectClass:[NXDocument class] rootKeyPath:Nil method:RKRequestMethodPOST];
    [manager addRequestDescriptor:requestDescriptor];

    RKObjectRequestOperation *request = [manager appropriateObjectRequestOperationWithObject:document method:RKRequestMethodPOST path:[NSString stringWithFormat:@"path/%@", path] parameters:Nil];
    [request start];
    [request waitUntilFinished];

    return request.targetObject;
}

#pragma mark -
#pragma mark Test cases

- (void) testDocumentMapping
{
    NXDocument *doc = [[NXDocument alloc] init];
    XCTAssertNil(doc.uid);
    id docJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"document1.json"];

    RKMappingTest *test = [RKMappingTest testForMapping:[[self class] documentMapping] sourceObject:docJSON destinationObject:doc];

    XCTAssertTrue([test evaluateExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"repository" destinationKeyPath:@"repository" value:@"default"] error:Nil]);

    [test performMapping];

    XCTAssertEqualObjects(@"document", doc.entityType);
    XCTAssertEqualObjects(@"default", doc.repository);
    XCTAssertEqualObjects(@"37b1502b-26ff-430f-9f20-4bd0d803191e", doc.uid);
    XCTAssertEqualObjects(@"/default-domain", doc.path);
    XCTAssertEqualObjects(@"Domain", doc.type);
    XCTAssertEqualObjects(@"project", doc.state);
    XCTAssertEqualObjects(@"", doc.versionLabel);
    XCTAssertEqualObjects(@"Default domain", doc.title);
    XCTAssertNotEqualObjects([NSNull null], doc.lastModified);

    XCTAssertEqualObjects([NSDate dateWithString:@"2013-07-20 05:58:58 +0"], doc.lastModified);

    XCTAssertTrue(2 == doc.facets.count);
    XCTAssertEqualObjects(@"SuperSpace", doc.facets[0]);
    XCTAssertEqualObjects(@"1374299938988", doc.changeToken);
    XCTAssertEqualObjects(@"/nuxeo/site/api/v1/id/afb373f1-08ed-4228-bfe8-9f93131f8c84", doc.contextParameters[@"documentURL"]);
    XCTAssertEqualObjects([NSNull null], doc.properties[@"common:icon-expanded"]);
    XCTAssertEqualObjects(@"/icons/domain.gif", doc.properties[@"common:icon"]);
}

-(void) testDocumentsMapping
{
    NXDocuments *docs = [[NXDocuments alloc] init];
    id JSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"documents1.json"];
    if (!JSON) {
        XCTFail(@"JSON null");
        return;
    }

    RKMappingTest *map = [RKMappingTest testForMapping:[[self class] documentsMapping] sourceObject:JSON destinationObject:docs];
    [map performMapping];

    XCTAssertEqualObjects(@"documents", docs.entityType);
    XCTAssertEqualObjects(@"true", docs.isPaginable);
    XCTAssertEqualObjects([NSNumber numberWithInt:1], docs.pageCount);
    XCTAssertEqualObjects([NSNumber numberWithInt:0], docs.pageIndex);
    XCTAssertEqualObjects([NSNumber numberWithInt:50], docs.pageSize);
    XCTAssertEqualObjects([NSNumber numberWithInt:3], docs.totalSize);

    // Docs
    XCTAssertTrue(2 == docs.entries.count);
    NXDocument *doc1 = docs.entries[0];
    XCTAssertEqualObjects(@"document", doc1.entityType);
    XCTAssertEqualObjects(@"/nuxeo/site/api/v1/id/afb373f1-08ed-4228-bfe8-9f93131f8c84", doc1.contextParameters[@"documentURL"]);
}

-(void) testDocumentRequestOperation
{
    RKObjectManager *manager = [[self class] nxManager];

    NXDocument *doc = [[NXDocument alloc] init];
    RKObjectRequestOperation *requestOperation = [manager appropriateObjectRequestOperationWithObject:doc method:RKRequestMethodGET path:@"path/default-domain" parameters:Nil];
    [requestOperation start];
    [requestOperation waitUntilFinished];

    doc = requestOperation.targetObject;

    XCTAssertNotNil(doc);
    XCTAssertEqualObjects(@"document", doc.entityType);
    XCTAssertEqualObjects(@"Default domain", doc.title);
    XCTAssertEqualObjects(@"project", doc.state);
    XCTAssertEqualObjects(@"/default-domain", doc.path);
    XCTAssertTrue(doc.properties.count > 0);
}

-(void) testDocumentsRequestOperation
{
    RKObjectManager *manager = [[self class] nxManager];

    NXDocuments *docs = [[NXDocuments alloc] init];
    RKObjectRequestOperation *request = [manager appropriateObjectRequestOperationWithObject:docs method:RKRequestMethodGET path:@"path/@children" parameters:Nil];
    [request start];
    [request waitUntilFinished];

    XCTAssertNotNil(docs);
    XCTAssertEqualObjects(@"documents", docs.entityType);
    NSLog(@"-- %lu", (unsigned long)docs.entries.count);
    XCTAssertTrue(docs.entries.count >= 1);
    NXDocument *doc = docs.entries[0];
    XCTAssertEqualObjects(@"Default domain", doc.title);
}

-(void) testDocumentUpdate
{
    RKObjectManager *manager = [[self class] nxManager];
    NXDocument *doc = [NXDocument new];
    doc.type = @"File";
    doc.title = @"My Document";

    doc = [[NuxeoSDKTests class] createDocument:doc inParent:@"default-domain"];
    XCTAssertNotNil(doc.uid);

    NSString *docId = doc.uid;
    NSString *docIdPath = [NSString stringWithFormat:@"id/%@", docId];

    // Update his property
    NSString *newTitle = [NSString stringWithFormat:@"%d", arc4random()];
    NSLog(@"NewTitle: %@", newTitle);
    doc.properties = @{@"dc:title" : newTitle, @"dc:description" : newTitle};
    NSDate *lastModif = doc.lastModified;

    XCTAssertEqualObjects(doc.properties[@"dc:title"], newTitle);

    // Put update
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromDictionary:[NXDocument mapping]];

    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[mapping inverseMapping] objectClass:[NXDocument class] rootKeyPath:Nil method:RKRequestMethodPUT];
    [manager addRequestDescriptor:requestDescriptor];

    RKObjectRequestOperation *request = [manager appropriateObjectRequestOperationWithObject:doc method:RKRequestMethodPUT path:docIdPath parameters:Nil];

    [request start];
    [request waitUntilFinished];

    [manager removeRequestDescriptor:requestDescriptor];

    // Ensure doc response had the corresponding title
    XCTAssertEqualObjects(docId, doc.uid);
    XCTAssertEqualObjects(newTitle, doc.title);
    XCTAssertEqualObjects(newTitle, doc.properties[@"dc:description"]);

    // Ensure while fetching the doc from scratch; the title is what we expect.
    doc = [NXDocument new];
    request = [manager appropriateObjectRequestOperationWithObject:doc method:RKRequestMethodGET path:docIdPath parameters:Nil];
    [request start];
    [request waitUntilFinished];

    XCTAssertEqualObjects(docId, doc.uid);
    XCTAssertEqualObjects(newTitle, doc.title);
}

-(void) testDocumentCreation
{
    RKObjectManager *manager = [[self class] nxManager];

    RKObjectMapping *truc = [RKObjectMapping requestMapping];
    [truc addAttributeMappingsFromDictionary:[NXDocument mapping]];

    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[truc inverseMapping] objectClass:[NXDocument class] rootKeyPath:Nil method:RKRequestMethodPOST];
    [manager addRequestDescriptor:requestDescriptor];

    NXDocument *doc = [[NXDocument alloc] init];
    doc.name = @"myFile";
    doc.type = @"File";

    doc.properties = [NSMutableDictionary dictionaryWithDictionary:@{@"dc:title" : @"MyDoc title",
                                                                     @"dc:description" : @"So cool description"}];

    XCTAssertNil(doc.uid);

    RKObjectRequestOperation *request = [manager appropriateObjectRequestOperationWithObject:doc method:RKRequestMethodPOST path:@"path/default-domain" parameters:Nil];
    [request start];
    [request waitUntilFinished];

    XCTAssertNotNil(doc);
    XCTAssertNotNil(doc.uid);
    XCTAssertEqualObjects(@"document", doc.entityType);
    XCTAssertEqualObjects(@"MyDoc title", doc.title);
}

@end
