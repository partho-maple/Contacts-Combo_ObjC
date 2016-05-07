//
//  AboutViewController.m
//  Contacts Cop
//
//  Created by Partho on 9/16/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize appIcon, appNameLable, appVersionLable, companyNameLable, companyUrlButton;


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
    
    [appNameLable setText:APP_NAME];
    [appVersionLable setText:APP_VERSION];
    [companyNameLable setText:COMPANY_NAME];
    [companyUrlButton setTitle:COMPANY_URL forState:UIControlStateNormal];
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

- (IBAction)CompanyUrlButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@", COMPANY_URL]]];
}
@end
