//
//  DetailViewController.m
//  AddressBook
//
//  Created by Partho Biswas on 7/22/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

-(void)populateContactData;
-(void)performPhoneAction:(BOOL)shouldMakeCall;
-(void)makeCallToNumber:(NSString *)numberToCall;
-(void)sendSMSToNumber:(NSString *)numberToSend;

@end


@implementation DetailViewController

@synthesize person;

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [_tblContactDetails setDelegate:self];
    [_tblContactDetails setDataSource:self];
    
    [self populateContactData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private method implementation

-(void)populateContactData{
    NSString *contactFullName = [NSString stringWithFormat:@"%@ %@", [_dictContactDetails objectForKey:@"firstName"], [_dictContactDetails objectForKey:@"lastName"]];
    
    [_lblContactName setText:contactFullName];
    
    
    // Set the contact image.
    [_imgContactImage setImage:[_dictContactDetails objectForKey:@"image"]];
    
    
    // Reload the tableview.
    [_tblContactDetails reloadData];
}


-(void)performPhoneAction:(BOOL)shouldMakeCall{
    // Check if both mobile and home numbers exist.
    if (![[_dictContactDetails objectForKey:@"mobileNumber"] isEqualToString:@""] &&
        ![[_dictContactDetails objectForKey:@"homeNumber"] isEqualToString:@""]) {
        // In this case show an action sheet to let user select a number.
        UIActionSheet *phoneOptions = [[UIActionSheet alloc] initWithTitle:@"Pick a number"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:@""
                                                         otherButtonTitles:[_dictContactDetails objectForKey:@"mobileNumber"], [_dictContactDetails objectForKey:@"homeNumber"], nil];
        [phoneOptions showInView:self.view];
        
        // Depending on whether the action should be made regards a phone call or sending a SMS, set the appropriate tag
        // value to the action sheet.
        if (shouldMakeCall) {
            [phoneOptions setTag:101];
        }
        else{
            [phoneOptions setTag:102];
        }
        
    }
    else{
        NSString *selectedPhoneNumber = nil;
        
        // Otherwise make a call to any of the phone numbers that may exit.
        if (![[_dictContactDetails objectForKey:@"mobileNumber"] isEqualToString:@""]) {
            selectedPhoneNumber = [_dictContactDetails objectForKey:@"mobileNumber"];
            
        }
        
        if (![[_dictContactDetails objectForKey:@"homeNumber"] isEqualToString:@""]) {
            selectedPhoneNumber = [_dictContactDetails objectForKey:@"homeNumber"];
        }
        
        
        if (selectedPhoneNumber != nil) {
            if (shouldMakeCall) {
                [self makeCallToNumber:selectedPhoneNumber];
            }
            else{
                [self sendSMSToNumber:selectedPhoneNumber];
            }
            
        }
    }
}


-(void)makeCallToNumber:(NSString *)numberToCall{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberToCall]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}


-(void)sendSMSToNumber:(NSString *)numberToSend{
    if (![MFMessageComposeViewController canSendText]) {
        NSLog(@"Unable to send SMS message.");
    }
    else {
        MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc] init];
        [sms setMessageComposeDelegate:self];
        
        [sms setRecipients:[NSArray arrayWithObjects:numberToSend, nil]];
        [sms setBody:@""];
        [self presentViewController:sms animated:YES completion:nil];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 2;
    }
    else{
        return 3;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Phone Numbers";
            break;
        case 1:
            return @"E-mail Addresses";
            break;
        case 2:
            return @"Address Info";
            break;
            
        default:
            return @"";
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSString *cellText = @"";
    NSString *detailText = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cellText = [_dictContactDetails objectForKey:@"mobileNumber"];
                    detailText = @"Mobile Number";
                    break;
                case 1:
                    cellText = [_dictContactDetails objectForKey:@"homeNumber"];
                    detailText = @"Home Number";
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    cellText = [_dictContactDetails objectForKey:@"homeEmail"];
                    detailText = @"Home E-mail";
                    break;
                case 1:
                    cellText = [_dictContactDetails objectForKey:@"workEmail"];
                    detailText = @"Work E-mail";
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    cellText = [_dictContactDetails objectForKey:@"address"];
                    detailText = @"Street Address";
                    break;
                case 1:
                    cellText = [_dictContactDetails objectForKey:@"zipCode"];
                    detailText = @"ZIP Code";
                    break;
                case 2:
                    cellText = [_dictContactDetails objectForKey:@"city"];
                    detailText = @"City";
                    break;
            }
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = cellText;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}


#pragma mark - IBAction method implementation

-(IBAction)makeCall:(id)sender{
    [self performPhoneAction:YES];
}


-(IBAction)sendSMS:(id)sender{
    [self performPhoneAction:NO];
}


#pragma mark - UIActionSheet Delegate method implementation

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Proceed if only the selected button index is other than 3 (the Cancel button).
    if (buttonIndex != 3) {
        // Get the selected phone number.
        NSString *selectedPhoneNumber = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        // If the action sheet tag is equal to 101 then make a call to the selected number.
        // Otherwise send a SMS.
        if ([actionSheet tag] == 101) {
            [self makeCallToNumber:selectedPhoneNumber];
        }
        else{
            [self sendSMSToNumber:selectedPhoneNumber];
        }
    }
    
}


#pragma mark - MessageComposeViewController Delegate method

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
