//
//  MoreTableViewController.m
//  Contacts Cop
//
//  Created by Partho on 9/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "MoreTableViewController.h"



#define SECTION_ACC_DETAILS   0
#define SECTION_ACC_DETAILS_ROW_ACC   0

#define SECTION_ETC  1
#define SECTION_ETC_ROW_LIKE  0
#define SECTION_ETC_ROW_FEEDBACK  1
#define SECTION_ETC_ROW_RATE  2
#define SECTION_ETC_ROW_FOLLOW  3
#define SECTION_ETC_ROW_RECOMMEND  4
#define SECTION_ETC_ROW_ABOUT  5

#define SECTION_HELP  2
#define SECTION_HELP_ROW_GUIDE  0

#define SECTION_MORE_APPS  3
#define SECTION_MORE_APPS_ROW_APPS  0


#define I_LIKE_IBAS_TAG 100
#define I_LIKE_SHARE_FB   110
#define I_LIKE_SHARE_TWITTER   120
#define I_LIKE_FRIEND  130


#define RECOMMEND_IBAS_TAG 200
#define RECOMMEND_MESSAGE   210
#define RECOMMEND_EMAIL   220
#define RECOMMEND_COPY_iTUNES   230

@interface MoreTableViewController ()

//@property IBActionSheet  *recommendIBAS;

@end

@implementation MoreTableViewController


//@synthesize recommendIBAS;

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
        case SECTION_ACC_DETAILS:
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case SECTION_ETC:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case SECTION_HELP:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case SECTION_MORE_APPS:
            cell.accessoryType = UITableViewCellAccessoryNone;
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
        case SECTION_ACC_DETAILS:
            [self ManageAccountLogin];
            break;
        case SECTION_ETC:
            switch (row)
            {
                case SECTION_ETC_ROW_LIKE:
                    [self ILikeContactsCombo];
                    break;
                case SECTION_ETC_ROW_FEEDBACK:
                    [self ShowFeedbackController];
                    break;
                case SECTION_ETC_ROW_RATE:
                    [self RateUs];
                    break;
                case SECTION_ETC_ROW_FOLLOW:
                    [self FollowUs];
                    break;
                case SECTION_ETC_ROW_RECOMMEND:
                    [self ShowRecommendation];
                    break;
                case SECTION_ETC_ROW_ABOUT:
                    [self ShowAboutViewController];
                    break;
            }
            break;
        case SECTION_HELP:
            [self ShowUserManual];
            break;
        case SECTION_MORE_APPS:
            [self ShowAppListing];
            break;
    }
}


#pragma mark === Navigation ===

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BackupOptionsToPerformBackupSegue"]) {
        
    }
    
    if ([segue.identifier isEqualToString:@"MoreToLoginSocialAccountSegue"]) {
        
    }
}


#pragma mark === MY METHODES ===

- (void) ILikeContactsCombo
{
    IBActionSheet  *iLikeIBAS;
    iLikeIBAS = [[IBActionSheet alloc] initWithTitle:@"I Like Contacts Combo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tweet on Twitter", @"Share on Facebook", @"Let's Be friend !", nil];
    iLikeIBAS.tag = I_LIKE_IBAS_TAG;
    
    iLikeIBAS.buttonResponse = IBActionSheetButtonResponseShrinksOnPress;
    [iLikeIBAS setButtonBackgroundColor:[UIColor clearColor]];
    [iLikeIBAS setButtonTextColor:[UIColor whiteColor]];
    [iLikeIBAS setTitleTextColor:[UIColor whiteColor]];
    
    
    [[[iLikeIBAS valueForKey:@"_buttons"] objectAtIndex:0] setBackgroundImage:[UIImage imageNamed:@"answer@2x.png"] forState:UIControlStateNormal];
    [[[iLikeIBAS valueForKey:@"_buttons"] objectAtIndex:1] setBackgroundImage:[UIImage imageNamed:@"answer@2x.png"] forState:UIControlStateNormal];
    [[[iLikeIBAS valueForKey:@"_buttons"] objectAtIndex:2] setBackgroundImage:[UIImage imageNamed:@"answer@2x.png"] forState:UIControlStateNormal];
    
    
    [[[iLikeIBAS valueForKey:@"_buttons"] objectAtIndex:3] setBackgroundImage:[UIImage imageNamed:@"Call_End@2x.png"] forState:UIControlStateNormal];
    
    
    [iLikeIBAS  showInView:[UIApplication sharedApplication].keyWindow];
}

- (void) ManageAccountLogin
{
    [self performSegueWithIdentifier:@"MoreToLoginSocialAccountSegue" sender:self];
    
//    LoginSocialAccountsViewController *loginSocialAccountsViewController = [[LoginSocialAccountsViewController alloc] init];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginSocialAccountsViewController];
//    [self presentViewController:navController animated:YES completion:nil];
}

- (void) OpenAppGallerry
{
    UIStoryboard *newStoryboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        newStoryboard = [UIStoryboard storyboardWithName:@"AppGallery_IPAD" bundle:nil];
    }
    
    else {
        newStoryboard = [UIStoryboard storyboardWithName:@"AppGallery_IPHONE" bundle:nil];
    }
    
    AppGalleryView *firstvc = [newStoryboard instantiateInitialViewController];
    [self presentViewController:firstvc animated:YES completion:nil];
}

- (void) RateUs
{
//    [RFRateMe showRateAlert];
    [RFRateMe showRateAlertInstantly];
}

- (void) FollowUs
{
    [self ShowAlertView];
}

