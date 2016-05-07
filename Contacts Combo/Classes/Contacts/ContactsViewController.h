//
//  ContactsViewController.h
//  Platinum Dialer
//
//  Created by Partho Biswas on 7/22/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>
#import "AppManager.h"
#import "GlobalConstants.h"
#import "CHSortedDictionary.h"
#import "ContactsTableViewCell.h"

#import "RHRefreshControl.h"
#import "CutomRefreshView.h"
#import "REFrostedViewController.h"





@interface ContactsViewController : UITableViewController <ABNewPersonViewControllerDelegate,  UISearchDisplayDelegate, UISearchBarDelegate, RHRefreshControlDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;

@property (nonatomic, strong) NSMutableArray *tableDataSections;

@property (nonatomic, strong) NSMutableArray *tableDataAfterSearcing;


- (IBAction)addContact:(id)sender;

- (IBAction)refresh;
- (IBAction)ShowMainMenu:(id)sender;


- (void) prepareContactsViewController;
- (void) customizeAppearance;
- (void) createGradientBackgroundColor;
- (UIImage *)imageFromLayer:(CALayer *)layer;




@end
