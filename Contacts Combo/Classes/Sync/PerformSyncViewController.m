//
//  PerformSyncViewController.m
//  Contacts Cop
//
//  Created by Partho on 7/29/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "PerformSyncViewController.h"

@interface PerformSyncViewController ()

@end

@implementation PerformSyncViewController

@synthesize tableData, tableDataSections, tableView, syncBarButtonItem, cancelBarButtonItem, editBarButtonItem, syncingInstructionsLable;

RTSpinKitView *activityIndicatorView;
UIView *activityIndicatorViewPanel;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrData = [[NSMutableArray alloc] init];
    
    
    
    if ([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"Google"]) // Check duplicate contacts by Name
    {
        [self setTitle:@"Gmail Contacts"];
    }
    else if([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"Yahoo"]) // Check duplicate contacts by Number
    {
        [self setTitle:@"Yahoo Contacts"];
    }
    else if([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"LikedIn"]) // Check duplicate contacts by Email
    {
        [self setTitle:@"LikedIn Contacts"];
    }
    else if([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"Facebook"]) // Check duplicate contacts by Number
    {
        [self setTitle:@"Facebook Contacts"];
    }
    else if([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"Outlook"]) // Check duplicate contacts by Email
    {
        [self setTitle:@"Outlook Contacts"];
    }
    
    
    
    [syncingInstructionsLable setText:@""];
    [syncingInstructionsLable setAdjustsFontSizeToFitWidth:NO];
    [syncingInstructionsLable setLineBreakMode:NSLineBreakByWordWrapping];
    [syncingInstructionsLable setNumberOfLines:0];
    
    [syncBarButtonItem setEnabled:NO];
    [editBarButtonItem setEnabled:NO];
    
//    [self getGoogleContacts];
    
    [self showActivityIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self performSelector:@selector(refreshDataAndLoadTable) withObject:nil afterDelay:1.0];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Button Actions

- (IBAction)PerformCancel:(id)sender {
    //iOS6
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)PerformSync:(id)sender {
}

- (IBAction)PerformEdit:(id)sender {
}



#pragma mark - Methodes for UI Optimisation and Data Manipulation.


- (void) refreshDataAndLoadTable
{
    self.tableData = [NSMutableArray array];
    self.tableDataSections = [NSMutableArray array];
    
    
    
    if ([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"Google"]) // Check duplicate contacts by Name
    {
//        [self getGoogleContacts];
        [self setTitle:@"Gmail Contacts"];
    }
    else if([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"Yahoo"]) // Check duplicate contacts by Number
    {
        [self setTitle:@"Yahoo Contacts"];
    }
    else if([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"LikedIn"]) // Check duplicate contacts by Email
    {
        [self setTitle:@"LikedIn Contacts"];
    }
    else if([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"Facebook"]) // Check duplicate contacts by Number
    {
        [self setTitle:@"Facebook Contacts"];
    }
    else if([[[AppManager getAppManagerInstance] syncingType] isEqualToString:@"Outlook"]) // Check duplicate contacts by Email
    {
        [self setTitle:@"Outlook Contacts"];
    }
    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.editBarButtonItem.target = self;
    self.editBarButtonItem.action = @selector(PerformEdit:);
    
    
    //    Shows the table row animations
    //    ADLivelyTableView * livelyTableView = (ADLivelyTableView *)self.tableView;
    //    livelyTableView.initialCellTransformBlock = ADLivelyTransformFan;
    
    
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
    [syncingInstructionsLable setEnabled:YES];
    [editBarButtonItem setEnabled:YES];
    [syncingInstructionsLable setEnabled:YES];
    
    
    [self removeActivityIndicator];
}

- (void) showActivityIndicator
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        
        
        /*
         activityView = [DejalActivityView activityViewForView:activityIndicatorView withLabel:msg];
         //    [parrentView bringSubviewToFront:activityView];
         [activityView setupBackground];
         [activityView animateShow];
         //    [DejalActivityView activityViewForView:parrentView withLabel:@"Processing..."];
         //    [activityView setupBackground];
         */
        
        //    activityIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave color:[UIColor redColor]];
        //    [activityIndicatorView startAnimating];
        
        activityIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave color:[UIColor whiteColor]];
        [self insertSpinner:activityIndicatorView atIndex:0 backgroundColor:[UIColor colorWithRed:0.102 green:0.737 blue:0.612 alpha:0.5]];
        
    }];
}

- (void) removeActivityIndicator
{
    /*
     //    [DejalBezelActivityView removeViewAnimated:YES];
     [DejalActivityView removeView];
     */
    
    [activityIndicatorView stopAnimating];
    [activityIndicatorViewPanel setHidden:YES];
    
    //    [activityIndicatorView startAnimating];
    //    [activityIndicatorView setBackgroundColor:[UIColor clearColor]];
    //
    //    activityIndicatorView = [[self.view subviews] objectAtIndex:0];
    ////    activityIndicatorView = [self.view viewWithTag:0];
    [activityIndicatorView removeFromSuperview];
    //    [self.view setBackgroundColor:[UIColor clearColor]];
    
    for (UIView *subview in [self.view subviews]) {
        // Only remove the subviews with tag not equal to 1
        if (subview.tag == 900) {
            [subview removeFromSuperview];
        }
    }
    
}

