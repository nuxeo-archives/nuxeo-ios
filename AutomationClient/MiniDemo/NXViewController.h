//
//  NXViewController.h
//  MiniDemo
//
//  Created by Benjamin Jalon on 10/18/11.
//  Copyright (c) 2011 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NXOperationQueue.h"
#import "NXOperation.h"

@interface NXViewController : UIViewController <NXOperationQueueDelegate, NXOperationDelegate>
{
    NXOperationQueue* queue;
    NSUInteger operationCount;
}

@property (retain, nonatomic) IBOutlet UITextView *textView;

- (IBAction)go:(id)sender;

@end
