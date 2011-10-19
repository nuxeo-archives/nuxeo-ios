//
//  DocumentTreeController.h
//  AutomationClient
//
//  Created by Arnaud Kervern on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXAppDelegate.h"
#import "NXOperation.h"
#import "NXOperationDefinition.h"
#import "NXOperationResult.h"
#import "NXDocumentDetailView.h"

@interface DocumentTreeController : UITableViewController<NXOperationDelegate> {
@private
    NXOperation* currentOperation;
    NSMutableArray* documentList;
    NSString* _parentId;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentId:(NSString*)parentId;

@end
