//
//  DetailViewController.m
//  Platinum Dialer
//
//  Created by Partho Biswas on 7/22/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "UIViewController+RECurtainViewController.h"
#import "MarqueeLabel.h"


@interface ContactDetailViewController ()


@property (nonatomic, strong) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *lastNameLabel;
@property (nonatomic, strong) IBOutlet MarqueeLabel *homeEmailLabel;
@property (nonatomic, strong) IBOutlet MarqueeLabel *workEmailLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageField;


@property (weak, nonatomic) IBOutlet UIButton *mobileHomeButton;
@property (weak, nonatomic) IBOutlet UIButton *mobileWorkButton;


- (IBAction)mobileHomeButtonTapped:(id)sender;
- (IBAction)mobileWorkButtonTapped:(id)sender;




@end

@implementation ContactDetailViewController

@synthesize firstName, firstNameLabel, lastName, lastNameLabel, homeEmail, homeEmailLabel, workEmail, workEmailLabel, mobile, mobileWorkButton, home, mobileHomeButton, image, imageField;


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
    
    //  Creates the custome UI
    [self customizeAppearance];

    self.title = @"Info";
	
    
    firstName = self.person.firstName;
    lastName = self.person.lastName;
    homeEmail = self.person.homeEmail;
    workEmail = self.person.workEmail;
    mobile = self.person.mobile;
    home = self.person.home;
    image = self.person.image;
    
    
    
    mobileHomeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    mobileWorkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.firstNameLabel.text = [NSString stringWithFormat:@"%@ %@",  firstName ? firstName : @"", lastName ? lastName: @""];
    self.homeEmailLabel.text = homeEmail;
    self.workEmailLabel.text = workEmail;
    [mobileHomeButton setTitle:mobile forState:UIControlStateNormal];
    [mobileWorkButton setTitle:home forState:UIControlStateNormal];
    self.imageField.image = image;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [homeEmailLabel restartLabel];
    [homeEmailLabel unpauseLabel];
    
    [workEmailLabel restartLabel];
    [workEmailLabel unpauseLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mobileHomeButtonTapped:(id)sender {
    
    [self checkNumberAndCall:[mobileHomeButton.titleLabel.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (IBAction)mobileWorkButtonTapped:(id)sender {
    [self checkNumberAndCall:[mobileWorkButton.titleLabel.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];}

- (void) checkNumberAndCall:(NSString *)number
{
    NSString *phoneNum = number;
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"+" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
}

-(void)customizeAppearance
{
    
    [self   createGradientBackgroundColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIImageView *proPicture = [[UIImageView alloc] initWithImage:image];
//    cell.imageView.image = person.image;
    proPicture.layer.backgroundColor=[[UIColor clearColor] CGColor];
    proPicture.layer.cornerRadius=20;
    proPicture.layer.borderWidth=1.0;
    proPicture.layer.masksToBounds = YES;
    proPicture.layer.borderColor=[[UIColor blackColor] CGColor];
    
}

- (void) createGradientBackgroundColor
{
    UIColor *lightOp = backgroundColorGradientTop;
    UIColor *darkOp = backgroundColorGradientBottom;
    
    
    // Create the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)lightOp.CGColor,
                       (id)darkOp.CGColor,
                       nil];
    
    // Set bounds
    gradient.frame = self.view.bounds;
    
    // Add the gradient to the view
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    
    //    gradient.locations = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.8], nil];
}



- (void) dealloc
{
    _person = nil;
    firstName = nil;
    firstNameLabel = nil;
    lastName = nil;
    lastNameLabel = nil;
    homeEmail = nil;
    homeEmailLabel = nil;
    workEmail = nil;
    workEmailLabel = nil;
    mobile = nil;
    mobileWorkButton = nil;
    home = nil;
    mobileHomeButton = nil;
    image = nil;
    imageField = nil;
}



@end
