//
//  BackupViewController.h
//  Contacts Cop
//
//  Created by Partho on 8/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "ContactOpsUtils.h"
#import "REFrostedViewController.h"

@interface BackupViewController : UIViewController



- (IBAction)ShowMainMenu:(id)sender;

- (IBAction)FastBackupButtonTapped:(id)sender;
- (IBAction)AdvancedBackupButtonTapped:(id)sender;
- (IBAction)ImportContactsButtonTapped:(id)sender;
- (IBAction)MyBackupsButtonTapped:(id)sender;


@end