- (void) ShowFeedbackController
{
    CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
    feedbackViewController.toRecipients = @[FEEDBACK_EMAIL_lID];
    [self.navigationController pushViewController:feedbackViewController animated:YES];

}

- (void) ShowUserManual
{
    [self ShowAlertView];
}

- (void) ShowAppListing
{
//    [self ShowAlertView];
    [self OpenAppGallerry];
}

- (void) ShowRecommendation
{
    /*
    // In this case show an action sheet to let user select a number.
    UIActionSheet *phoneOptions = [[UIActionSheet alloc] initWithTitle:@"Recommend Contacts Combo"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:@""
                                                     otherButtonTitles:@"Text Message", @"Email", @"Copu iTunes Link", nil];
    [phoneOptions showInView:self.view];
    */
    
    
    IBActionSheet  *recommendIBAS;
    recommendIBAS = [[IBActionSheet alloc] initWithTitle:@"Recommend Contacts Combo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Text Message", @"Email", @"Copy iTunes Link", nil];
    recommendIBAS.tag = RECOMMEND_IBAS_TAG;
    
    recommendIBAS.buttonResponse = IBActionSheetButtonResponseShrinksOnPress;
    [recommendIBAS setButtonBackgroundColor:[UIColor clearColor]];
    [recommendIBAS setButtonTextColor:[UIColor whiteColor]];
    [recommendIBAS setTitleTextColor:[UIColor whiteColor]];
    
    
    [[[recommendIBAS valueForKey:@"_buttons"] objectAtIndex:0] setBackgroundImage:[UIImage imageNamed:@"answer@2x.png"] forState:UIControlStateNormal];
    [[[recommendIBAS valueForKey:@"_buttons"] objectAtIndex:1] setBackgroundImage:[UIImage imageNamed:@"answer@2x.png"] forState:UIControlStateNormal];
    [[[recommendIBAS valueForKey:@"_buttons"] objectAtIndex:2] setBackgroundImage:[UIImage imageNamed:@"answer@2x.png"] forState:UIControlStateNormal];
    
    
    [[[recommendIBAS valueForKey:@"_buttons"] objectAtIndex:3] setBackgroundImage:[UIImage imageNamed:@"Call_End@2x.png"] forState:UIControlStateNormal];
    
    
    [recommendIBAS  showInView:[UIApplication sharedApplication].keyWindow];
}

- (void) ShowAboutViewController
{
//    MIBAboutController *aboutViewControllse = [[MIBAboutController alloc] init];
//    [self.navigationController pushViewController:aboutViewControllse animated:YES];
    
    
    [self performSegueWithIdentifier:@"MoreToAboutSegue" sender:self];
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:aboutViewControllse];
//    [self presentViewController:navController animated:YES completion:nil];
}



- (void) ShowAlertView
{
    // Custom colored alert of type AlertInfo, custom colors can be applied to any alert type
    alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:@"Coming Soon" andText:@"We are working on this. Soon it will be available for you !" andCancelButton:NO forAlertType:AlertInfo andColor:[UIColor colorWithRed:0.607 green:0.372 blue:0.862 alpha:1]];
    [alert setTitleFont:[UIFont fontWithName:@"Verdana" size:25.0f]];
    
    alert.cornerRadius = 3.0f;
    //        [self.view addSubview:alert];
    [alert show];
}



#pragma mark - MessageComposeViewController Delegate method

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MFMailComposeViewController Delegate method 

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBActionSheet/UIActionSheet Delegate Method

// the delegate method to receive notifications is exactly the same as the one for UIActionSheet
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == RECOMMEND_IBAS_TAG) {
        // Proceed if only the selected button index is other than 3 (the Cancel button).
        if (buttonIndex == 0) {
            NSLog(@"Message Pressed");
            
            if (![MFMessageComposeViewController canSendText]) {
                NSLog(@"Unable to send SMS message.");
            }
            else {
                MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc] init];
                [sms setMessageComposeDelegate:self];
                
                [sms setRecipients:[NSArray arrayWithObjects:nil]];
                [sms setBody:[NSString stringWithFormat:@"I found a very good app named 'Contact Combo' in AppStore. Give it a try. Here are the links of of the application : %@", ITUNES_LINK_CONTACTS_COMBO]];
                [self presentViewController:sms animated:YES completion:nil];
            }
            
        }
        else if (buttonIndex == 1) {
            NSLog(@"Email Pressed");
            
            MFMailComposeViewController *mc;
            NSString *emailTitle = @"Try 'Contacts Combo'";
            NSString *messageBody = [NSString stringWithFormat:@"I found a very good app named 'Contact Combo' in AppStore. Give it a try. Here are the links of of the application : %@", ITUNES_LINK_CONTACTS_COMBO];
            NSArray *toRecipents = [NSArray arrayWithObject:nil];
            
            mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:toRecipents];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
        }
        else if (buttonIndex == 2) {
            NSLog(@"iTunes Pressed");
            
            [UIPasteboard generalPasteboard].string = ITUNES_LINK_CONTACTS_COMBO;
        }
        else if (buttonIndex == 3) {
            NSLog(@"Cancel Pressed");
        }

    }
    else if (actionSheet.tag == I_LIKE_IBAS_TAG) {
        // Proceed if only the selected button index is other than 3 (the Cancel button).
        if (buttonIndex == 0) {
            NSLog(@"Twitter Pressed");
            
            
            
        }
        else if (buttonIndex == 1) {
            NSLog(@"Facebook Pressed");
            
            
        }
        else if (buttonIndex == 2) {
            NSLog(@"Friend Pressed");
            
            
        }
        else if (buttonIndex == 3) {
            NSLog(@"Cancel Pressed");
        }
    }
    
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

@end
