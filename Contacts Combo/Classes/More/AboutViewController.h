//
//  AboutViewController.h
//  Contacts Cop
//
//  Created by Partho on 9/16/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "GlobalConstants.h"
#import "CommonDefs.h"


@interface AboutViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *appIcon;
@property (weak, nonatomic) IBOutlet UILabel *appNameLable;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLable;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLable;

@property (weak, nonatomic) IBOutlet UIButton *companyUrlButton;



- (IBAction)CompanyUrlButtonTapped:(id)sender;


@end
