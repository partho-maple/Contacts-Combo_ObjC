//
//  SettingsTableViewController.h
//  Contacts Cop
//
//  Created by Partho on 9/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "CommonDefs.h"
#import "GlobalConstants.h"
#import "REFrostedViewController.h"
#import "LTHPasscodeViewController.h"

#import "AMSmoothAlertView.h"
#import "AMSmoothAlertConstants.h"



@interface SettingsTableViewController : UITableViewController <AMSmoothAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UISwitch *WiFiSharingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *PasscodeSwitch;


- (IBAction)ShowMainMenu:(id)sender;

- (IBAction)WiFiSharingSwitchTapped:(id)sender;
- (IBAction)PasscodeSwitchTapped:(id)sender;


@end
