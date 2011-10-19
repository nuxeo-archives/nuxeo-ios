//
//  NXDocumentDetailView.m
//  AutomationClient
//
//  Created by Arnaud Kervern on 10/19/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import "NXDocumentDetailView.h"

@implementation NXDocumentDetailView
@synthesize TitleTextField;
@synthesize pathTextField;
@synthesize stateTextField;
@synthesize typeTextField;
@synthesize document;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated{
    [self fillFields];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTitleTextField:nil];
    [self setPathTextField:nil];
    [self setStateTextField:nil];
    [self setTypeTextField:nil];
    [self setDocument:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [TitleTextField release];
    [pathTextField release];
    [stateTextField release];
    [typeTextField release];
    [document release];
    [super dealloc];
}

#pragma mark -

-(void)fillFields {
    NSLog(@"Try to fill fields: %@", self.document);
    id title = [self.document objectForKey:@"title"];
    if (title) {
        self.TitleTextField.text = title;
    }
    
    id path = [self.document objectForKey:@"path"];
    if (path) {
        self.pathTextField.text = path;
    }
    
    id state = [self.document objectForKey:@"state"];
    if (state) {
        self.stateTextField.text = state;
    }
    
    id type = [self.document objectForKey:@"type"];
    if (type) {
        self.typeTextField.text = type;
    }
}

@end
