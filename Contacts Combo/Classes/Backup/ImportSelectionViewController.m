//
//  ImportSelectionViewController.m
//  Contacts Combo
//
//  Created by Partho on 9/20/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "ImportSelectionViewController.h"

@interface ImportSelectionViewController ()

@end

@implementation ImportSelectionViewController

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

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowContactsToPerformImportSegue"])
    {
        
    }
}

- (IBAction)PerformNext:(id)sender {
    [self performSegueWithIdentifier:@"ShowContactsToPerformImportSegue" sender: self];
}
@end
