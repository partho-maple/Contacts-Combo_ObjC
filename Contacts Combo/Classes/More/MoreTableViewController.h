//
//  MoreTableViewController.h
//  Contacts Cop
//
//  Created by Partho on 9/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppManager.h"
#import "GlobalConstants.h"
#import "CommonDefs.h"
#import "REFrostedViewController.h"
#import "CTFeedbackViewController.h"
#import "AppGalleryView.h"

#import "AMSmoothAlertView.h"
#import "AMSmoothAlertConstants.h"

#import "MIBAboutController.h"

#import "IBActionSheet.h"

#import "RFRateMe.h"

#import "LoginSocialAccountsViewController.h"


@interface MoreTableViewController : UITableViewController <AMSmoothAlertViewDelegate, IBActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

- (IBAction)ShowMainMenu:(id)sender;

@end
