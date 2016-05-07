//
//  SettingsTableViewController.m
//  Contacts Cop
//
//  Created by Partho on 9/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "SettingsTableViewController.h"

#define SECTION_IN_APP   0
#define SECTION_IN_APP_ROW_PRO   0

#define SECTION_GENERAL   1
#define SECTION_GENERAL_ROW_ACCOUNTS   0
#define SECTION_GENERAL_ROW_DISPLAY   1
#define SECTION_GENERAL_ROW_SORT   2
#define SECTION_GENERAL_ROW_LANGUAGE   3

#define SECTION_ACCOUNT_MANAGER   2
#define SECTION_ACCOUNT_MANAGER_ROW_ACCOUNTS   0

#define SECTION_USB_SHARING   3
#define SECTION_USB_SHARING_IMPORT   0
#define SECTION_USB_SHARING_EXPORT   1

#define SECTION_WIFI_SHARING   4
#define SECTION_WIFI_SHARING_ROW_SHARE   0

#define SECTION_PASSCODE   5
#define SECTION_PASSCODE_ROW_ENABLE   0
#define SECTION_PASSCODE_ROW_CHANGE   1

#define SECTION_MORE   6
#define SECTION_MORE_ROW_DUPLICATED   0
#define SECTION_MORE_ROW_MERGE   1
#define SECTION_MORE_ROW_SYNC   2
#define SECTION_MORE_ROW_REMINDERS   3




@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

@synthesize WiFiSharingSwitch, PasscodeSwitch;

AMSmoothAlertView *alert;
bool isPopupShown;

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void) viewDidAppear:(BOOL)animated {
    if ([LTHPasscodeViewController doesPasscodeExist]) {
        [PasscodeSwitch setOn:YES animated:YES];
    } else {
        [PasscodeSwitch setOn:NO animated:YES];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark === UITableViewDataSource ===

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section)
    {
        case SECTION_IN_APP:
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case SECTION_GENERAL:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case SECTION_ACCOUNT_MANAGER:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case SECTION_USB_SHARING:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case SECTION_WIFI_SHARING:
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case SECTION_PASSCODE:
            cell.accessoryType = UITableViewCellAccessoryNone;
            switch (row)
            {
            case SECTION_PASSCODE_ROW_ENABLE:
                
                break;
            case SECTION_PASSCODE_ROW_CHANGE:
                    if ([LTHPasscodeViewController doesPasscodeExist]) {
                        cell.userInteractionEnabled = YES;
                    } else {
                        // Disables the change passcode row
                        cell.userInteractionEnabled = NO;
                    }
                break;
            }
            break;
            break;
        case SECTION_MORE:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section)
    {
        case SECTION_IN_APP:
            
            break;
        case SECTION_GENERAL:
            switch (row)
            {
            case SECTION_GENERAL_ROW_ACCOUNTS:
                
                break;
            case SECTION_GENERAL_ROW_DISPLAY:
                
                break;
            case SECTION_GENERAL_ROW_SORT:
                
                break;
            case SECTION_GENERAL_ROW_LANGUAGE:
                
                break;
            }
            break;
        case SECTION_ACCOUNT_MANAGER:
            
            break;
        case SECTION_USB_SHARING:
            switch (row)
        {
            case SECTION_USB_SHARING_IMPORT:
                [self USBImports];
                break;
            case SECTION_USB_SHARING_EXPORT:
                [self USBExports];
                break;
        }
            break;
        case SECTION_WIFI_SHARING:
            
            break;
        case SECTION_PASSCODE:
            switch (row)
            {
            case SECTION_PASSCODE_ROW_ENABLE:
                // We don't need to put nothing here...
                break;
            case SECTION_PASSCODE_ROW_CHANGE:
                [self showLockViewForChangingPasscode];
                break;
            }
            break;
        case SECTION_MORE:
            switch (row)
            {
            case SECTION_MORE_ROW_DUPLICATED:
                
                break;
            case SECTION_MORE_ROW_MERGE:
                
                break;
            case SECTION_MORE_ROW_SYNC:
                
                break;
            case SECTION_MORE_ROW_REMINDERS:
                
                break;
            }
            break;
    }
}


#pragma mark === Navigation ===

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@""]) {
        
    }
}


