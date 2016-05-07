//
//  LoginSocialAccountsViewController.m
//  Contacts Cop
//
//  Created by Partho on 9/18/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "LoginSocialAccountsViewController.h"

@interface LoginSocialAccountsViewController ()

@end

@implementation LoginSocialAccountsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

    
    /*
    [self setTitle:@"Login"];
    
    // SHows the cancel button
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(PerformCancelForGoogleDrive)];
    self.navigationItem.leftBarButtonItem = closeButton;
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
    [self.view bringSubviewToFront:loginView];
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

- (IBAction)PerformFacebookLogin:(id)sender {
}

- (IBAction)PerformGoogleLogin:(id)sender {
}

- (IBAction)PerformTwitterLogin:(id)sender {
}

- (IBAction)PerformCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
