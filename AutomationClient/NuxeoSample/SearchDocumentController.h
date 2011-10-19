//
//  SearchDocumentController.h
//  AutomationClient
//
//  Created by Arnaud Kervern on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXAppDelegate.h"
#import "NXOperation.h"
#import "NXOperationResult.h"
#import "NXOperationDefinition.h"

@interface SearchDocumentController : UITableViewController<UISearchBarDelegate, NXOperationDelegate> {
@private
    NXOperation* currentOperation;
    NSArray* documentList;
}

@end
