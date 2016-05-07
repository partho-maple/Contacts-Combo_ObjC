//
//  PerformSyncViewController.h
//  Contacts Cop
//
//  Created by Partho on 7/29/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "RTSpinKitView.h"
#import "GlobalConstants.h"


//#import "GData.h"
//#import "GDataFeedContact.h"
//#import "GDataContacts.h"

@interface PerformSyncViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arrData;
    
//    GDataFeedContact *mContactFeed;
//    GDataServiceTicket *mContactFetchTicket;
//    NSError *mContactFetchError;
//    
//    NSString *mContactImageETag;
//    
//    GDataFeedContactGroup *mGroupFeed;
//    GDataServiceTicket *mGroupFetchTicket;
//    NSError *mGroupFetchError;
}


//- (void)setContactFetchTicket:(GDataServiceTicket *)ticket;
//- (GDataServiceGoogleContact *)contactService;
//- (NSArray *)sortedEntries:(NSArray *)entries;








@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *tableDataSections;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *syncBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *syncingInstructionsLable;


- (IBAction)PerformCancel:(id)sender;
- (IBAction)PerformSync:(id)sender;
- (IBAction)PerformEdit:(id)sender;

- (void) refreshDataAndLoadTable;
- (void) syncGoogleContacts;
- (void) syncYahooContacts;
- (void) syncLinkedInContacts;
- (void) syncFacebookContacts;
- (void) syncOutlookContacts;

- (void) doTheMergingTask;

@end
