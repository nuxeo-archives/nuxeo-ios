//
//  NXAppDelegate.h
//  NuxeoSample
//
//  Created by Arnaud Kervern on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NXOperationQueue.h"

@interface NXAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, NXOperationQueueDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (readonly) NXOperationQueue* queue;

@end
