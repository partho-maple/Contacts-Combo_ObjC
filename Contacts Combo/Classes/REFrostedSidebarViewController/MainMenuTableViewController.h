//
//  MainMenuTableViewController.h
//  Contacts Cop
//
//  Created by Partho on 9/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

#import "MainNavigationController.h"

#import "NZCircularImageView.h"
#import "ContactsViewController.h"
#import "MainViewController.h"
#import "SyncViewController.h"
#import "MergeViewController.h"
#import "BackupViewController.h"
#import "CleanupViewController.h"
#import "SettingsTableViewController.h"
#import "MoreTableViewController.h"

@interface MainMenuTableViewController : UIViewController <UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *appTitle;
@property (weak, nonatomic) IBOutlet NZCircularImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *profileName;


@end
