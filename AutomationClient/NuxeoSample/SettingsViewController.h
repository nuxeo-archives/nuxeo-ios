//
//  SettingsViewController.h
//  iNuxeo
//
//  Created by Stefane Fermigier on 3/3/10.
//  Copyright 2010 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIBarButtonItem*   doneButton;
    
    IBOutlet UIBarButtonItem*   cancelButton;
    IBOutlet UIBarButtonItem*   saveButton;

    IBOutlet UITableViewCell*   serviceUrl;
    IBOutlet UITextField*       serviceUrlField;

    IBOutlet UITableViewCell*   username;
    IBOutlet UITextField*       usernameField;

    IBOutlet UITableViewCell*   password;
    IBOutlet UITextField*       passwordField;
    
    IBOutlet UITableViewCell*   login;
    IBOutlet UIButton*          loginButton;

    IBOutlet UIView*            validationView;
}

- (IBAction)valueChanged:(id)sender;
- (IBAction)cancel;
- (IBAction)save;

@end