#pragma mark === MY METHODES ===

- (void) ShowAlertViewWithTitle:(NSString *)title andMessege:(NSString *)msg andType:(AlertType) type
{
    // Custom colored alert of type AlertInfo, custom colors can be applied to any alert type
    alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:title andText:msg andCancelButton:NO forAlertType:type andColor:[UIColor colorWithRed:0.607 green:0.372 blue:0.862 alpha:1]];
    [alert setTitleFont:[UIFont fontWithName:@"Verdana" size:25.0f]];
    
    alert.cornerRadius = 3.0f;
//        [self.view addSubview:alert];
    [alert show];
}



- (void) USBImports
{
    [self ShowAlertViewWithTitle:@"Info !" andMessege:@"Connect your device via USB with your PC/MAC. Then just drag and drop your files inside iTunes under the File Sharing section." andType:AlertInfo];
}

- (void) USBExports
{
    [self ShowAlertViewWithTitle:@"Info !" andMessege:@"Connect your device via USB with your PC/MAC. Your files are now available for download inside iTunes under the File Sharing section." andType:AlertInfo];
}

- (void) setPasscodeTypeSimple:(BOOL)type {
    [[LTHPasscodeViewController sharedUser] setIsSimple:type
                                       inViewController:self
                                                asModal:YES];
}

- (void)showLockViewForEnablingPasscode {
    [self setPasscodeTypeSimple:YES];
    
	[[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self
                                                                            asModal:YES];
}


- (void)showLockViewForTestingPasscode {
	[[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:YES
                                                             withLogout:NO
                                                         andLogoutTitle:nil];
}


- (void)showLockViewForChangingPasscode {
	[[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self asModal:YES];
}


- (void)showLockViewForTurningPasscodeOff {
	[[LTHPasscodeViewController sharedUser] showForDisablingPasscodeInViewController:self
                                                                             asModal:NO];
}

# pragma mark - LTHPasscodeViewController Delegates -

- (void)passcodeViewControllerWillClose {
	NSLog(@"Passcode View Controller Will Be Closed");
	
}

- (void)maxNumberOfFailedAttemptsReached {
    [LTHPasscodeViewController deletePasscodeAndClose];
	NSLog(@"Max Number of Failed Attemps Reached");
}

- (void)passcodeWasEnteredSuccessfully {
	NSLog(@"Passcode Was Entered Successfully");
}

- (void)logoutButtonWasPressed {
	NSLog(@"Logout Button Was Pressed");
}



#pragma mark - AMSmoothAlertView Delegates
- (void)alertView:(AMSmoothAlertView *)alertView didDismissWithButton:(UIButton *)button {
    if (alertView == alert) {
        if (button == alert.defaultButton) {
            NSLog(@"Default button touched!");
        }
        if (button == alert.cancelButton) {
            NSLog(@"Cancel button touched!");
        }
    }
}

- (void)alertViewWillShow:(AMSmoothAlertView *)alertView {
    if (alertView.tag == 0)
        NSLog(@"AlertView Will Show: '%@'", alertView.titleLabel.text);
}

- (void)alertViewDidShow:(AMSmoothAlertView *)alertView {
    NSLog(@"AlertView Did Show: '%@'", alertView.titleLabel.text);
}

- (void)alertViewWillDismiss:(AMSmoothAlertView *)alertView {
    NSLog(@"AlertView Will Dismiss: '%@'", alertView.titleLabel.text);
}

- (void)alertViewDidDismiss:(AMSmoothAlertView *)alertView {
    NSLog(@"AlertView Did Dismiss: '%@'", alertView.titleLabel.text);
}





#pragma mark === BUTTON ACTIONS ===

- (IBAction)ShowMainMenu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)WiFiSharingSwitchTapped:(id)sender {
    if (WiFiSharingSwitch.isOn) {
        
    }
    else if (!WiFiSharingSwitch.isOn) {
        
    }
}

- (IBAction)PasscodeSwitchTapped:(id)sender {
    if (PasscodeSwitch.isOn) {
        [self showLockViewForEnablingPasscode];
    }
    else if (!PasscodeSwitch.isOn) {
        [self showLockViewForTurningPasscodeOff];
    }
}



@end






