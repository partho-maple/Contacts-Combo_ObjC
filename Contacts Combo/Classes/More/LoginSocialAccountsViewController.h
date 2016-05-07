//
//  LoginSocialAccountsViewController.h
//  Contacts Cop
//
//  Created by Partho on 9/18/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginSocialAccountsViewController : UIViewController


- (IBAction)PerformFacebookLogin:(id)sender;
- (IBAction)PerformGoogleLogin:(id)sender;
- (IBAction)PerformTwitterLogin:(id)sender;


- (IBAction)PerformCancel:(id)sender;



@end
