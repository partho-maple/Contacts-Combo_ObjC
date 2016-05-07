//
//  AdvancedBackupsContactSelectionViewController.h
//  Contacts Cop
//
//  Created by Partho on 8/18/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "ContactSyncingTableViewCell.h"
#import "Person.h"
#import "ABContact.h"
#import "RTSpinKitView.h"
#import "ContactOpsUtils.h"

@interface AdvancedBackupsContactSelectionViewController : UIViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *tableDataSections;
@property (nonatomic, strong) NSMutableArray *tableDataAfterSearcing;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *PerformNextBarButton;
@property (weak, nonatomic) IBOutlet UILabel *backupsInstructionsLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectDeselectContactsBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelSelectionBarButton;



- (IBAction)PerformCancel:(id)sender;
- (IBAction)PerformNext:(id)sender;

- (IBAction)SelectDeselectContactsBarButtonTapped:(id)sender;
- (IBAction)CancelBarButtonTapped:(id)sender;


- (void) refreshDataAndLoadTable;
- (void) doTheNextTask;

@end
