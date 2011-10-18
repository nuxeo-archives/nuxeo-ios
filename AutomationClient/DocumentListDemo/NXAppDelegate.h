//
//  NXAppDelegate.h
//  DocumentListDemo
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NXOperationQueue.h"

@interface NXAppDelegate : UIResponder <UIApplicationDelegate, NXOperationQueueDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (readonly) NXOperationQueue* queue;

@end
