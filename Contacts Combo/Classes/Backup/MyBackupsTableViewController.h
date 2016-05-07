//
//  MyBackupsTableViewController.h
//  Contacts Cop
//
//  Created by Partho on 8/21/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppManager.h"
#import "AppDelegate.h"
#import "ShowBackupsTableViewController.h"

@interface MyBackupsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *cloudStorageDeviceNameLable;

@property (weak, nonatomic) IBOutlet UILabel *lastCloudBackupTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *cloudBackupCountLable;

@property (weak, nonatomic) IBOutlet UILabel *lastLocalBackupTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *localBackupCountLable;

// For Core Data
@property (strong, nonatomic) NSFetchedResultsController *cloudBackupFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *localBackupFetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (IBAction)PerformCancel:(id)sender;



@end
