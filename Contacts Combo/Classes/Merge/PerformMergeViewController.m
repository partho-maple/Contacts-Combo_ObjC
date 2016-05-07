//
//  PerformMergeViewController.m
//  Contacts Cop
//
//  Created by Partho on 7/15/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "PerformMergeViewController.h"
#import "DetailViewController.h"
#import "ADLivelyTableView.h"
#import "DejalActivityView.h"
#import "ColorUtils.h"

@interface PerformMergeViewController ()

// Declaring private properties.
@property(nonatomic, readwrite) bool isSelectingRow;
@property(retain) NSIndexPath* lastIndexPath;
//@property (strong, nonatomic) RTSpinKitView *activityIndicatorView;

@end

@implementation PerformMergeViewController

@synthesize tableData,tableDataSections, isSelectingRow, lastIndexPath, mergingInstructionsLable, cancelBarButtonItem, mergeBarButtonItem, editBarButtonItem, selectBarButtonItem;

DejalActivityView *activityView;
RTSpinKitView *activityIndicatorView;
UIView *activityIndicatorViewPanel;
Person *person;
DetailViewController *contactViewController;
ContactMergingTableViewCell *cell;
NSMutableArray *defaultSelectedNSIndexPathForMergingArray;
NSIndexPath *defaultSelectedNSIndexPathForMerging;
NSMutableArray *selectedContactToMergeWithArray;

NSMutableArray *fullNameDictionaryKeysArray;
NSMutableArray *fullNameDictionaryValuesArray;

NSMutableArray *phoneNumberDictionaryKeysArray;
NSMutableArray *phoneNumberDictionaryValuesArra;

NSMutableArray *emailDictionaryKeysArray;
NSMutableArray *emailDictionaryValuesArray;

int personPropertyArrayForMergingByName[9];
int personPropertyArrayForMergingByNumber[15];
int personPropertyArrayForMergingByEmail[15];

int personPropertyArrayForMergingByNameArraySize = 9;
int personPropertyArrayForMergingByNumberArraySize = 15;
int personPropertyArrayForMergingByEmailArraySize = 15;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    [mergingInstructionsLable setText:@""];
    [mergingInstructionsLable setAdjustsFontSizeToFitWidth:NO];
    [mergingInstructionsLable setLineBreakMode:NSLineBreakByWordWrapping];
    [mergingInstructionsLable setNumberOfLines:0];
    
    [mergeBarButtonItem setEnabled:NO];
    [editBarButtonItem setEnabled:NO];
    [selectBarButtonItem setEnabled:NO];
    
    
    [self showActivityIndicator];
    
    
    /*
     isSelectingRow = NO;
     
     
     self.tableData = [NSMutableArray array];
     self.tableDataSections = [NSMutableArray array];
     defaultSelectedNSIndexPathForMergingArray = [NSMutableArray array];
     selectedContactToMergeWithArray = [NSMutableArray array];
     
     
     // Defines the merfing arrays
     [self declarePersonPropertyArray];
     
     
     
     if ([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByName"]) // Check duplicate contacts by Name
     {
     [self checkContactsForDuplicatesByName];
     }
     else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByNumber"]) // Check duplicate contacts by Number
     {
     [self checkContactsForDuplicatesByNumber];
     }
     else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByEmail"]) // Check duplicate contacts by Email
     {
     [self checkContactsForDuplicatesByEmail];
     }
     
     for (int i = 0; i < self.tableDataSections.count; i++) {
     defaultSelectedNSIndexPathForMerging = [NSIndexPath indexPathForRow:0 inSection:i];
     [defaultSelectedNSIndexPathForMergingArray addObject:defaultSelectedNSIndexPathForMerging];
     }
     
     
     [self.tableView setDelegate:self];
     [self.tableView setDataSource:self];
     
     self.editBarButtonItem.target = self;
     self.editBarButtonItem.action = @selector(PerformEdit:);
     
     self.selectBarButtonItem.target = self;
     self.selectBarButtonItem.action = @selector(PerformSelect:);
     
     //    Shows the table row animations
     //    ADLivelyTableView * livelyTableView = (ADLivelyTableView *)self.tableView;
     //    livelyTableView.initialCellTransformBlock = ADLivelyTransformFan;
     
     */
    
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




