//
//  BackupViewController.m
//  Contacts Cop
//
//  Created by Partho on 8/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "BackupViewController.h"

@interface BackupViewController ()

@end

@implementation BackupViewController

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

- (void) viewWillAppear:(BOOL)animated
{
    [[AppManager getAppManagerInstance] setIsAdvancedBackup:NO];
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

- (IBAction)FastBackupButtonTapped:(id)sender {
    
    NSMutableArray *selectedContactsForBackupArray = [[NSMutableArray alloc] initWithArray:[ContactOpsUtils getAllContactsOutOfAddressBook]];
    
    if (selectedContactsForBackupArray.count > 0) {
        [[AppManager getAppManagerInstance] setSelectedContactsForFastBackupArray:selectedContactsForBackupArray];
        
        [[AppManager getAppManagerInstance] setIsAdvancedBackup:NO];
        [self performSegueWithIdentifier:@"FastBackupToPerformBackupSegue" sender: self];;
    }
}

- (IBAction)AdvancedBackupButtonTapped:(id)sender {
    [[AppManager getAppManagerInstance] setIsAdvancedBackup:YES];
    [self performSegueWithIdentifier:@"AdvancedBackupsToSelectionSegue" sender: self];
}

- (IBAction)ImportContactsButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"BackupToImportContactsSegue" sender:self];
}

- (IBAction)MyBackupsButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"BackupToMyBackupsSegue" sender: self];
}

@end
