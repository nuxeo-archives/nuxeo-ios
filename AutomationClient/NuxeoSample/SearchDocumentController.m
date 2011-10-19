//
//  SearchDocumentController.m
//  AutomationClient
//
//  Created by Arnaud Kervern on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import "SearchDocumentController.h"

const int DISPLAY_ELT = 0;

@implementation SearchDocumentController
@synthesize searchBarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Search";
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
    
    [searchBarView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchBarView:nil];
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
    if (documentList) {
        //return [documentList count] + 1;
        return [documentList count];
    } else {
        return 0;
    }
}

- (UITableViewCell*) getDefaultTableViewCell:(UITableView*)tableView {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //[self performSearchDocument:[[self searchBarView] text]];
    return cell;
}
- (UITableViewCell*) getMoreTableViewCell:(UITableView*)tableView {
    static NSString *CellIdentifier = @"NXCellMore";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = @"Displaying more item";
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [activity startAnimating];
    activity.frame = CGRectMake(20, 13, activity.frame.size.width, activity.frame.size.height);
    [cell addSubview:activity];
    
    // If drawn, we should append more document
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    NSLog(@"documentList docs: %d and indexPath: %d", [documentList count], indexPath.row);
    if (documentList && (indexPath.row == [documentList count])) {
        cell = [self getMoreTableViewCell:tableView];
    } else {
        cell = [self getDefaultTableViewCell:tableView];
        
        NSDictionary* document = [documentList objectAtIndex:indexPath.row];
        cell.textLabel.text = [document objectForKey:@"title"];
        cell.detailTextLabel.text = [document objectForKey:@"path"];
    }
    
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

#pragma mark - 
- (void) performSearchDocument:(NSString*) fulltext {
    if (documentList) {
        [documentList release];
        documentList = nil;
    }
    
    // make the operation
    NXOperationDefinition* def = [[NXOperationDefinition alloc] init];
    
    def.identifier = @"Document.PageProvider";
    def.URI = @"Document.PageProvider";
    
    NXOperation* op = [[NXOperation alloc] init];
    // default_document_suggestion
    op.definition = def;
    [def release];
    
    if (!currentPage) {
        currentPage = 0;
    }
    
    op.parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"default_document_suggestion", @"providerName",
                     [NSArray arrayWithObject:fulltext], @"queryParams",
                     [NSNumber numberWithInt:DISPLAY_ELT], @"pageSize",
                     [NSNumber numberWithInt:currentPage], @"page",
                     nil];
    op.delegate = self;
    
    [((NXAppDelegate *)[UIApplication sharedApplication].delegate).queue executeOperation:op];
    
    currentOperation = op;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search button");
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"Text end editing");
    currentPage = 0;
    [self performSearchDocument:searchBar.text];
}

# pragma mark NXOperationDelegate

- (void)operation:(NXOperation *)operation didFailWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

- (void)operation:(NXOperation *)operation didFinishWithResult:(NXOperationResult *)result
{
    NSLog(@"There is %d docs", [documentList count]);
    NSLog(@"Data received: \n%@", result.output);
    
    if (currentPage == 0) {
        [documentList release];
        documentList = [result.output retain];
    } else {
        [documentList addObjectsFromArray:result.output];
    }
    
    currentPage += 1;
    [self.tableView reloadData];
    
    
    [currentOperation release];
    currentOperation = nil;
}

@end