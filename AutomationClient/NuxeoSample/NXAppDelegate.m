//
//  NXAppDelegate.m
//  NuxeoSample
//
//  Created by Arnaud Kervern on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NXAppDelegate.h"

#import "DocumentTreeController.h"
#import "SettingsViewController.h"
#import "WorkingListController.h"
#import "SearchDocumentController.h"

@implementation NXAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize queue;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL* serverURL = [NSURL URLWithString:@"http://starship.denise.in.nuxeo.com/nuxeo/site/automation/"];
    
    queue = [[NXOperationQueue alloc] initWithServerURL:serverURL];
    queue.delegate = self;
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *documentTree = [[[DocumentTreeController alloc] initWithNibName:@"DocumentTreeController" bundle:nil] autorelease];
    UINavigationController *navigationTree = [[[UINavigationController alloc] initWithRootViewController:documentTree] autorelease];
    documentTree.title = @"Navigation";
    
    UIViewController *viewController2 = [[[SearchDocumentController alloc] initWithNibName:@"SearchDocumentController" bundle:nil] autorelease];
    UINavigationController *navigationSearch = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
    navigationSearch.title = @"Search";
    
    UIViewController *viewController3 = [[[WorkingListController alloc] initWithNibName:@"WorkingListController" bundle:nil] autorelease];
    UIViewController *viewController4 = [[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationTree, navigationSearch,viewController3, viewController4, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

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
    NSURLCredential* credential = [NSURLCredential credentialWithUser:@"Administrator" password:@"starship5" persistence:NSURLCredentialPersistenceNone];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

@end