- (void) declarePersonPropertyArray
{
    
    int personPropertyArrayForMergingByName1[9] = {
        kABPersonOrganizationProperty,
        kABPersonJobTitleProperty,
        kABPersonDepartmentProperty,
        kABPersonEmailProperty,
        kABPersonBirthdayProperty,
        kABPersonNoteProperty,
        kABPersonAddressProperty,
        kABPersonPhoneProperty,
        kABPersonInstantMessageProperty
//        kABPersonRelatedNamesProperty
    };
    memcpy(personPropertyArrayForMergingByName, personPropertyArrayForMergingByName1, personPropertyArrayForMergingByNameArraySize*sizeof(int));
    
    
    
    
    int personPropertyArrayForMergingByNumber1[15] = {
        kABPersonFirstNameProperty,
        kABPersonLastNameProperty,
        kABPersonMiddleNameProperty,
        kABPersonNicknameProperty,
        kABPersonFirstNamePhoneticProperty,
        kABPersonLastNamePhoneticProperty,
        kABPersonMiddleNamePhoneticProperty,
        kABPersonOrganizationProperty,
        kABPersonJobTitleProperty,
        kABPersonDepartmentProperty,
        kABPersonEmailProperty,
        kABPersonBirthdayProperty,
        kABPersonNoteProperty,
        kABPersonAddressProperty,
        kABPersonInstantMessageProperty
//        kABPersonRelatedNamesProperty
    };
    memcpy(personPropertyArrayForMergingByNumber, personPropertyArrayForMergingByNumber1, personPropertyArrayForMergingByNumberArraySize*sizeof(int));
    
    
    
    
    
    int personPropertyArrayForMergingByEmail1[15] = {
        kABPersonFirstNameProperty,
        kABPersonLastNameProperty,
        kABPersonMiddleNameProperty,
        kABPersonNicknameProperty,
        kABPersonFirstNamePhoneticProperty,
        kABPersonLastNamePhoneticProperty,
        kABPersonMiddleNamePhoneticProperty,
        kABPersonOrganizationProperty,
        kABPersonJobTitleProperty,
        kABPersonDepartmentProperty,
        kABPersonBirthdayProperty,
        kABPersonNoteProperty,
        kABPersonAddressProperty,
        kABPersonPhoneProperty,
        kABPersonInstantMessageProperty
//        kABPersonRelatedNamesProperty
    };
    memcpy(personPropertyArrayForMergingByEmail, personPropertyArrayForMergingByEmail1, personPropertyArrayForMergingByEmailArraySize*sizeof(int));
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if(editing == YES)
    {
        // Your code for entering edit mode goes here
    } else {
        // Your code for exiting edit mode goes here
    }
}



#pragma mark - Table view data source

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

