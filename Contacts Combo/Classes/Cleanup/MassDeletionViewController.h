//
//  MassDeletionViewController.h
//  Contacts Cop
//
//  Created by Partho on 8/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "ContactSyncingTableViewCell.h"
#import "Person.h"
#import "ABContact.h"
#import "RTSpinKitView.h"
#import "ContactOpsUtils.h"


@interface MassDeletionViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *tableDataSections;
@property (nonatomic, strong) NSMutableArray *tableDataAfterSearcing;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *PerformDeleteBarButton;
@property (weak, nonatomic) IBOutlet UILabel *deletionInstructionsLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectDeselectContactsBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelSelectionBarButton;



- (IBAction)PerformCancel:(id)sender;
- (IBAction)PerformDelete:(id)sender;

- (IBAction)SelectDeselectContactsBarButtonTapped:(id)sender;
- (IBAction)CancelBarButtonTapped:(id)sender;


- (void) refreshDataAndLoadTable;
- (void) doTheDeletionTask;

@end
