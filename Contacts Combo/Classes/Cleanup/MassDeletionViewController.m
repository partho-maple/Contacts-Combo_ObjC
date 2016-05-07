//
//  MassDeletionViewController.m
//  Contacts Cop
//
//  Created by Partho on 8/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "MassDeletionViewController.h"
#import "DetailViewController.h"
#import "ADLivelyTableView.h"
#import "DejalActivityView.h"
#import "ColorUtils.h"

#define ConfirmDetetionAlertViewsTag 0
#define EmptyContactsAlertViewsTag 1
#define EmptyContactsSelectionToDeleteAlertViewsTag 2

@interface MassDeletionViewController ()

// Declaring private properties.
@property(nonatomic, readwrite) bool isSelectingRow;
@property(nonatomic, readwrite) bool isAllRowSelected;

- (void) refreshDataAndLoadTable;

@end

@implementation MassDeletionViewController

@synthesize PerformDeleteBarButton, deletionInstructionsLable,tableView, tableData, tableDataSections, tableDataAfterSearcing, selectDeselectContactsBarButton, cancelSelectionBarButton, isSelectingRow, isAllRowSelected;


RTSpinKitView *activityIndicatorView;
UIView *activityIndicatorViewPanel;
Person *person;
DetailViewController *contactViewController;
ContactSyncingTableViewCell *cell;

NSMutableArray *selectedNSIndexPathForDeletingArray;
NSMutableArray *selectedContactsForDeletingArray;



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
    

    if ([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"MassDeletion"]) // Check duplicate contacts by Name
    {
        [self setTitle:@"Mass Deletion"];
    }
    else if([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"MissingName"]) // Check duplicate contacts by Number
    {
        [self setTitle:@"Missing Name"];
    }
    else if([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"MissingPhoneNumber"]) // Check duplicate contacts by Email
    {
        [self setTitle:@"Missing Phone"];
    }
    else if([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"EmptyContacts"]) // Check duplicate contacts by Email
    {
        [self setTitle:@"Empty Contacts"];
    }
    
    
    [deletionInstructionsLable setText:@""];
    [deletionInstructionsLable setAdjustsFontSizeToFitWidth:NO];
    [deletionInstructionsLable setLineBreakMode:NSLineBreakByWordWrapping];
    [deletionInstructionsLable setNumberOfLines:0];
    
    
    [self.PerformDeleteBarButton setEnabled:NO];
    [self.selectDeselectContactsBarButton setEnabled:NO];
    [self.cancelSelectionBarButton setEnabled:NO];
    [self.selectDeselectContactsBarButton setEnabled:NO];
    [self.selectDeselectContactsBarButton setTitle:@""];
    
    
//    selectedNSIndexPathForDeletingArray = [NSMutableArray array];
//    selectedContactsForDeletingArray = [NSMutableArray array];
    
    
    [self showActivityIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    
    [self performSelector:@selector(refreshDataAndLoadTable) withObject:nil afterDelay:1.0];
    //    [self refreshDataAndLoadTable];
}




#pragma mark - TableView Delegate and DataSource

