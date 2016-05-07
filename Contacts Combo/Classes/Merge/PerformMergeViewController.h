//
//  PerformMergeViewController.h
//  Contacts Cop
//
//  Created by Partho on 7/15/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "ContactMergingTableViewCell.h"
#import "Person.h"
#import "ABContact.h"
#import "DejalActivityView.h"
#import "RTSpinKitView.h"


@interface PerformMergeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *tableDataSections;


//@property (strong, nonatomic) IBOutlet DejalActivityView *activityIndicatorView;
//@property (strong, nonatomic) IBOutlet RTSpinKitView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mergeBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectBarButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *mergingInstructionsLable;


- (IBAction)PerformCancel:(id)sender;
- (IBAction)PerformMerge:(id)sender;

- (IBAction)PerformEdit:(id)sender;
- (IBAction)PerformSelect:(id)sender;

- (void) refreshDataAndLoadTable;
- (void) checkContactsForDuplicatesByName;
- (void) checkContactsForDuplicatesByNumber;
- (void) checkContactsForDuplicatesByEmail;
- (void) showAlertForNoDuplicates;

- (void) doTheMergingTask;

@end