-(void)insertSpinner:(RTSpinKitView*)spinner
             atIndex:(NSInteger)index
     backgroundColor:(UIColor*)backgroundColor
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = CGRectGetWidth(screenBounds);
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectOffset(screenBounds, screenWidth * index, 0.0)];
    panel.backgroundColor = backgroundColor;
    
    spinner.center = CGPointMake(CGRectGetMidX(screenBounds), CGRectGetMidY(screenBounds));
    [spinner startAnimating];
    
    [panel addSubview:spinner];
    [spinner setTag:900];
    
    UIScrollView *scrollView = (UIScrollView*)self.view;
    [self.view addSubview:panel];
    [self.view bringSubviewToFront:panel];
    activityIndicatorViewPanel = panel;
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactSyncingTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([arrData count] != 0) {
        NSDictionary *dict = [arrData objectAtIndex:indexPath.row];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", [dict objectForKey:@"name"], [dict objectForKey:@"emailId"]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




/*
#pragma mark - Methodes for Google Contacts Cyncing

-(void) getGoogleContacts
{
    NSLog(@">>>>>>>>>> get Contact Pressed");

    GDataServiceGoogleContact *service = [self contactService];
    GDataServiceTicket *ticket;
    
    BOOL shouldShowDeleted = TRUE;
    
    // request a whole buncha contacts; our service object is set to
    // follow next links as well in case there are more than 2000
    const int kBuncha = 2000;
    
    NSURL *feedURL = [GDataServiceGoogleContact contactFeedURLForUserID:kGDataServiceDefaultUser];
    
    GDataQueryContact *query = [GDataQueryContact contactQueryWithFeedURL:feedURL];
    [query setShouldShowDeleted:shouldShowDeleted];
    [query setMaxResults:kBuncha];
    
    ticket = [service fetchFeedWithQuery:query
                                delegate:self
                       didFinishSelector:@selector(contactsFetchTicket:finishedWithFeed:error:)];
    
    [self setContactFetchTicket:ticket];
}

- (GDataServiceGoogleContact *)contactService
{
    static GDataServiceGoogleContact* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleContact alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
    }
    
    // update the username/password each time the service is requested
    
    [service setUserCredentialsWithUsername:gmailID
                                   password:gmailpass];
    
    return service;
}

// contacts fetched callback

- (void)contactsFetchTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedContact *)feed
                      error:(NSError *)error {
    
    if (error) {
        NSLog(@">>>>>>>>>>>>>>>> Fetch error :------%@-------", [error description]);
    }
    
    NSArray *contacts = [feed entries];
    [arrData removeAllObjects];
    for (int i = 0; i < [contacts count]; i++) {
        GDataEntryContact *contact = [contacts objectAtIndex:i];
//        NSLog(@">>>>>>>>>>>>>>>> elementname contact :%@", [[[contact name] fullName] contentStringValue]);
        NSString *ContactName;
        //TODO: We have a crash here.
        ContactName = [[[contact name] fullName] contentStringValue];
        GDataEmail *email = [[contact emailAddresses] objectAtIndex:0];
        NSLog(@">>>>>>>>>>>>>>>> Contact's email id :%@", [email address]);
        NSString *ContactEmail = [email address];
        
        if (!ContactName || !ContactEmail) {
            NSLog(@">>>>>>>>>>>>> in if loop\n\n");
        }
        else
        {
            NSArray *keys = [[NSArray alloc] initWithObjects:@"name", @"emailId", nil];
            NSArray *objs = [[NSArray alloc] initWithObjects:ContactName, ContactEmail, nil];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
            [arrData addObject:dict];
        }
    }

    
    
    
    [self.tableView reloadData];
    
    //TODO: Refresh the dta source here
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self performSelector:@selector(refreshDataAndLoadTable) withObject:nil afterDelay:1.0];
    }];

}
 */
 
 
/*
- (void)contactsFetchTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedContact *)feed
                      error:(NSError *)error {
    GDataFeedContact *mContactFeed;
    if (error) {
        NSLog(@">>>>>>>>>>>>>>>> Fetch error :%@", [error description]);
    }else{//--If Login is success
        NSArray *entries = [mContactFeed entries];
        NSArray *contacts = [feed entries];
        
        for (int i = 0; i < [contacts count]; i++) {
            GDataEntryContact *contact = [contacts objectAtIndex:i];
            NSString *ContactName = [[[contact name] fullName] contentStringValue];
            GDataEmail *email = [[contact emailAddresses] objectAtIndex:0];
            NSString *ContactEmail = [email address];
            
            if ([ContactName length] == 0) {
                ContactName = @"Empty";
            }
            if ([ContactEmail length] > 0) {
                //Save email
            }
        }
    }
}
*/




/*
- (void)setContactFetchTicket:(GDataServiceTicket *)ticket
{
//    mContactFetchTicket release];
//    mContactFetchTicket = [ticket retain];
    
    mContactFetchTicket = nil;
    mContactFetchTicket = ticket;
}
*/






@end
