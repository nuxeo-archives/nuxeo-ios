//
//  NXMasterViewController.h
//  DocumentListDemo
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXDetailViewController;

#import "NXOperation.h"

@interface NXMasterViewController : UITableViewController <NXOperationDelegate>
{
    NXOperation* currentOperation;
    NSArray* documentList;
}

@property (strong, nonatomic) NXDetailViewController *detailViewController;

@end
