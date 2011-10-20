//
//  NXOperationQueue.m
//  AutomationClient
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import "NXOperationQueue.h"
#import "NXOperationQueue_Private.h"

#import "NXOperationDefinition.h"
#import "NXOperation.h"
#import "NXOperationResult.h"
#import "NXNuxeoErrors.h"

#define JSON_WRITING_OPTIONS NSJSONWritingPrettyPrinted
//#define JSON_WRITING_OPTIONS 0

@implementation NXOperationQueue

+ (NSURLRequest *)requestForOperation:(NXOperation *)operation forServerURL:(NSURL *)baseURL error:(NSError **)error
{
    // TODO: check all objects are valid, including definition
    NSURL* realURL = [[baseURL URLByAppendingPathComponent:NX_AUTOMATION_URI] URLByAppendingPathComponent:operation.definition.URI];
    NSMutableURLRequest* result = [[NSMutableURLRequest alloc] initWithURL:realURL cachePolicy:0 timeoutInterval:60.0f];
    [result setHTTPMethod:@"POST"];
    [result setValue:@"application/json+nxrequest" forHTTPHeaderField:@"Content-Type"];
    [result setValue:@"common,dublincore" forHTTPHeaderField:@"X-NXDocumentProperties"];
    
    id input = operation.input;
    NSDictionary* params = operation.parameters;
    
    // At this point, you have to translate input and paramaters to JSON compatible objects.
    // e.g. NXDocument to whatever JSON compatible value to put
    
    NSMutableDictionary* bodyDictionary = [[NSMutableDictionary alloc] init];
    if (params) {
        [bodyDictionary setObject:params forKey:@"params"];
    }
    if (input) {
        [bodyDictionary setObject:input forKey:@"input"];
    }
    NSData* bodyData = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:JSON_WRITING_OPTIONS error:error];
    [bodyDictionary release];
    if (!bodyData) {
        [result release];
        return nil;
    }
    
    [result setHTTPBody:bodyData];
    
    return [result autorelease];
}

+ (NXOperationResult *)operationResultForDocuments:(NSDictionary *)object
{
    NSArray* entities = [object objectForKey:@"entries"];
    if (![entities isKindOfClass:[NSArray class]]) {
        return nil;
    }
        
    NXOperationResult* result = [[NXOperationResult alloc] init];
    // TODO: wrap each element in a NXDocument
    result.output = entities;
    return [result autorelease];
}

+ (NXOperationResult *)operationResultForDocument:(NSDictionary *)object
{
    NXOperationResult* result = [[NXOperationResult alloc] init];
    // TODO: wrap it in a NXDocument
    result.output = object;
    return [result autorelease];
}

+ (NXOperationResult *)operationResultForJSONObject:(id)object
{
    if (![object isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString* entityType = [object objectForKey:@"entity-type"];
    if (!entityType) {
        return nil;
    }
    if (![entityType isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString* selectorName = [NSString stringWithFormat:@"operationResultFor%@:", [entityType capitalizedString]];
    SEL selector = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:selector]) {
        return [self performSelector:selector withObject:object];
    }
    
    return nil;
}

@synthesize baseURL = _baseURL, delegate;

- (id)initWithServerURL:(NSURL *)anURL
{
    self = [super init];
    if (self) {
        _baseURL = [anURL copy];
        _connectionToOperation = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        _operationToConnection = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        _connectionToData = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

- (void)dealloc {
    [_baseURL release];
    CFRelease(_connectionToOperation);
    CFRelease(_connectionToData);
    CFRelease(_operationToConnection);
    [super dealloc];
}

#pragma mark Public API

- (void)executeOperation:(NXOperation *)operation
{
    NSURLConnection* connection = CFDictionaryGetValue(_operationToConnection, operation);
    if (connection) {
        // ideally raise an exception here
        NSLog(@"Trying to execute the same operation twice at the same time!!!!");
        return;
    }
    
    NSError* error;
    NSURLRequest* request = [[self class] requestForOperation:operation forServerURL:_baseURL error:&error];
    if (!request) {
        NSLog(@"Can't create request for operation: %@", error);
        return;
    }
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    CFDictionarySetValue(_operationToConnection, operation, connection);
    CFDictionarySetValue(_connectionToOperation, connection, operation);
}

- (void)cancelOperation:(NXOperation *)operation
{
    [(NSURLConnection *)CFDictionaryGetValue(_operationToConnection, operation) cancel];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
    
    NSLog(@"Status code for %@ is: %ld", connection, (long)[httpResponse statusCode]);
    
    // TODO: interpret HTTP status code correctly here and produce meaningful error
    // and call delegate appropriately
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataChunk
{
    NSMutableData* data = CFDictionaryGetValue(_connectionToData, connection);
    if (!data) {
        data = [[NSMutableData alloc] initWithData:dataChunk];
        CFDictionarySetValue(_connectionToData, connection, data);
        [data release];
    } else {
        [data appendData:dataChunk];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection %@ did finish!", connection);
    NXOperation* operation = CFDictionaryGetValue(_connectionToOperation, connection);
    NXOperationResult* opResult = nil;
    NSError* error = nil;
    
    // TODO: check consistency, operation should be != nil
    
    // post-process data
    NSMutableData* data = CFDictionaryGetValue(_connectionToData, connection);
    if (!data) {
        NSLog(@"Server is out for lunch, I don't have any body!");
        // TODO: also populate userInfo with error description
        error = [NSError errorWithDomain:NXNuxeoErrorDomain code:NXNuxeoErrorServerError userInfo:nil];
    } else {
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (result) {
            // parse result
            opResult = [[self class] operationResultForJSONObject:result];
            if (!opResult) {
                error = [NSError errorWithDomain:NXNuxeoErrorDomain code:NXNuxeoErrorServerError userInfo:
                         [NSDictionary dictionaryWithObjectsAndKeys:error, NSUnderlyingErrorKey, nil]];
            }
        } else {
            error = [NSError errorWithDomain:NXNuxeoErrorDomain code:NXNuxeoErrorServerError userInfo:
                     [NSDictionary dictionaryWithObjectsAndKeys:error, NSUnderlyingErrorKey, nil]];
        }
    }

    if (opResult) {
        [operation.delegate operation:operation didFinishWithResult:opResult];
    } else {
        assert(error != nil);
        [operation.delegate operation:operation didFailWithError:error];
    }
    
    // clean-up
    CFDictionaryRemoveValue(_connectionToData, connection);
    CFDictionaryRemoveValue(_connectionToOperation, connection);
    CFDictionaryRemoveValue(_operationToConnection, operation);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection did fail with error: %@", error);
    NXOperation* operation = CFDictionaryGetValue(_connectionToOperation, connection);
    
    // TODO: check consistency, operation should be != nil

    [operation.delegate operation:operation didFailWithError:error];
    
    // clean-up
    CFDictionaryRemoveValue(_connectionToData, connection);
    CFDictionaryRemoveValue(_connectionToOperation, connection);
    CFDictionaryRemoveValue(_operationToConnection, operation);
}

#pragma mark Authentication

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    if ([self.delegate respondsToSelector:@selector(queue:canAuthenticateAgainstProtectionSpace:)]) {
        return [self.delegate queue:self canAuthenticateAgainstProtectionSpace:protectionSpace];
    }
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([self.delegate respondsToSelector:@selector(queue:didReceiveAuthenticationChallenge:)]) {
        [self.delegate queue:self didReceiveAuthenticationChallenge:challenge];
        return;
    }
    [challenge.sender cancelAuthenticationChallenge:challenge];
}

@end
