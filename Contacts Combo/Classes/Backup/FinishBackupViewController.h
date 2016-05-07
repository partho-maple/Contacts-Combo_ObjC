//
//  FinishBackupViewController.h
//  Contacts Cop
//
//  Created by Partho on 8/20/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"

@interface FinishBackupViewController : UIViewController


- (IBAction)PerformUploadToCloud:(id)sender;
- (IBAction)PerformEmailBackup:(id)sender;
- (IBAction)PerformExportContacts:(id)sender;

- (IBAction)PerformDone:(id)sender;

@end
