//
//  NXDetailViewController.h
//  DocumentListDemo
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (retain, nonatomic) IBOutlet UITextView *textView;

@end
