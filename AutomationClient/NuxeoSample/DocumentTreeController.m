//
//  DocumentTreeController.m
//  AutomationClient
//
//  Created by Arnaud Kervern on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import "DocumentTreeController.h"

@implementation DocumentTreeController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentId:(NSString*)parentId {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _parentId = parentId;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"DocumentTree";
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

- (void)dealloc {
    [currentOperation release];
    currentOperation = nil;
    [documentList release];
    documentList = nil;
    _parentId = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (documentList) {
        [documentList release];
        documentList = nil;
    }
    
    // make the operation
    NXOperationDefinition* def = [[NXOperationDefinition alloc] init];
    
    def.identifier = @"Document.Query";
    def.URI = @"Document.Query";
    
    NXOperation* op = [[NXOperation alloc] init];
    // default_document_suggestion
    op.definition = def;
    [def release];
    
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM Document WHERE ecm:parentId = '%@' AND ecm:isProxy = 0 AND ecm:mixinType != 'HiddenInNavigation' AND ecm:isCheckedInVersion = 0 AND ecm:currentLifeCycleState != 'deleted'", @"47e6464b-8d9b-4c63-b74c-e27641e9e96e"];
    
    op.parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                     query, @"query",
                     nil];
    op.delegate = self;
    
    [((NXAppDelegate *)[UIApplication sharedApplication].delegate).queue executeOperation:op];
    
    currentOperation = op;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [documentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary* document = [documentList objectAtIndex:indexPath.row];
    cell.textLabel.text = [document objectForKey:@"title"];
    cell.detailTextLabel.text = [document objectForKey:@"path"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* document = [documentList objectAtIndex:indexPath.row];
    NSArray* facets = [document objectForKey:@"facets"];
    if ([facets indexOfObject:@"Folderish"]) {
        DocumentTreeController* branch = [[DocumentTreeController alloc] initWithNibName:@"DocumentTreeController" bundle:nil parentId:[document objectForKey:@"uid"]];
        
        [self.navigationController pushViewController:branch animated:true];
        
        [branch release];
    } else {
        // Display detail view
    }
}

#pragma mark NXOperationDelegate

- (void)operation:(NXOperation *)operation didFailWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    
    [alert release];
    
    [currentOperation release];
    currentOperation = nil;
}

- (void)operation:(NXOperation *)operation didFinishWithResult:(NXOperationResult *)result
{
    [documentList release];
    NSLog(@"Content results: %@", result.output);
    documentList = [result.output retain];
    [self.tableView reloadData];
    
    [currentOperation release];
    currentOperation = nil;
}

@end
