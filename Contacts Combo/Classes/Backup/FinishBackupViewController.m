//
//  FinishBackupViewController.m
//  Contacts Cop
//
//  Created by Partho on 8/20/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "FinishBackupViewController.h"

@interface FinishBackupViewController ()

@end

@implementation FinishBackupViewController

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
    
    self.navigationItem.hidesBackButton = YES;
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

- (IBAction)PerformUploadToCloud:(id)sender {
}

- (IBAction)PerformEmailBackup:(id)sender {
}

- (IBAction)PerformExportContacts:(id)sender {
}

- (IBAction)PerformDone:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([[AppManager getAppManagerInstance] isAdvancedBackup]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
