//
//  BackupOperationsViewController.h
//  Contacts Cop
//
//  Created by Partho on 8/21/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>


#import "MyBackup.h"
#import "AppManager.h"
#import "AppDelegate.h"
#import "AAActivityAction.h"
#import "AAActivity.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

#import "GoogleDriveFileSaverTableViewController.h"

@interface BackupOperationsViewController : UIViewController <UIApplicationDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) MyBackup *selectedBackupEntry;
@property (nonatomic, retain) GTLServiceDrive *driveService;

- (IBAction)PerformUploadToCloud:(id)sender;
- (IBAction)PerformSendingEmail:(id)sender;
- (IBAction)PerformExportingContacts:(id)sender;
- (IBAction)PerformRestoringContacts:(id)sender;


@end
