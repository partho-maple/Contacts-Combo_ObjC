//
//  PerformBackupViewController.h
//  Contacts Cop
//
//  Created by Partho on 8/19/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASProgressPopUpView.h"
#import "AppManager.h"
#import "AppDelegate.h"
#import "MyBackup.h"
#import "VCard.h"
#import "Base64.h"
#import "Person.h"

@interface PerformBackupViewController : UIViewController


@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *processedContactsLable;
@property (weak, nonatomic) IBOutlet UILabel *totalContactsLable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *performBackupBarButton;


- (IBAction)PerformCancel:(id)sender;
- (IBAction)PerformBackup:(id)sender;


@end