- (NSString *) getTitleForHeaderSection:(Person *)person
{
    NSMutableString *title = [NSMutableString stringWithString:@""];
    
    if ([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByName"]) // Check duplicate contacts by Name
    {
        title = [NSMutableString stringWithFormat:@"%@", person.fullName];
    }
    else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByNumber"]) // Check duplicate contacts by Number
    {
        title = [NSMutableString stringWithFormat:@"%@", person.mobile];
    }
    else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByEmail"]) // Check duplicate contacts by Email
    {
        title = [NSMutableString stringWithFormat:@"%@", person.homeEmail];
    }
    
    return [NSString stringWithString:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ContactMergingTableCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    // Configure the cell...
    Person *person;
    if (self.tableDataSections.count > 0)
    {
        person = [[self.tableDataSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        cell.nameLable.text = [NSString stringWithFormat:@"%@ %@",  person.firstName ? person.firstName: @"", person.lastName ? person.lastName: @""];
        
        if ( (person.mobile == nil) || [person.mobile isEqualToString:@" "] ) {
            cell.numberLable.text = person.home;
        } else {
            //             cell.numberLable.text = person.mobile;
            cell.numberLable.text = [self getCellLebelTextFor:person];
        }
    }
    else
    {
        person = [self.tableData objectAtIndex:indexPath.row];
        
        cell.nameLable.text = [NSString stringWithFormat:@"%@ %@",  person.firstName ? person.firstName: @"", person.lastName ? person.lastName: @""];
        
        if ( (person.mobile == nil) || [person.mobile isEqualToString:@" "] ) {
            cell.numberLable.text = person.home;
        } else {
            //             cell.numberLable.text = person.mobile;
            cell.numberLable.text = [self getCellLebelTextFor:person];
        }
    }
    
    //     cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    // selecting row to merge
    if (isSelectingRow)
    {
        //         if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
        //         {
        //             cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //         }
        //         else
        //         {
        //             cell.accessoryType = UITableViewCellAccessoryNone;
        //         }
        //
        //         for (int i = 0; i < defaultSelectedNSIndexPathForMergingArray.count; i++) {
        //             defaultSelectedNSIndexPathForMerging = defaultSelectedNSIndexPathForMergingArray[i];
        //
        //
        //         }
        
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
        
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    
    return cell;
}

- (NSString *) getCellLebelTextFor:(Person *)person
{
    NSMutableString *title = [NSMutableString stringWithString:@""];
    
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
        self.lastIndexPath = indexPath;
        
        NSIndexPath *changedIndex = defaultSelectedNSIndexPathForMergingArray[indexPath.section];
        changedIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] ;
        [defaultSelectedNSIndexPathForMergingArray replaceObjectAtIndex:indexPath.section withObject:changedIndex];
        
        [selectedContactToMergeWithArray replaceObjectAtIndex:indexPath.section withObject:[NSString stringWithFormat:@"%d", indexPath.row]];
        
        [tableView reloadData];
    } else {
        if (self.tableDataSections.count > 0) {
            person = [[self.tableDataSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        else {
            person = [self.tableData objectAtIndex:indexPath.row];
        }
        
        [self performSegueWithIdentifier:@"PerformMergeToContactDetailsSegue" sender: self];
    }
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PerformMergeToContactDetailsSegue"])
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


#pragma mark - Button Actions

- (IBAction)PerformCancel:(id)sender {
    //iOS6
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)PerformMerge:(id)sender {
    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [mergeBarButtonItem setEnabled:NO];
        [editBarButtonItem setEnabled:NO];
        [selectBarButtonItem setEnabled:NO];
        
        [self showActivityIndicator];
//    }];
    
//    [self doTheMergingTask];
    
    [self performSelector:@selector(doTheMergingTask) withObject:nil afterDelay:2.0];
}

- (IBAction)PerformEdit:(id)sender {
    if ([self.tableView isEditing]) {
        [self.tableView setEditing: NO animated: YES];
        [self.editBarButtonItem setTitle:@"Edit"];
        [self.selectBarButtonItem setEnabled:YES];
    } else {
        [self.tableView setEditing: YES animated: YES];
        [self.editBarButtonItem setTitle:@"Done"];
        [self.selectBarButtonItem setEnabled:NO];
    }
}

- (IBAction)PerformSelect:(id)sender {
    if (isSelectingRow) {
        isSelectingRow = NO;
        [self.selectBarButtonItem setTitle:@"Select"];
        [self.editBarButtonItem setEnabled:YES];
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    } else {
        isSelectingRow = YES;
        [self.selectBarButtonItem setTitle:@"Done"];
        [self.editBarButtonItem setEnabled:NO];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    [self.tableView reloadData];
}


#pragma mark - Class Member Methodes

/*
 - (void) checkContactsForDuplicates
 {
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
 
 NSArray *allPersonRecords = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
 NSMutableSet *linkedPersonsToSkip = [[NSMutableSet alloc] init];
 
 for (int i=0; i<[allPersonRecords count]; i++){
 
 ABRecordRef personRecordRef = (__bridge ABRecordRef)([allPersonRecords objectAtIndex:i]);
 
 // skip if contact has already been merged
 //
 if ([linkedPersonsToSkip containsObject:(__bridge id)(personRecordRef)]) {
 continue;
 }
 
 // Create object representing this person
 //
 Person *thisPerson = [[Person alloc] initWithPersonRef:(__bridge id)(personRecordRef)];
 
 // check if there are linked contacts & merge their contact information
 //
 NSArray *linked = (__bridge NSArray *) ABPersonCopyArrayOfAllLinkedPeople(personRecordRef);
 if ([linked count] > 1) {
 [linkedPersonsToSkip addObjectsFromArray:linked];
 
 // merge linked contact info
 for (int m = 0; m < [linked count]; m++) {
 ABRecordRef iLinkedPerson = (__bridge ABRecordRef)([linked objectAtIndex:m]);
 // don't merge the same contact
 if (iLinkedPerson == personRecordRef) {
 continue;
 }
 [thisPerson mergeInfoFromPersonRef:iLinkedPerson];
 }
 }
 [self.addressBookDictionary setObject:thisPerson forKey:thisPerson.recordID];
 }
 }
 */

- (void) refreshDataAndLoadTable
{
    
    isSelectingRow = NO;
    
    
    self.tableData = [NSMutableArray array];
    self.tableDataSections = [NSMutableArray array];
    defaultSelectedNSIndexPathForMergingArray = [NSMutableArray array];
    selectedContactToMergeWithArray = [NSMutableArray array];
    
    
    // Defines the merfing arrays
    [self declarePersonPropertyArray];
    
    
    
    if ([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByName"]) // Check duplicate contacts by Name
    {
        [self checkContactsForDuplicatesByName];
    }
    else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByNumber"]) // Check duplicate contacts by Number
    {
        [self checkContactsForDuplicatesByNumber];
    }
    else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByEmail"]) // Check duplicate contacts by Email
    {
        [self checkContactsForDuplicatesByEmail];
    }
    
    for (int i = 0; i < self.tableDataSections.count; i++) {
        defaultSelectedNSIndexPathForMerging = [NSIndexPath indexPathForRow:0 inSection:i];
        [defaultSelectedNSIndexPathForMergingArray addObject:defaultSelectedNSIndexPathForMerging];
    }
    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.editBarButtonItem.target = self;
    self.editBarButtonItem.action = @selector(PerformEdit:);
    
    self.selectBarButtonItem.target = self;
    self.selectBarButtonItem.action = @selector(PerformSelect:);
    
    //    Shows the table row animations
    //    ADLivelyTableView * livelyTableView = (ADLivelyTableView *)self.tableView;
    //    livelyTableView.initialCellTransformBlock = ADLivelyTransformFan;
    
    
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
    [mergeBarButtonItem setEnabled:YES];
    [editBarButtonItem setEnabled:YES];
    [selectBarButtonItem setEnabled:YES];
    
    
    [self removeActivityIndicator];
}


- (void) checkContactsForDuplicatesByName
{
/*
    for (int i = 0; i < [[AppManager getAppManagerInstance] tableData].count; i++) {
        Person *currentPerson = [[[AppManager getAppManagerInstance] tableData] objectAtIndex:i];
        
        for (int j = i + 1; j < [[AppManager getAppManagerInstance] tableData].count; j++) {
            Person *comparingPerson = [[[AppManager getAppManagerInstance] tableData] objectAtIndex:j];
            if ( ([currentPerson.fullName isEqualToString:comparingPerson.fullName]) && (![currentPerson.fullName  isEqualToString: @" "]) ) {
                if (![self.tableData containsObject:currentPerson]) {
                    [self.tableData addObject:currentPerson];
                }
                [self.tableData addObject:comparingPerson];
                
                if ([self.tableDataSections count] <= 0) // It means that the initial array is empty
                {
                    NSMutableArray *sectionHeaderrray;
                    if (![sectionHeaderrray containsObject:currentPerson]) {
                        sectionHeaderrray = [NSMutableArray array];
                        [self.tableDataSections addObject:sectionHeaderrray];
                        [sectionHeaderrray addObject:currentPerson];
                    }
                    [[self.tableDataSections lastObject] addObject:comparingPerson];
                    //                    continue;
                }
                else
                {
                    NSMutableArray *sectionArr = [self.tableDataSections lastObject];
                    NSMutableArray *sectionHeaderrray;
                    if (![sectionArr containsObject:currentPerson]) {
                        sectionHeaderrray = [NSMutableArray array];
                        [self.tableDataSections addObject:sectionHeaderrray];
                        [sectionHeaderrray addObject:currentPerson];
                    }
                    [[self.tableDataSections lastObject] addObject:comparingPerson];
                    //                    continue;
                    break;
                }
            }
        }
    }
    
    
    [self showAlertForNoDuplicates];
 */
    
    [self retriveAllContactsFullNameArray];
    
    
    for (int i = 0; i < fullNameDictionaryKeysArray.count; i++) {
        Person *currentPerson = fullNameDictionaryValuesArray[i];
        if (i == fullNameDictionaryKeysArray.count - 1) {
            break;
        }
        
        for (int j = i + 1; j < [[AppManager getAppManagerInstance] tableData].count; j++) {
            Person *comparingPerson = fullNameDictionaryValuesArray[j];
            
            if ( ([fullNameDictionaryKeysArray[i] isEqualToString:fullNameDictionaryKeysArray[j]]) ) {
                if (![self.tableData containsObject:currentPerson]) {
                    [self.tableData addObject:currentPerson];
                }
                [self.tableData addObject:comparingPerson];
                
                if ([self.tableDataSections count] <= 0) // It means that the initial array is empty
                {
                    NSMutableArray *sectionHeaderrray;
                    if (![sectionHeaderrray containsObject:currentPerson]) {
                        sectionHeaderrray = [NSMutableArray array];
                        [self.tableDataSections addObject:sectionHeaderrray];
                        [sectionHeaderrray addObject:currentPerson];
                    }
                    [[self.tableDataSections lastObject] addObject:comparingPerson];
                    //                    continue;
                }
                else
                {
                    NSMutableArray *sectionArr = [self.tableDataSections lastObject];
                    NSMutableArray *sectionHeaderrray;
                    if (![sectionArr containsObject:currentPerson]) {
                        sectionHeaderrray = [NSMutableArray array];
                        [self.tableDataSections addObject:sectionHeaderrray];
                        [sectionHeaderrray addObject:currentPerson];
                    }
                    [[self.tableDataSections lastObject] addObject:comparingPerson];
                    //                    continue;
                    break;
                }
            }
            
            if (j == fullNameDictionaryValuesArray.count - 1) {
                break;
            }
        }
    }
    
    
    [self showAlertForNoDuplicates];
    
}


- (void) retriveAllContactsFullNameArray
{
    fullNameDictionaryKeysArray = [NSMutableArray array];
    fullNameDictionaryValuesArray = [NSMutableArray array];
    
    
    
    NSMutableDictionary *allContactsPhoneNumber = [NSMutableDictionary dictionary];
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
    
    NSArray *arrayOfPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for(int i = 0; i < [arrayOfPeople count]; i++){
        
        ABRecordRef currentABRecordRef = (__bridge ABRecordRef)[arrayOfPeople objectAtIndex:i];
        Person *currentPerson = [[Person alloc] initWithPersonRef:(__bridge id)(currentABRecordRef)];
        
        
        
        
        
        /*
         NSArray *phones = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(ABRecordCopyValue(currentABRecordRef, kABPersonPhoneProperty));
         
         // Make sure that the selected contact has one phone at least filled in.
         if ([phones count] > 0) {
         for (int i = 0; i < phones.count; i++) {
         if ( (![[phones objectAtIndex:i] isEqualToString:@""]) && ([phones objectAtIndex:i] !=nil) ) {
         [allContactsPhoneNumber setValue:currentPerson forKey:[phones objectAtIndex:i]];
         }
         }
         
         }
         */
        
        
        /*
         ABMultiValueRef phones = ABRecordCopyValue(currentABRecordRef, kABPersonPhoneProperty);
         
         for (int i = 0; i < ABMultiValueGetCount(phones); i++) {
         NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
         if ( (![phone isEqualToString:@""]) && (phone !=nil) ) {
         [allContactsPhoneNumber setValue:currentPerson forKey:phone];
         }
         }
         */
        
        
        if ( (![currentPerson.fullName isEqualToString:@""]) && (currentPerson.fullName !=nil) ) {
            [fullNameDictionaryKeysArray addObject:currentPerson.fullName];
            [fullNameDictionaryValuesArray addObject:currentPerson];
        }
        
        
    }
    
}



- (void) checkContactsForDuplicatesByNumber
{
    
    [self retriveAllContactsPhoneNumberArray];
    
    
    for (int i = 0; i < phoneNumberDictionaryKeysArray.count; i++) {
        Person *currentPerson = phoneNumberDictionaryValuesArra[i];
        if (i == phoneNumberDictionaryKeysArray.count - 1) {
            break;
        }
        
        for (int j = i + 1; j < [[AppManager getAppManagerInstance] tableData].count; j++) {
            Person *comparingPerson = phoneNumberDictionaryValuesArra[j];
            
            if ( ([phoneNumberDictionaryKeysArray[i] isEqualToString:phoneNumberDictionaryKeysArray[j]]) ) {
                if (![self.tableData containsObject:currentPerson]) {
                    [self.tableData addObject:currentPerson];
                }
                [self.tableData addObject:comparingPerson];
                
                if ([self.tableDataSections count] <= 0) // It means that the initial array is empty
                {
                    NSMutableArray *sectionHeaderrray;
                    if (![sectionHeaderrray containsObject:currentPerson]) {
                        sectionHeaderrray = [NSMutableArray array];
                        [self.tableDataSections addObject:sectionHeaderrray];
                        [sectionHeaderrray addObject:currentPerson];
                    }
                    [[self.tableDataSections lastObject] addObject:comparingPerson];
                    //                    continue;
                }
                else
                {
                    NSMutableArray *sectionArr = [self.tableDataSections lastObject];
                    NSMutableArray *sectionHeaderrray;
                    if (![sectionArr containsObject:currentPerson]) {
                        sectionHeaderrray = [NSMutableArray array];
                        [self.tableDataSections addObject:sectionHeaderrray];
                        [sectionHeaderrray addObject:currentPerson];
                    }
                    [[self.tableDataSections lastObject] addObject:comparingPerson];
                    //                    continue;
                    break;
                }
            }
            
            if (j == phoneNumberDictionaryValuesArra.count - 1) {
                break;
            }
        }
    }
    
    
    [self showAlertForNoDuplicates];
}

- (void) retriveAllContactsPhoneNumberArray
{
    phoneNumberDictionaryKeysArray = [NSMutableArray array];
    phoneNumberDictionaryValuesArra = [NSMutableArray array];
    
    
    
    NSMutableDictionary *allContactsPhoneNumber = [NSMutableDictionary dictionary];
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
    
    NSArray *arrayOfPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for(int i = 0; i < [arrayOfPeople count]; i++){
        
        ABRecordRef currentABRecordRef = (__bridge ABRecordRef)[arrayOfPeople objectAtIndex:i];
        Person *currentPerson = [[Person alloc] initWithPersonRef:(__bridge id)(currentABRecordRef)];
        
        
        
        
        
        /*
         NSArray *phones = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(ABRecordCopyValue(currentABRecordRef, kABPersonPhoneProperty));
         
         // Make sure that the selected contact has one phone at least filled in.
         if ([phones count] > 0) {
         for (int i = 0; i < phones.count; i++) {
         if ( (![[phones objectAtIndex:i] isEqualToString:@""]) && ([phones objectAtIndex:i] !=nil) ) {
         [allContactsPhoneNumber setValue:currentPerson forKey:[phones objectAtIndex:i]];
         }
         }
         
         }
         */
        
        
        /*
         ABMultiValueRef phones = ABRecordCopyValue(currentABRecordRef, kABPersonPhoneProperty);
         
         for (int i = 0; i < ABMultiValueGetCount(phones); i++) {
         NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
         if ( (![phone isEqualToString:@""]) && (phone !=nil) ) {
         [allContactsPhoneNumber setValue:currentPerson forKey:phone];
         }
         }
         */
        
        
        if ( (![currentPerson.mobile isEqualToString:@""]) && (currentPerson.mobile !=nil) ) {
            [phoneNumberDictionaryKeysArray addObject:currentPerson.mobile];
            [phoneNumberDictionaryValuesArra addObject:currentPerson];
        }
        if ( (![currentPerson.home isEqualToString:@""]) && (currentPerson.home !=nil) ) {
            [phoneNumberDictionaryKeysArray addObject:currentPerson.home];
            [phoneNumberDictionaryValuesArra addObject:currentPerson];
        }
        
        
    }
    
}


- (void) checkContactsForDuplicatesByEmail
{
    [self retriveAllContactsEmailArray];

    
    for (int i = 0; i < emailDictionaryKeysArray.count; i++) {
        Person *currentPerson = emailDictionaryValuesArray[i];
        if (i == emailDictionaryKeysArray.count - 1) {
            break;
        }
        
        for (int j = i + 1; j < [[AppManager getAppManagerInstance] tableData].count; j++) {
            Person *comparingPerson = emailDictionaryValuesArray[j];
            
            if ( ([emailDictionaryKeysArray[i] isEqualToString:emailDictionaryKeysArray[j]]) ) {
                if (![self.tableData containsObject:currentPerson]) {
                    [self.tableData addObject:currentPerson];
                }
                [self.tableData addObject:comparingPerson];
                
                if ([self.tableDataSections count] <= 0) // It means that the initial array is empty
                {
                    NSMutableArray *sectionHeaderrray;
                    if (![sectionHeaderrray containsObject:currentPerson]) {
                        sectionHeaderrray = [NSMutableArray array];
                        [self.tableDataSections addObject:sectionHeaderrray];
                        [sectionHeaderrray addObject:currentPerson];
                    }
                    [[self.tableDataSections lastObject] addObject:comparingPerson];
                    //                    continue;
                }
                else
                {
                    NSMutableArray *sectionArr = [self.tableDataSections lastObject];
                    NSMutableArray *sectionHeaderrray;
                    if (![sectionArr containsObject:currentPerson]) {
                        sectionHeaderrray = [NSMutableArray array];
                        [self.tableDataSections addObject:sectionHeaderrray];
                        [sectionHeaderrray addObject:currentPerson];
                    }
                    [[self.tableDataSections lastObject] addObject:comparingPerson];
                    //                    continue;
                    break;
                }
            }
            
            if (j == emailDictionaryValuesArray.count - 1) {
                break;
            }
        }
    }
    
    
    [self showAlertForNoDuplicates];
}


- (void) retriveAllContactsEmailArray
{
    emailDictionaryKeysArray = [NSMutableArray array];
    emailDictionaryValuesArray = [NSMutableArray array];
    
    
    
    NSMutableDictionary *allContactsPhoneNumber = [NSMutableDictionary dictionary];
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
    
    NSArray *arrayOfPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for(int i = 0; i < [arrayOfPeople count]; i++){
        
        ABRecordRef currentABRecordRef = (__bridge ABRecordRef)[arrayOfPeople objectAtIndex:i];
        Person *currentPerson = [[Person alloc] initWithPersonRef:(__bridge id)(currentABRecordRef)];
        
        
        
        
        
        /*
         NSArray *phones = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(ABRecordCopyValue(currentABRecordRef, kABPersonPhoneProperty));
         
         // Make sure that the selected contact has one phone at least filled in.
         if ([phones count] > 0) {
         for (int i = 0; i < phones.count; i++) {
         if ( (![[phones objectAtIndex:i] isEqualToString:@""]) && ([phones objectAtIndex:i] !=nil) ) {
         [allContactsPhoneNumber setValue:currentPerson forKey:[phones objectAtIndex:i]];
         }
         }
         
         }
         */
        
        
        /*
         ABMultiValueRef phones = ABRecordCopyValue(currentABRecordRef, kABPersonPhoneProperty);
         
         for (int i = 0; i < ABMultiValueGetCount(phones); i++) {
         NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
         if ( (![phone isEqualToString:@""]) && (phone !=nil) ) {
         [allContactsPhoneNumber setValue:currentPerson forKey:phone];
         }
         }
         */
        
        
        if ( (![currentPerson.homeEmail isEqualToString:@""]) && (currentPerson.homeEmail !=nil) ) {
            [emailDictionaryKeysArray addObject:currentPerson.homeEmail];
            [emailDictionaryValuesArray addObject:currentPerson];
        }
        if ( (![currentPerson.workEmail isEqualToString:@""]) && (currentPerson.workEmail !=nil) ) {
            [emailDictionaryKeysArray addObject:currentPerson.workEmail];
            [emailDictionaryValuesArray addObject:currentPerson];
        }
        
        
    }
}





- (void) showAlertForNoDuplicates
{
    if (self.tableDataSections.count <= 0) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [mergeBarButtonItem setEnabled:NO];
            [editBarButtonItem setEnabled:NO];
            [selectBarButtonItem setEnabled:NO];
            [mergingInstructionsLable setText:@"You have no duplicate contacts."];
        }];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations !" message:@"You have no duplicate contacts." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [mergeBarButtonItem setEnabled:YES];
            [editBarButtonItem setEnabled:YES];
            [selectBarButtonItem setEnabled:YES];
            mergingInstructionsLable.text = [NSString stringWithFormat:@"%@\r%@",@"Click 'Edit' > select contacts to merge.",@"Click 'Select' > select default contact."];
            //            [mergingInstructionsLable setText:@"Click 'Edit' > select contacts to merge. Click 'Select' > select default contact"];
            //            [mergingInstructionsLable setAdjustsFontSizeToFitWidth:NO];
            //            [mergingInstructionsLable setNumberOfLines:0];
            //            [mergingInstructionsLable setLineBreakMode:NSLineBreakByWordWrapping];
        }];
        for (int i = 0; i < self.tableDataSections.count; i++) {
            [selectedContactToMergeWithArray insertObject:@"0" atIndex:i];
        }
    }
}




- (void) doTheMergingTask
{
    NSLog(@"Starting to merge...");
    

    
    
    
    
    int personPropertyArray[50];
    int personPropertyArraySize = 0;
    
    
    if ([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByName"]) // Check duplicate contacts by Name
    {
        personPropertyArraySize = personPropertyArrayForMergingByNameArraySize;
        memcpy(personPropertyArray, personPropertyArrayForMergingByName, personPropertyArraySize*sizeof(int));
    }
    else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByNumber"]) // Check duplicate contacts by Number
    {
        personPropertyArraySize = personPropertyArrayForMergingByNumberArraySize;
        memcpy(personPropertyArray, personPropertyArrayForMergingByNumber, personPropertyArraySize*sizeof(int));
    }
    else if([[[AppManager getAppManagerInstance] mergingType] isEqualToString:@"ByEmail"]) // Check duplicate contacts by Email
    {
        personPropertyArraySize = personPropertyArrayForMergingByEmailArraySize;
        memcpy(personPropertyArray, personPropertyArrayForMergingByEmail, personPropertyArraySize*sizeof(int));
    }
    
    
    
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
    
    
    
    // Perform operation fro each section. Here "i" indicated each section
    for (int i = 0; i < tableDataSections.count; i++) {
        NSMutableArray *sectionArray = [tableDataSections objectAtIndex:i];
        
        NSMutableDictionary *totalUniqueValueToAddDict = [NSMutableDictionary dictionary];
        NSMutableArray *totalUniqueValueToAddCorrospondindPropertyID = [NSMutableArray array];
        NSMutableArray *totalUniqueValueToAdd;
        totalUniqueValueToAdd = [NSMutableArray array];
        NSInteger indexInteger = i;
        NSNumber *indexNumber = [NSNumber numberWithInteger: indexInteger];
        NSUInteger sectionIndex = [indexNumber integerValue];
        
        NSNumber *selectedPersonIndex = [selectedContactToMergeWithArray objectAtIndex:sectionIndex];
        
        Person *selectedPerson = [sectionArray objectAtIndex:[selectedPersonIndex integerValue]];
        
        // Perform operation for each object j a section i.
        for (int j = 0; j < sectionArray.count; j++) {
            
            NSInteger idxInteger = j;
            NSNumber *idxNumber = [NSNumber numberWithInteger: idxInteger];
            NSUInteger personIdx = [idxNumber integerValue];
            
            if (personIdx == [selectedPersonIndex integerValue]) {
                //                continue;
                NSLog(@"Don't do anything... %d", i);
            } else {
                Person *comparingPerson = [sectionArray objectAtIndex:personIdx];
                
                
                for (int k = 0; k < personPropertyArraySize; k++) {
                    
                    if ( ![ABContact propertyIsMultivalue:personPropertyArray[k]] ) {
                        NSLog(@"Property isn't multivalue. So selected value will remain....");
                        id comparingPersonValue = [ABContact objectForProperty:personPropertyArray[k] inRecord:comparingPerson.personRecordRef];
                        id selectedPersonValue = [ABContact objectForProperty:personPropertyArray[k] inRecord:selectedPerson.personRecordRef];
                        
                        if ( (selectedPersonValue == nil) && (comparingPersonValue != nil) ) {
//                            if (![comparingPersonValue isEqual:selectedPersonValue]) {
                                // add comparingPersonValue to selectedPerson
//                                NSString *label = [NSString stringWithFormat:@"%@", [ABContact propertyString:personPropertyArray[k]]];
                                //                            const char  cStringLabel = [label cStringUsingEncoding:NSASCIIStringEncoding];
                                //                            const char *cStringLabel = [ label UTF8String ];
                                
                                //                            const CFStringRef customLabel = CFSTR( cStringLabel );
//                                const CFStringRef customLabel = (__bridge CFStringRef)label;
                                
//                                NSString *comparingPersonValueString = [NSString stringWithFormat:@"%@", comparingPersonValue];
                                const CFTypeRef comparingPersonValueCFString = (__bridge CFTypeRef)comparingPersonValue;
                                
                                CFErrorRef  anError = NULL;
                                ABRecordSetValue(selectedPerson.personRecordRef, personPropertyArray[k], comparingPersonValueCFString, &anError);
                                
                                if (anError != NULL) {
                                    
                                    NSLog(@"error while creating..");
                                }
//                            }
                        }
                        /*
                        if (![comparingPersonValue isEqual:selectedPersonValue]) {
                            // add comparingPersonValue to selectedPerson
                            NSString *label = [NSString stringWithFormat:@"%@ 02", [ABContact propertyString:personPropertyArray[k]]];
                            //                            const char  cStringLabel = [label cStringUsingEncoding:NSASCIIStringEncoding];
                            //                            const char *cStringLabel = [ label UTF8String ];
                            
                            //                            const CFStringRef customLabel = CFSTR( cStringLabel );
                            const CFStringRef customLabel = (__bridge CFStringRef)label;
                            
                            
                            CFErrorRef  anError = NULL;
                            ABRecordSetValue(selectedPerson.personRecordRef, personPropertyArray[k], customLabel, &anError);
                            
                            if (anError != NULL) {
                                
                                NSLog(@"error while creating..");
                            }
                        }
                        */
                    }
                    else {
                        // Property has multivalue.
                        
                        if ([totalUniqueValueToAddDict valueForKey:[ABContact propertyString:personPropertyArray[k]]] == nil) {
//                            totalUniqueValueToAdd = [NSMutableArray array];
                            [totalUniqueValueToAddDict setObject:totalUniqueValueToAdd forKey:[ABContact propertyString:personPropertyArray[k]]];
                            [totalUniqueValueToAddCorrospondindPropertyID addObject:[NSNumber numberWithInt:personPropertyArray[k]]];
                        }
                        
                        NSArray *selectedPersonValueArray = [ABContact arrayForProperty:personPropertyArray[k] inRecord:selectedPerson.personRecordRef];
                        NSArray *comparingPersonValueArray = [ABContact arrayForProperty:personPropertyArray[k] inRecord:comparingPerson.personRecordRef];
                        
                        
                        
                        for (int m = 0; m < selectedPersonValueArray.count; m++) {
                            id selectedPersonValue = selectedPersonValueArray[m];
                            
                            if (![totalUniqueValueToAdd containsObject:selectedPersonValue]) {
                                [totalUniqueValueToAdd addObject:selectedPersonValue];
                            }
                        }
                        
                        
                        for (int n = 0; n < comparingPersonValueArray.count; n++) {
                            id comparingPersonValue = comparingPersonValueArray[n];
            
                            if (![totalUniqueValueToAdd containsObject:comparingPersonValue]) {
                                [totalUniqueValueToAdd addObject:comparingPersonValue];
                            }

                        }
                        
                        
                        
                        
                        /*
                        ABMutableMultiValueRef multiValue = NULL;
                        for (int p = 0; p < totalUniqueValueToAdd.count; p++) {
                            
                            id valueToAdd = totalUniqueValueToAdd[p];
                            NSString *label = [NSString stringWithFormat:@"%@ %d", [ABContact propertyString:personPropertyArray[k]], p];
                            const CFStringRef customLabel = (__bridge CFStringRef)label;
                            
                            multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                            ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(valueToAdd), customLabel, NULL);
                            
                        }
                        CFErrorRef  anError = NULL;
                        ABRecordSetValue(selectedPerson.personRecordRef, personPropertyArray[k], multiValue,&anError);
                        */
                        
                        
                    }
                    
                    
                }
                
                
                // remove comparingPerson from address book but not from tableDataSections.
                ABAddressBookRemoveRecord(addressBook, comparingPerson.personRecordRef, &error);
                
                bool isSaved = ABAddressBookSave (addressBook, &error );
                if(isSaved){
                    NSLog(@"ABAddressBook Saved..");
                }
                if (error != NULL) {
                    NSLog(@"ABAddressBookSave %@", error);
                }
                
            }
        }
        
        
        
        
        CFRelease(addressBook);
//        CFErrorRef error = NULL;
//        ABAddressBookRef addressBook;
        if ([self isABAddressBookCreateWithOptionsAvailable])
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        }
        else
        {
            // iOS 4/5
            addressBook = ABAddressBookCreate();
        }
        ABRecordRef selectedPersonToAddABRecordRef = ABAddressBookGetPersonWithRecordID(addressBook, selectedPerson.personRecordID);
//        Person *selectedPersonToAdd = [[Person alloc] initWithPersonRef:(__bridge id)(selectedPersonToAddABRecordRef)];
//        NSLog(@"Name: %@", selectedPersonToAdd.fullName);
        
        
        
        for (int w = 0; w < totalUniqueValueToAddDict.count; w++) {
            NSString *propertyName = [NSString stringWithFormat:@"%@", [[totalUniqueValueToAddDict allKeys] objectAtIndex:w]];
            NSArray *valuesToAdd = [[totalUniqueValueToAddDict allValues] objectAtIndex:w];
            ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            for (int x = 0; x < valuesToAdd.count; x++) {
//                id valueToAdd = valuesToAdd[x];
                id valueToAdd = [NSString stringWithFormat:@"%@",valuesToAdd[x]];
                NSString *propertyNameLabel = [NSString stringWithFormat:@"%@ %d", propertyName, x+ 1];
                const CFStringRef custompropertyNameLabel = (__bridge CFStringRef)propertyNameLabel;
                
//                multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                NSLog(@"valueToAdd: %@", valueToAdd);
                NSLog(@"custompropertyNameLabel: %@", custompropertyNameLabel);
                ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(valueToAdd), custompropertyNameLabel, NULL);
            }
            CFErrorRef  anError = NULL;
//            ABRecordSetValue(selectedPerson.personRecordRef, [ABContact propertyNameFromString:propertyName], multiValue,&anError);
//            ABRecordSetValue(selectedPersonToAddABRecordRef, [ABContact propertyNameFromString:propertyName], multiValue,&anError);
//            ABPropertyID propertyID = [ABContact propertyNameFromString:propertyName];
//            ABPropertyID propertyID = [[totalUniqueValueToAddCorrospondindPropertyID objectAtIndex:w] intValue];
//            ABRecordSetValue(selectedPersonToAddABRecordRef, kABPersonPhoneProperty, multiValue,&anError);
            
            
            
            
            
            
            
            
            
            
            
            if ([propertyName isEqualToString:@"Phone"]) {
                ABRecordSetValue(selectedPersonToAddABRecordRef, kABPersonEmailProperty, multiValue,&anError);
            }
//            else if ([propertyName isEqualToString:@"Instant Message"]) {
//                ABRecordSetValue(selectedPersonToAddABRecordRef, kABPersonInstantMessageProperty, multiValue,&anError);
//            }
//            else if ([propertyName isEqualToString:@"Address"]) {
//                ABRecordSetValue(selectedPersonToAddABRecordRef, kABPersonAddressProperty, multiValue,&anError);
//            }
//            else if ([propertyName isEqualToString:@"Email"]) {
//                ABRecordSetValue(selectedPersonToAddABRecordRef, kABPersonPhoneProperty, multiValue,&anError);
//            }
//            else if ([propertyName isEqualToString:@"Related Name"]) {
//                ABRecordSetValue(selectedPersonToAddABRecordRef, kABPersonRelatedNamesProperty, multiValue,&anError);
//            }
            
            
            
            
            
            
            
            
            
            
//            CFRelease(multiValue);
//            BOOL isSaved = ABAddressBookSave (addressBook, &error );
//            if(isSaved){
//                NSLog(@"ABAddressBook Saved..");
//            }
//            if (error != NULL) {
//                NSLog(@"ABAddressBookSave %@", error);
//            }
        }
        
        
        bool isSaved = ABAddressBookSave (addressBook, &error );
        if(isSaved){
            NSLog(@"ABAddressBook Saved..");
        }
        if (error != NULL) {
            NSLog(@"ABAddressBookSave %@", error);
        }
        
        CFRelease(addressBook);
        
        
        totalUniqueValueToAddDict = nil;
    }
    
    
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self performSelector:@selector(refreshDataAndLoadTable) withObject:nil afterDelay:1.0];
    }];
}


-(BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
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


@end
