//
//  NXDocumentDetailView.h
//  AutomationClient
//
//  Created by Arnaud Kervern on 10/19/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXDocumentDetailView : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *TitleTextField;
@property (retain, nonatomic) IBOutlet UITextField *pathTextField;
@property (retain, nonatomic) IBOutlet UITextField *stateTextField;
@property (retain, nonatomic) IBOutlet UITextField *typeTextField;
@property (retain, nonatomic) NSDictionary *document;

-(void)fillFields;

@end