/* Code for implementing contacts section header starts from here.*/

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    } else {
        return nil;
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if ([[self.tableDataSections objectAtIndex:section] count] > 0) {
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
}

/* Code for implementing contacts section header ends here.*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableDataSections.count > 0) {
        return self.tableDataSections.count;
    }
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount;
    
    if (self.tableDataSections.count > 0) {
        rowCount =  [[self.tableDataSections objectAtIndex:section] count];
    }
    else
    {
        rowCount = [self.tableData count];
    }
    
    return rowCount;
}

/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (self.tableDataSections.count <= 0) {
            // If there is no buplicate contacts
            return nil;
        }
        else if ([[self.tableDataSections objectAtIndex:section] count] > 0) {
            NSMutableArray *sectionArray = [self.tableDataSections objectAtIndex:section];
            Person *person = (Person *)[sectionArray objectAtIndex:0];
            //            return person.fullName;
            return [self getTitleForHeaderSection:person];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}
*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ContactCleanupTableCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    // Configure the cell...
    Person *person;
    if (self.tableDataSections.count > 0)
    {
        person = [[self.tableDataSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
//        cell.name.text = person.fullName;
        cell.name.text = [self getCellLebelTextFor:person];
        cell.profileImage.image = person.image;
        
        cell.profileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        cell.profileImage.layer.cornerRadius=20;
        cell.profileImage.layer.borderWidth=1.0;
        cell.profileImage.layer.masksToBounds = YES;
        cell.profileImage.layer.borderColor=[[UIColor blackColor] CGColor];
        
        /*
        if ( (person.mobile == nil) || [person.mobile isEqualToString:@" "] ) {
            cell.number.text = person.home;
        } else {
            //             cell.numberLable.text = person.mobile;
            cell.number.text = [self getCellLebelTextFor:person];
        }
        */
        
        if ( ![person.home isEqualToString:@""] ) {
            cell.number.text = [NSMutableString stringWithFormat:@"%@", person.home];
        }
        else if ( ![person.mobile isEqualToString:@""] ) {
            cell.number.text = [NSMutableString stringWithFormat:@"%@", person.mobile];
        }
        else {
            cell.number.text = [NSMutableString stringWithFormat:@"No Number"];
        }
        
    }
    else
    {
        person = [self.tableData objectAtIndex:indexPath.row];
        
//        cell.name.text = person.fullName;
        cell.name.text = [self getCellLebelTextFor:person];
        cell.profileImage.image = person.image;
        
        cell.profileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        cell.profileImage.layer.cornerRadius=20;
        cell.profileImage.layer.borderWidth=1.0;
        cell.profileImage.layer.masksToBounds = YES;
        cell.profileImage.layer.borderColor=[[UIColor blackColor] CGColor];
        
        /*
        if ( (person.mobile == nil) || [person.mobile isEqualToString:@" "] ) {
            cell.number.text = person.home;
        } else {
            //             cell.numberLable.text = person.mobile;
            cell.number.text = [self getCellLebelTextFor:person];
        }
        */
        
        if ( ![person.home isEqualToString:@""] ) {
            cell.number.text = [NSMutableString stringWithFormat:@"%@", person.home];
        }
        else if ( ![person.mobile isEqualToString:@""] ) {
            cell.number.text = [NSMutableString stringWithFormat:@"%@", person.mobile];
        }
        else {
            cell.number.text = [NSMutableString stringWithFormat:@"No Number"];
        }
    }
    
    //     cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    // selecting row to merge
    if (isSelectingRow)
    {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (isAllRowSelected) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            
            if ([selectedContactsForDeletingArray containsObject:person]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (!isAllRowSelected)
        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if ([selectedContactsForDeletingArray containsObject:person]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        /*
        if ([defaultSelectedNSIndexPathForMergingArray containsObject:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        */
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    
    return cell;
}

- (NSString *) getCellLebelTextFor:(Person *)person
{
    NSMutableString *title = [NSMutableString stringWithString:@""];
    
    /*
    if ([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByName"]) // Check duplicate contacts by Name
    {
        title = [NSMutableString stringWithFormat:@"%@", person.mobile];
    }
    else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByNumber"]) // Check duplicate contacts by Number
    {
        title = [NSMutableString stringWithFormat:@"%@", person.mobile];
    }
    else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByEmail"]) // Check duplicate contacts by Email
    {
        title = [NSMutableString stringWithFormat:@"%@", person.homeEmail];
    }
    */
    
    if ([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"MassDeletion"]) // Check duplicate contacts by Name
    {
        title = [NSMutableString stringWithFormat:@"%@", person.fullName];
    }
    else if([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"MissingName"]) // Check duplicate contacts by Number
    {
        if ( (person.mobile == nil) || [person.mobile isEqualToString:@" "] ) {
            title = [NSMutableString stringWithFormat:@"%@", person.home];
        }
        else if ( (person.home == nil) || [person.home isEqualToString:@" "] ) {
            title = [NSMutableString stringWithFormat:@"%@", person.mobile];
        }
        else {
            title = [NSMutableString stringWithFormat:@"No Name"];
        }
    }
    else if([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"MissingPhoneNumber"]) // Check duplicate contacts by Email
    {
        
        if ( (person.fullName != nil) || (![person.fullName isEqualToString:@" "]) ) {
            title = [NSMutableString stringWithFormat:@"%@", person.fullName];
        }
        else {
            title = [NSMutableString stringWithFormat:@"No Name"];
        }
    }
    else if([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"EmptyContacts"]) // Check duplicate contacts by Email
    {
        title = [NSMutableString stringWithFormat:@"Empty Contact"];
    }
    
    return [NSString stringWithString:title];
}


#pragma mark - UITableViewDelegate

//customize uitablevoewcell with uiimage  and add uitableviewcell seperator

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Contacts_Cell_BG.png"]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *index = indexPath;
    NSInteger row = index.row;
    NSInteger section = index.section;
    
    [tableView beginUpdates];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableArray *sectionHeaderrray = self.tableDataSections[section];
        [sectionHeaderrray removeObjectAtIndex:row];
        
        
        if (sectionHeaderrray.count <= 0) {
            [self.tableDataSections removeObjectAtIndex:section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationRight];
            
        }
        else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    [tableView endUpdates];
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSelectingRow) {
        /*
        self.lastIndexPath = indexPath;
        
        NSIndexPath *changedIndex = defaultSelectedNSIndexPathForMergingArray[indexPath.section];
        changedIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] ;
        [defaultSelectedNSIndexPathForMergingArray replaceObjectAtIndex:indexPath.section withObject:changedIndex];
        
        [selectedContactToMergeWithArray replaceObjectAtIndex:indexPath.section withObject:[NSString stringWithFormat:@"%d", indexPath.row]];
        
        [tableView reloadData];
        */
        
        // gets the selected person
        if (self.tableDataSections.count > 0) {
            person = [[self.tableDataSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        else {
            person = [self.tableData objectAtIndex:indexPath.row];
        }
        
        // removes the selected object from the deletion array.
        if ([selectedContactsForDeletingArray containsObject:person]) {
            [selectedContactsForDeletingArray removeObject:person];
        }
        else {
            [selectedContactsForDeletingArray addObject:person];
        }
        
        
        [self.tableView reloadData];
        
    } else {
        if (self.tableDataSections.count > 0) {
            person = [[self.tableDataSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        else {
            person = [self.tableData objectAtIndex:indexPath.row];
        }
        
        [self performSegueWithIdentifier:@"MassDeletionToContactDetailsSegue" sender: self];
    }
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MassDeletionToContactDetailsSegue"])
    {
        if (person.firstName == nil) {
            person.firstName = @"";
        }
        if (person.lastName == nil) {
            person.lastName = @"";
        }
        if (person.mobile == nil) {
            person.mobile = @"";
        }
        if (person.home == nil) {
            person.home = @"";
        }
        if (person.homeEmail == nil) {
            person.homeEmail = @"";
        }
        if (person.workEmail == nil) {
            person.workEmail = @"";
        }
        if (person.address == nil) {
            person.address = @"";
        }
        if (person.zipCode == nil) {
            person.zipCode = @"";
        }
        if (person.city == nil) {
            person.city = @"";
        }
        
        NSMutableDictionary *contactDetailsDictionary = [[NSMutableDictionary alloc] initWithObjects:@[person.firstName, person.lastName, person.image, person.mobile, person.home, person.homeEmail, person.workEmail, person.address, person.zipCode, person.city] forKeys:@[@"firstName", @"lastName", @"image", @"mobileNumber", @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city"]];
        [[segue destinationViewController] setDictContactDetails:contactDetailsDictionary];
    }
}



#pragma mark - Class Member Methodes

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:animated];
}

-(BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
}


- (void) showActivityIndicator
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        activityIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave color:[UIColor whiteColor]];
        [self insertSpinner:activityIndicatorView atIndex:0 backgroundColor:[UIColor colorWithRed:0.102 green:0.737 blue:0.612 alpha:0.5]];
        
    }];
}

- (void) removeActivityIndicator
{
    [activityIndicatorView stopAnimating];
    [activityIndicatorViewPanel setHidden:YES];
    
    [activityIndicatorView removeFromSuperview];
    
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

- (void) refreshDataAndLoadTable
{
    
    ABAddressBookRef addressBookRef;
    //    sortNameAlphabetically = [NSSortDescriptor sortDescriptorWithKey:CONTACTS_SORT_KEY ascending:YES];
    
    
    
    if ([[AppManager getAppManagerInstance] iOSVersion6ToUpper])
    {
        //        NSLog(@"The version is iOS 6 and Upper");
    }
    else {
        //        NSLog(@"The version is below iOS 6 (iOS 4/5)...");
    }
    
    
    
    
    
    if ([self isABAddressBookCreateWithOptionsAvailable])
    {
        // Request to authorise the app to use addressbook
        addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
        
        
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    // If the app is authorized to access the first time then add the contact
                    //                    NSLog(@"111");
                    
                    [self prepareContactsViewControlle];
                } else {
                    // Show an alert here if user denies access telling that the contact cannot be added because you didn't allow it to access the contacts
                    //                    NSLog(@"222");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Access Not Allowed !" message:@"To see contacts, go to Settings->Privacy->Contacts and enable Platinum Dialer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            // If the user user has earlier provided the access, then add the contact
            //            NSLog(@"333");
            
            [self prepareContactsViewControlle];
        }
        else {
            // If the user user has NOT earlier provided the access, create an alert to tell the user to go to Settings app and allow access
            //            NSLog(@"444");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Access Not Allowed !" message:@"To see contacts, go to Settings->Privacy->Contacts and enable Platinum Dialer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else
    {
        //        NSLog(@"The version is below iOS 6 (iOS 4/5)...");
        addressBookRef = ABAddressBookCreate();
        [self prepareContactsViewControlle];
    }
    
    
    
    
    
    
    
    
    
    
    
    if (self.tableData.count > 0) {
        isSelectingRow = NO;
        isAllRowSelected = NO;
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        
        [self.tableView reloadData];
        [self.tableView reloadInputViews];
        //    [PerformDeleteBarButton setEnabled:YES];
        [selectDeselectContactsBarButton setEnabled:YES];
        [cancelSelectionBarButton setEnabled:YES];
        [deletionInstructionsLable setText:@"Click 'Select'>Select contacts to delete"];
    }
    else {
        UIAlertView* messageForEmptyContacts = [[UIAlertView alloc]
                                                initWithTitle: @"Empty Address Book !"
                                                message:@"Your Address Book is empty."
                                                delegate: self
                                                cancelButtonTitle: @"OK"
                                                otherButtonTitles: nil, nil];
        messageForEmptyContacts.tag = EmptyContactsSelectionToDeleteAlertViewsTag;
        [messageForEmptyContacts show];
        
        [deletionInstructionsLable setText:@"Your Address Book is empty"];
    }
    
    
    
    [self removeActivityIndicator];
    
    [self.tableView reloadData];
}


- (void) prepareContactsViewControlle
{
    if (self.tableData == nil) {
//        self.tableData = [[NSMutableArray alloc] init];
        
        
        
        if ([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"MassDeletion"]) // Check duplicate contacts by Name
        {
            self.tableData = [[NSMutableArray alloc] initWithArray:[ContactOpsUtils getAllContactsOutOfAddressBook]];
        }
        else if([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"MissingName"]) // Check duplicate contacts by Number
        {
            self.tableData = [[NSMutableArray alloc] initWithArray:[ContactOpsUtils getContactsWithMissingNameOutOfAddressBook]];
        }
        else if([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"MissingPhoneNumber"]) // Check duplicate contacts by Email
        {
            self.tableData = [[NSMutableArray alloc] initWithArray:[ContactOpsUtils getContactsWithMissingPhoneOutOfAddressBook]];
        }
        else if([[[AppManager getAppManagerInstance] cleanupType] isEqualToString:@"EmptyContacts"]) // Check duplicate contacts by Email
        {
            self.tableData = [[NSMutableArray alloc] initWithArray:[ContactOpsUtils getEmptyContactsOutOfAddressBook]];
        }
        
        
        self.tableDataSections = [NSMutableArray array];
        self.tableDataAfterSearcing = [[NSMutableArray alloc] init];
        
        
        
        
        
        //----------Search through the table data and arrange those according to indeces----------STARTS
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        
        NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
        for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
            [unsortedSections addObject:[NSMutableArray array]];
        }
        
        for (Person *personName in self.tableData) {
            NSInteger index = [collation sectionForObject:personName collationStringSelector:@selector(firstName)];
            [[unsortedSections objectAtIndex:index] addObject:personName];
        }
        
        NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
        for (NSMutableArray *section in unsortedSections) {
            [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
        }
        
        self.tableDataSections = sortedSections;
        //----------Search through the table data and arrange those according to indeces----------ENDS
        
        
        
        //        For testing purpose. Delete it after a while.
        [[AppManager getAppManagerInstance] setTableData:self.tableData];
        [[AppManager getAppManagerInstance] setTableDataSections:self.tableDataSections];
        
        
        
        
        
        
        //    Shows the table row animations
//        ADLivelyTableView * livelyTableView = (ADLivelyTableView *)self.tableView;
//        livelyTableView.initialCellTransformBlock = ADLivelyTransformFan;
    }
}



- (void) doTheDeletionTask
{

}





#pragma mark - Button Actions Methodes

- (IBAction)PerformCancel:(id)sender {
    //iOS6
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)PerformDelete:(id)sender {
    
    if (selectedContactsForDeletingArray.count > 0) {
        NSString *messageString = [[NSString alloc] initWithFormat:@"You have selected %lu contacts. These contacts will entirely be removed from Address Book.", (unsigned long)selectedContactsForDeletingArray.count];
        UIAlertView* message = [[UIAlertView alloc]
                                initWithTitle: @"Are you sure to delete ?"
                                message:messageString
                                delegate: self
                                cancelButtonTitle: @"Cancel"
                                otherButtonTitles: @"OK", nil];
        
        message.tag = ConfirmDetetionAlertViewsTag;
        [message show];
    } else {
        UIAlertView* messageForEmptyContacts = [[UIAlertView alloc]
                                initWithTitle: @"Selection Empty !"
                                message:@"No contacts have been selected to delete."
                                delegate: self
                                cancelButtonTitle: @"OK"
                                otherButtonTitles: nil, nil];
        
        messageForEmptyContacts.tag = EmptyContactsAlertViewsTag;
        [messageForEmptyContacts show];
    }
    
}

- (IBAction)SelectDeselectContactsBarButtonTapped:(id)sender {
    if (isAllRowSelected) {
        isAllRowSelected = NO;
//        [self.cancelSelectionBarButton setTitle:@"Select"];
//        [self.selectDeselectContactsBarButton setEnabled:NO];
        [self.selectDeselectContactsBarButton setTitle:@"Select All"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selectedContactsForDeletingArray removeAllObjects];
    } else {
        isAllRowSelected = YES;
//        [self.cancelSelectionBarButton setTitle:@"Cancel"];
//        [self.selectDeselectContactsBarButton setEnabled:YES];
        [self.selectDeselectContactsBarButton setTitle:@"Unselect All"];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        selectedContactsForDeletingArray = self.tableData;
        [selectedContactsForDeletingArray addObjectsFromArray:self.tableData];
    }
    
    
    [self.tableView reloadData];
}

- (IBAction)CancelBarButtonTapped:(id)sender {
    if (isSelectingRow) {
        isSelectingRow = NO;
        isAllRowSelected = NO;
        [self.cancelSelectionBarButton setTitle:@"Select"];
        [self.selectDeselectContactsBarButton setEnabled:NO];
        [PerformDeleteBarButton setEnabled:NO];
        [self.selectDeselectContactsBarButton setTitle:@""];
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        selectedContactsForDeletingArray = nil;
//        [selectedContactsForDeletingArray removeAllObjects];
    } else {
        isSelectingRow = YES;
        isAllRowSelected = YES;
        [self.cancelSelectionBarButton setTitle:@"Cancel"];
        [self.selectDeselectContactsBarButton setEnabled:YES];
        [PerformDeleteBarButton setEnabled:YES];
        [self.selectDeselectContactsBarButton setTitle:@"Unselect All"];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (selectedContactsForDeletingArray == nil) {
            selectedContactsForDeletingArray = [[NSMutableArray alloc] initWithArray:self.tableData];
        }
//        selectedContactsForDeletingArray = [[NSMutableArray alloc] initWithArray:self.tableData];
//        selectedContactsForDeletingArray = self.tableData;
    }
    
    
    [self.tableView reloadData];
}



#pragma mark - alertView delegate Methodes

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == ConfirmDetetionAlertViewsTag)
    {
        if (buttonIndex == alertView.cancelButtonIndex) {
            // Cancel was tapped

            
        }
        else if (buttonIndex == alertView.firstOtherButtonIndex)
        {
            // The other button was tapped
            
            CFErrorRef error = NULL;
            
            ABAddressBookRef addressBook;
            if ([self isABAddressBookCreateWithOptionsAvailable])
            {
                addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            }
            else
            {
                // iOS 4/5
                addressBook = ABAddressBookCreate();
            }
            
            for (int i = 0; i < selectedContactsForDeletingArray.count; i++) {
                
                Person *person = [selectedContactsForDeletingArray objectAtIndex:i];
//                NSLog(@"Name : %@", person.fullName);
                ABRecordID personRecordID =  ABRecordGetRecordID(person.personRecordRef);
                
                
//                ABContact *customContact = [ABContact contactWithRecord:person.personRecordRef];
                ABContact *customContact = [ABContact contactWithRecordID:person.personRecordID];
                
                NSLog(@"Name : %@", customContact.contactName);
                
//                ABRecordRef currentABRecordRef = person.personRecordRef;
//                Person *currentPerson = [[Person alloc] initWithPersonRef:(__bridge id)(currentABRecordRef)];
//                NSLog(@"Name : %@", currentPerson.fullName);
                
//                CFErrorRef error = NULL;
//                ABAddressBookRef addressBook;
//                if ([self isABAddressBookCreateWithOptionsAvailable])
//                {
//                    addressBook = ABAddressBookCreateWithOptions(NULL, &error);
//                }
//                else
//                {
//                    // iOS 4/5
//                    addressBook = ABAddressBookCreate();
//                }
                
//                ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBook, personRecordID);
//                Person *newPerson = [[Person alloc] initWithPersonRef:(__bridge id)(personRef)];
//                NSLog(@"Name : %@", newPerson.fullName);
                
                // remove comparingPerson from address book but not from tableDataSections.
                bool isRemoved = ABAddressBookRemoveRecord(addressBook, customContact.record, &error);
//                NSError *err = nil;
//                [customContact removeSelfFromAddressBook:<#(NSError *__autoreleasing *)#>];
                
                if(isRemoved){
                    NSLog(@"ABAddress removed..");
                }
                else {
                    NSLog(@"ABAddressBookRemove %@", error);
                }

                
                
//                bool isSaved = ABAddressBookSave (addressBook, &error );
//                if(isSaved){
//                    NSLog(@"ABAddressBook Saved..");
//                }
//                if (error != NULL) {
//                    NSLog(@"ABAddressBookSave %@", error);
//                }
//
//                CFRelease(addressBook);
            }
            
            bool isSaved = ABAddressBookSave (addressBook, &error );
            if(isSaved){
                NSLog(@"ABAddressBook Saved..");
            }
            if (error != NULL) {
                NSLog(@"ABAddressBookSave %@", error);
            }
            CFRelease(addressBook);
            
            self.tableData = nil;
            [self showActivityIndicator];
            
            
            isSelectingRow = NO;
            isAllRowSelected = NO;
            [self.PerformDeleteBarButton setEnabled:NO];
            [self.selectDeselectContactsBarButton setEnabled:NO];
            [self.cancelSelectionBarButton setEnabled:YES];
            [self.selectDeselectContactsBarButton setEnabled:NO];
            [self.selectDeselectContactsBarButton setTitle:@""];
            [self.cancelSelectionBarButton setTitle:@"Select"];
            [self performSelector:@selector(refreshDataAndLoadTable) withObject:nil afterDelay:1.0];
            
//            [self.tableView reloadData];
            
        }
    }
}


- (void) viewDidUnload
{
    [[AppManager getAppManagerInstance] setCleanupType:[NSMutableString stringWithString:@"none"]];
}




@end
