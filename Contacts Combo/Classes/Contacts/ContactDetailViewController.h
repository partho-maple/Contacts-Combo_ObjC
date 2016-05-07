//
//  DetailViewController.h
//  Platinum Dialer
//
//  Created by Partho Biswas on 7/22/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "MarqueeLabel.h"
#import "GlobalConstants.h"



@interface ContactDetailViewController : UIViewController

@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *homeEmail;
@property (nonatomic, strong) NSString *workEmail;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *home;
@property (nonatomic, strong) UIImage *image;


- (IBAction)mobileHomeButtonTapped:(id)sender;
- (IBAction)mobileWorkButtonTapped:(id)sender;


- (void) checkNumberAndCall:(NSString *)number;

- (void) customizeAppearance;
- (void) createGradientBackgroundColor;



@end
