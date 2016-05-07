//
//  ShowBackupsTableViewController.h
//  Contacts Cop
//
//  Created by Partho on 8/21/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackupsTableViewCell.h"
#import "MyBackup.h"
#import <CoreData/CoreData.h>
#import "AppManager.h"
#import "AppDelegate.h"
#import "BackupOperationsViewController.h"

@interface ShowBackupsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;


// For Core Data
@property (strong, nonatomic) NSFetchedResultsController *cloudBackupFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *localBackupFetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
