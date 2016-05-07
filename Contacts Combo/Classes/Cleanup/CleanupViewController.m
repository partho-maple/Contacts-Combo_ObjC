//
//  CleanupViewController.m
//  Contacts Cop
//
//  Created by Partho on 8/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "CleanupViewController.h"

@interface CleanupViewController ()

@end

@implementation CleanupViewController

@synthesize MassDeletionButton, MissingNameButton, MissingPhoneNumberButton, EmptyContactsButton;

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

- (void) viewDidAppear:(BOOL)animated
{
    NSString *massDeletionButtonLable = [[NSString alloc] initWithFormat:@"Mass Deletion (%lu)", (unsigned long)[ContactOpsUtils getAllContactsOutOfAddressBook].count];
    [MassDeletionButton setTitle:massDeletionButtonLable forState:UIControlStateNormal];
    
    
    NSString *nissingPhoneNumberButtonLable = [[NSString alloc] initWithFormat:@"Missing Phone Number (%lu)", (unsigned long)[ContactOpsUtils getContactsWithMissingPhoneOutOfAddressBook].count];
    [MissingPhoneNumberButton setTitle:nissingPhoneNumberButtonLable forState:UIControlStateNormal];
    
    
    NSString *nissingNameButtonLable = [[NSString alloc] initWithFormat:@"Missing Name (%lu)", (unsigned long)[ContactOpsUtils getContactsWithMissingNameOutOfAddressBook].count];
    [MissingNameButton setTitle:nissingNameButtonLable forState:UIControlStateNormal];
    
    
    NSString *emptyContactsButtonLable = [[NSString alloc] initWithFormat:@"Empty Contacts (%lu)", (unsigned long)[ContactOpsUtils getEmptyContactsOutOfAddressBook].count];
    [EmptyContactsButton setTitle:emptyContactsButtonLable forState:UIControlStateNormal];
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

- (IBAction)ShowMainMenu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)MassDeletionButtonTapped:(id)sender {
    
    if ([ContactOpsUtils getAllContactsOutOfAddressBook].count > 0) {
        [[AppManager getAppManagerInstance] setCleanupType:[NSMutableString stringWithString:@"MassDeletion"]];
        [self performSegueWithIdentifier:@"CleanupToMassDeletionSegue" sender: self];
    }
    
}

- (IBAction)MissingNameButtonTapped:(id)sender {
    
    if ([ContactOpsUtils getContactsWithMissingNameOutOfAddressBook].count > 0) {
        [[AppManager getAppManagerInstance] setCleanupType:[NSMutableString stringWithString:@"MissingName"]];
        [self performSegueWithIdentifier:@"CleanupToMassDeletionSegue" sender: self];
    }
    
}

- (IBAction)MissingPhoneNumberButtonTapped:(id)sender {
    
    if ([ContactOpsUtils getContactsWithMissingPhoneOutOfAddressBook].count > 0) {
        [[AppManager getAppManagerInstance] setCleanupType:[NSMutableString stringWithString:@"MissingPhoneNumber"]];
        [self performSegueWithIdentifier:@"CleanupToMassDeletionSegue" sender: self];
    }
    
}

- (IBAction)EmptyContactsButtonTapped:(id)sender {
    
    if ([ContactOpsUtils getEmptyContactsOutOfAddressBook].count > 0) {
        [[AppManager getAppManagerInstance] setCleanupType:[NSMutableString stringWithString:@"EmptyContacts"]];
        [self performSegueWithIdentifier:@"CleanupToMassDeletionSegue" sender: self];
    }
    
}

@end
