//
//  MergeViewController.m
//  Contacts Cop
//
//  Created by Partho on 7/15/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "MergeViewController.h"

@interface MergeViewController ()

@end

@implementation MergeViewController

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

- (IBAction)ShowMainMenu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)MergeByName:(id)sender {
    [[AppManager getAppManagerInstance] setMergingType:[NSMutableString stringWithString:@"ByName"]];
    [self performSegueWithIdentifier:@"performMergeSegue" sender: self];
}

- (IBAction)MergeByNumber:(id)sender {
    [[AppManager getAppManagerInstance] setMergingType:[NSMutableString stringWithString:@"ByNumber"]];
    [self performSegueWithIdentifier:@"performMergeSegue" sender: self];
}

- (IBAction)MergeByEmail:(id)sender {
    [[AppManager getAppManagerInstance] setMergingType:[NSMutableString stringWithString:@"ByEmail"]];
    [self performSegueWithIdentifier:@"performMergeSegue" sender: self];
}

@end
