//
//  SettingsViewController.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 3/3/10.
//  Copyright 2010 Nuxeo. All rights reserved.
//

#import "SettingsViewController.h"
//#import "CmisClient.h"
//#import "FolderViewController.h"

@interface SettingsViewController (Private)
- (void)enableSaveButtonIfNeeded;
- (void)showSpinner;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    NSLog(@"viewdidload");
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"serviceUrl = %@", [userDefaults stringForKey:@"serviceUrl"]);
    serviceUrlField.text = [userDefaults stringForKey:@"serviceUrl"];
    usernameField.text = [userDefaults stringForKey:@"username"];
    passwordField.text = [userDefaults stringForKey:@"password"];

    [self enableSaveButtonIfNeeded];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark actions

- (IBAction)valueChanged:(id)sender {
    [self enableSaveButtonIfNeeded];
}

- (void)enableSaveButtonIfNeeded {
    saveButton.enabled = ([serviceUrlField.text length]
                          * [usernameField.text length]
                          * [passwordField.text length]) != 0;
}

- (IBAction)cancel {
    self.tabBarController.selectedIndex = 0;
}
    
- (IBAction)save {
    // TODO: validate values
    //[self showSpinner];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:usernameField.text forKey:@"username"];
    [userDefaults setObject:passwordField.text forKey:@"password"];
    [userDefaults setObject:serviceUrlField.text forKey:@"serviceUrl"];
    [userDefaults synchronize];
    
    //[[CmisClient sharedClient] connect];

    self.tabBarController.selectedIndex = 0;
    UINavigationController *browseController = (UINavigationController *) self.tabBarController.selectedViewController;
    [browseController popToRootViewControllerAnimated:YES];
    //UIViewController *topFolderController = browseController.topViewController;
    //[(FolderViewController *) browseController.topViewController refresh];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection: (NSInteger)section {
    switch (section) {
        case 0:
            return @"Your account";
        case 1:
            return @"Server info";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return serviceUrl;
                case 1:
                    return username;
                case 2:
                    return password;
            }
        case 1:
            return login;
    }
    return nil;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == serviceUrlField) {
        [usernameField becomeFirstResponder];
        return NO;
    } else if (textField == usernameField) {
        [passwordField becomeFirstResponder];
        return NO;
    }
    [passwordField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark spinner

- (void)addProgressIndicator {
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    [self.view addSubview:validationView];
    validationView.alpha = 0.0;
    [self.view bringSubviewToFront:validationView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    validationView.alpha = 0.7;
    [UIView commitAnimations];
    
    [apool release];
}

- (void)removeProgressIndicator {
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    [UIView setAnimationDelegate:self];
    validationView.alpha = 0.0;
    [UIView commitAnimations];
    
    [validationView removeFromSuperview];
    
    [apool release];
}

- (void)showSpinner {
    [self performSelectorInBackground:@selector(addProgressIndicator) withObject:nil];
}

- (void)hideSpinner {
    [self performSelectorInBackground:@selector(removeProgressIndicator) withObject:nil];
}

@end
