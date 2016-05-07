//
//  SyncViewController.m
//  Contacts Cop
//
//  Created by Partho on 7/29/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "SyncViewController.h"

#define GoogleLoginAlertViewsTag 10
#define YahooLoginAlertViewsTag 11
#define LinkedInLoginAlertViewsTag 12
#define FacebookLoginAlertViewsTag 13
#define OutLookLoginAlertViewsTag 14


@interface SyncViewController ()

@end

@implementation SyncViewController

UITextField * alertUserID;
UITextField * alertPass;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Button Actions

- (IBAction)ShowMainMenu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)SyncGoogle:(id)sender {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Login to your Google account\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    alert.tag = GoogleLoginAlertViewsTag;
    
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    alertUserID = [alert textFieldAtIndex:0];
    alertUserID.keyboardType = UIKeyboardTypeDefault;
    alertUserID.placeholder = @"Enter your username";
    
    alertPass = [alert textFieldAtIndex:1];
    alertPass.keyboardType = UIKeyboardTypeDefault;
    alertPass.placeholder = @"Enter your password";
    alertPass.secureTextEntry = YES;
    
    [alert show];
}

- (IBAction)SyncYahoo:(id)sender {
    
}

- (IBAction)SyncLinkedIn:(id)sender {
}

- (IBAction)SyncFacebook:(id)sender {
}

- (IBAction)SyncOutlook:(id)sender {
}


#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == GoogleLoginAlertViewsTag)
    {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
            // Cancel was tapped
             NSLog(@"Cancel was tapped");
        }
        else if (buttonIndex == alertView.firstOtherButtonIndex)
        {
            // The other button was tapped. Puts back to the same settings viewcontroller.
            NSLog(@"OK button was tapped");
            
            [[AppManager getAppManagerInstance] setSyncingType:[NSMutableString stringWithString:@"Google"]];
            [self performSegueWithIdentifier:@"performSyncSegue" sender: self];        }
    }
    
    
}





#pragma mark - Google Contact Sync




@end
