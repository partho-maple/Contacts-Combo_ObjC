//
//  ImportSelectionViewController.h
//  Contacts Combo
//
//  Created by Partho on 9/20/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "GlobalConstants.h"
#import "CommonDefs.h"


@interface ImportSelectionViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *importingContactsSegment;


- (IBAction)PerformNext:(id)sender;

@end
