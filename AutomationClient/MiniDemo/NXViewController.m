//
//  NXViewController.m
//  MiniDemo
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import "NXViewController.h"

#import "NXOperationResult.h"
#import "NXOperationDefinition.h"

@implementation NXViewController

@synthesize textView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL* serverURL = [NSURL URLWithString:@"http://demo.denise.in.nuxeo.com/nuxeo/site/automation/"];
    
    queue = [[NXOperationQueue alloc] initWithServerURL:serverURL];
    queue.delegate = self;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    queue.delegate = nil;
    [queue release];
    queue = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [textView release];
    [super dealloc];
}

- (IBAction)go:(id)sender {
    // make the operation
    NXOperationDefinition* def = [[NXOperationDefinition alloc] init];
    
    def.identifier = @"Document.Query";
    def.URI = @"Document.Query";
    
    NXOperation* op = [[NXOperation alloc] init];
    
    op.definition = def;
    [def release];
    
    op.parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"SELECT * FROM Document", @"query",
                     nil];
    op.delegate = self;
    
    [queue executeOperation:op];
    
    if (operationCount == 0) {
        // start spinning
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    operationCount++;
    [op release];
}

#pragma mark -
#pragma mark NXOperationDelegate

- (void)operation:(NXOperation *)operation didFailWithError:(NSError *)error
{
    operationCount--;
    if (operationCount == 0) {
        // start spinning
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong with the request" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    
    [alert release];
}

- (void)operation:(NXOperation *)operation didFinishWithResult:(NXOperationResult *)result
{
    operationCount--;
    if (operationCount == 0) {
        // start spinning
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    NSString* s = [result.output description];
    
    self.textView.text = s;
}

#pragma mark -
#pragma mark NXOperationQueueDelegate

- (BOOL)queue:(NXOperationQueue *)queue canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)queue:(NXOperationQueue *)queue didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] >= 1) {
        NSLog(@"Too many failures. Bailing out");
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        return;
    }
    NSLog(@"Using very strong user/password pair");
    NSURLCredential* credential = [NSURLCredential credentialWithUser:@"Administrator" password:@"Administrator" persistence:NSURLCredentialPersistenceNone];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

@end
