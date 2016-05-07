//
//  ContactsViewController.m
//  Platinum Dialer
//
//  Created by Partho Biswas on 7/22/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//


#import "ContactsViewController.h"
#import "Person.h"
#import <AddressBook/AddressBook.h>
//#import "ContactDetailViewController.h"
#import "ADLivelyTableView.h"
#import "DetailViewController.h"



@interface ContactsViewController ()
{
}

@property (nonatomic, strong) RHRefreshControl *refreshControl;
@property (nonatomic, assign, getter = isLoading) BOOL loading;

@end

@implementation ContactsViewController

@synthesize tableData, tableDataAfterSearcing, tableDataSections, refreshControl;
bool    inSearchMode = NO;


Person *person;
DetailViewController *contactViewController;
NSIndexPath *recentTableIndexPath;
NSSortDescriptor *sortNameAlphabetically;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization

    }
    return self;
}


// 2nd
- (void)viewDidLoad
{
    [super viewDidLoad];

    //  Creates the custome UI
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
    
    [self customizeAppearance];
}


- (void) viewWillAppear:(BOOL)animated  {

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

    
}


-(BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
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








































- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:animated];
}

#pragma mark - Table view delegate


- (IBAction)refresh
{
    [self.tableView reloadData];
}

- (IBAction)ShowMainMenu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}


- (void) prepareContactsViewControlle
{
    if (self.tableData == nil) {
        self.tableData = [[NSMutableArray alloc] init];
        self.tableDataAfterSearcing = [[NSMutableArray alloc] init];
        [self getPersonOutOfAddressBook];
        
        
        
        
        
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
        ADLivelyTableView * livelyTableView = (ADLivelyTableView *)self.tableView;
        livelyTableView.initialCellTransformBlock = ADLivelyTransformFan;
    }
}


-(void)customizeAppearance
{
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    
    [self createGradientBackgroundColor];

//    self.navigationController.navigationBar.translucent = NO;
    
    
    
    
    UIColor *lightOp = backgroundColorGradientTop02;
    UIColor *darkOp = backgroundColorGradientBottom;
    
    // Create the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)lightOp.CGColor,
                       (id)darkOp.CGColor,
                       nil];
    
    // Set bounds
    gradient.frame = self.view.bounds;
    
    UIImage *gradientImage = [self imageFromLayer:gradient];
    
    CGSize size = CGSizeMake(gradientImage.size.width, gradientImage.size.height);
    UIGraphicsBeginImageContext(size);
    [gradientImage drawInRect:CGRectMake(0,0,size.width, size.height)];

    self.searchDisplayController.searchBar.backgroundImage = gradientImage;
    
    
    
//    [[UITableViewHeaderFooterView appearance] setBackgroundImage:gradientImage];
    [[UITableViewHeaderFooterView appearance] setTintColor:backgroundColorGradientTop02];
    
    
    
    
    
    
    
    
    
    
    
    
    /******Create and load custom refresh control******/
    CutomRefreshView *customRefreshView = [[CutomRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    RHRefreshControlConfiguration *refreshConfiguration = [[RHRefreshControlConfiguration alloc] init];
    refreshConfiguration.refreshView = RHRefreshViewStylePinterest;
    //  refreshConfiguration.minimumForStart = @0;
    //  refreshConfiguration.maximumForPull = @120;
    self.refreshControl = [[RHRefreshControl alloc] initWithConfiguration:refreshConfiguration];
    self.refreshControl.delegate = self;
    [self.refreshControl attachToScrollView:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void) createGradientBackgroundColor
{
    UIColor *lightOp = backgroundColorGradientTop;
    UIColor *darkOp = backgroundColorGradientBottom;
    
    
    // Create the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)lightOp.CGColor,
                       (id)darkOp.CGColor,
                       nil];
    
    // Set bounds
    gradient.frame = self.view.bounds;
    
    
    UIImage *gradientImage = [self imageFromLayer:gradient];
    UIImage *worldBGImage = [UIImage imageNamed:@"NoImage"];
    
    
    CGSize size = CGSizeMake(gradientImage.size.width, gradientImage.size.height);
    UIGraphicsBeginImageContext(size);
    [gradientImage drawInRect:CGRectMake(0,0,size.width, size.height)];
    [worldBGImage drawInRect:CGRectMake(0,25,size.width, 220)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:finalImage];
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}



- (IBAction)addContact:(id)sender
{
    ABNewPersonViewController *newPersonVC = [[ABNewPersonViewController alloc] init];
    newPersonVC.newPersonViewDelegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:newPersonVC];
    
//    nc.navigationBar.alpha = 0.0f;
//    nc.navigationBar.translucent = YES;
    newPersonVC.navigationController.navigationBar.translucent = NO;
//    nc.navigationBar.backgroundColor = [UIColor clearColor];
//    CGRect frame = CGRectMake(0, 0, 480, 50);
//    UIView *v = [[UIView alloc] initWithFrame:frame];
//    UIImage *i = [UIImage imageNamed:@"TabBar_BG_Color.png"];
//    UIColor *c = [[UIColor alloc] initWithPatternImage:i];
//    v.backgroundColor = c;
//
//    newPersonVC.view.backgroundColor = [UIColor redColor];
//    [newPersonVC.view setb];
    
    [self presentViewController:nc animated:YES completion:NULL];
    
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
    {
        if (self.tableDataSections.count > 0) {
            return self.tableDataSections.count;
        }
        else
            return 1;
        
//        NSLog(@"self.tableDataSections.count: %lu", (unsigned long)self.tableDataSections.count);
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        rowCount = [self.tableDataAfterSearcing count];
        return rowCount;
    }
    else
    {
        if (self.tableDataSections.count > 0) {
            rowCount =  [[self.tableDataSections objectAtIndex:section] count];
        }
        else
        {
            rowCount = [self.tableData count];
        }
        
        return rowCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"contactsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        Person *person = [self.tableDataAfterSearcing objectAtIndex:indexPath.row];
        
        //   cell.textLabel.text = person.fullName;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",  person.firstName ? person.firstName: @"", person.lastName ? person.lastName: @""];
        
        cell.imageView.image = person.image;
        cell.imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        cell.imageView.layer.cornerRadius=20;
        cell.imageView.layer.borderWidth=1.0;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.borderColor=[[UIColor blackColor] CGColor];
    }
    else
    {
        Person *person;
        if (self.tableDataSections.count > 0)
        {
            person = [[self.tableDataSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            //            cell.textLabel.text = person.fullName;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",  person.firstName ? person.firstName: @"", person.lastName ? person.lastName: @""];
            cell.imageView.image = person.image;
            cell.imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
            cell.imageView.layer.cornerRadius=20;
            cell.imageView.layer.borderWidth=1.0;
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.borderColor=[[UIColor blackColor] CGColor];
        }
        else
        {
            person = [self.tableData objectAtIndex:indexPath.row];
            
            //            cell.textLabel.text = person.fullName;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",  person.firstName ? person.firstName: @"", person.lastName ? person.lastName: @""];
            cell.imageView.image = person.image;
            cell.imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
            cell.imageView.layer.cornerRadius=20;
            cell.imageView.layer.borderWidth=1.0;
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.borderColor=[[UIColor blackColor] CGColor];
        }
        
    }
    
    
    //    cell.imageView.bounds = CGRectInset(cell.imageView.frame, 20.0f, 20.0f);
    //    cell.imageView. = UIEdgeInsetsMake(10, 10, 10, 10);
    //    cell.imageView.frame = CGRectMake(5, 0, 40.0f, 10.0f);
    
    return cell;
}


/*
//customize uitablevoewcell with uiimage  and add uitableviewcell seperator
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Contacts_Cell_BG.png"]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        if ([self.searchDisplayController isActive])
        {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            person = [self.tableDataAfterSearcing objectAtIndex:indexPath.row];
        }
        else
        {
            indexPath = [self.tableView indexPathForSelectedRow];
            person = [self.tableData objectAtIndex:indexPath.row];
         }

    }
    else if (tableView == self.tableView)
    {
        if (self.tableDataSections.count > 0)
        {
            person = [[self.tableDataSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        else
        {
            person = [self.tableData objectAtIndex:indexPath.row];
            
        }
    }
    
    
    
    
//    We are going to detailsViewControler from here, creating the view mannually from storyboard using storyboard ID
//    contactViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"ContactsDetailsViewControllerSBID"];
//    contactViewController.person = person;
    
    
    contactViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"DetailsViewControllerSBID"];
    
//    NSMutableDictionary *contactDetailsDictionary = [[NSMutableDictionary alloc] initWithObjects:@[person.firstName, person.lastName, person.mobile, person.home, person.homeEmail, person.workEmail, person.address, person.zipCode, person.city] forKeys:@[@"firstName", @"lastName", @"mobileNumber", @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city"]];
//    contactViewController.dictContactDetails = contactDetailsDictionary;
    
//    [[self navigationController] pushViewController:contactViewController animated:YES];

    
//    If we call this segue from storyboard then prepareForSegue method will be called.
    [self performSegueWithIdentifier:@"contactToContactDetailsSegue" sender: self]; 
}


#pragma mark - Segue methodes

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"contactToContactDetailsSegue"])
    {
//        contactViewController = (ContactDetailViewController *) [segue destinationViewController];
//        contactViewController.person = person;
        
//        NSDictionary *contactDetailsDictionary = [_arrContactsData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
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


- (void)getPersonOutOfAddressBook
{
    CFErrorRef error = NULL;
    
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
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

    
    if (addressBook != nil)
    {
//        NSLog(@"Succesful.");
        
        NSArray *allContacts = (__bridge_transfer NSArray
                                *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        
        
        CFArraySortValues(
                          (__bridge CFMutableArrayRef)(allContacts),
                          CFRangeMake(0, CFArrayGetCount((__bridge CFArrayRef)(allContacts))),
                          (CFComparatorFunction) ABPersonComparePeopleByName,
                          (void*) ABPersonGetSortOrdering()
                          );
        
        
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++)
        {
            Person *person = [[Person alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            if (firstName == nil) {
                firstName = @"";
            }
            
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            if (lastName == nil) {
                lastName = @"";
            }
            
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            person.personRecordRef = contactPerson;
            person.firstName = firstName;
            person.lastName = lastName;
            person.fullName = fullName;
            
            
            
            
            //mobile
            
            ABMultiValueRef phones = ABRecordCopyValue(contactPerson,
                                                       kABPersonPhoneProperty);
            NSUInteger i = 0;
            for (i = 0; i < ABMultiValueGetCount(phones); i++)
            {
                NSString *phone = (__bridge_transfer NSString
                                   *)ABMultiValueCopyValueAtIndex(phones, i);
                if (i == 0)
                {
                    person.mobile = phone;
                    //   NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                }
                else if (i==1)
                    person.home = phone;
            }
            
            
            
            //photo
            
            
            NSData  *imgData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatThumbnail);
            
            UIImage  *img = [UIImage imageWithData:imgData];
            
            
            if (img != nil){
                person.image = img;
                
            }else {
                
                // if there is no image from address book, we give our own image
                person.image = [UIImage imageNamed:@"Contact.png"];
                
            }
            
            
            
            
            // Get the first street address among all addresses of the selected contact.
            ABMultiValueRef addressRef = ABRecordCopyValue(contactPerson, kABPersonAddressProperty);
            if (ABMultiValueGetCount(addressRef) > 0) {
                NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
                
                person.address = [addressDict objectForKey:(NSString *)kABPersonAddressStreetKey];
                person.zipCode = [addressDict objectForKey:(NSString *)kABPersonAddressZIPKey];
                person.city = [addressDict objectForKey:(NSString *)kABPersonAddressCityKey];
            }
            
            
            
            //email
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson,
                                                       kABPersonEmailProperty);
            NSUInteger j = 0;
            for (j = 0; j < ABMultiValueGetCount(emails); j++)
            {
                NSString *email = (__bridge_transfer NSString
                                   *)ABMultiValueCopyValueAtIndex(emails, j);
                if (j == 0)
                {
                    person.homeEmail = email;
                    //   NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                }
                else if (j==1)
                    person.workEmail = email;
            }
            
            
            
            
            
            
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

            [self.tableData addObject:person];
        }     
    }
    
//    NSLog(@"self.tableData = %@",self.tableData);
    
    for(int i = 0; i < self.tableData.count - 1; i++) {
        
        person = self.tableData[i];
        
        NSString *phone = person.mobile;
        phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        
        if ([phone isEqualToString:@"990001"]) {
//            NSLog(@"We got the name: %@", person.fullName);
//            NSLog(@"number: %@", number);
//            NSLog(@"phone: %@", phone);
        }
        
        /*
         if ([phone rangeOfString:number].location == NSNotFound) {
         NSLog(@"string does not contain bla");
         } else {
         NSLog(@"We got the name: %@", name);
         }
         
         if ([self Contains:number on:phone]) {
         NSLog(@"We got the name: %@", name);
         NSLog(@"number: %@", number);
         NSLog(@"phone: %@", phone);
         }
         */
    }

    
    
    CFRelease(addressBook);
}




#pragma mark - TableView ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refreshControl refreshScrollViewDidScroll:scrollView];
    
    
    
    UISearchBar *searchBar = self.tableView.tableHeaderView.subviews.lastObject;
    CGRect searchBarFrame = searchBar.frame;
    
    /*
     * In your UISearchBarDelegate implementation, set a boolean flag when
     * searchBarTextDidBeginEditing (true) and searchBarTextDidEndEditing (false)
     * are called.
     */
    
    if (inSearchMode)
    {
        searchBarFrame.origin.y = scrollView.contentOffset.y;
    }
    else
    {
        searchBarFrame.origin.y = MIN(0, scrollView.contentOffset.y);
    }
    
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    searchBar.frame = searchBarFrame;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.refreshControl refreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark - RHRefreshControl Delegate
- (void)refreshDidTriggerRefresh:(RHRefreshControl *)refreshControl {
    self.loading = YES;
    
    [self performSelector:@selector(LoadComplete) withObject:nil afterDelay:2.0];
}

- (BOOL)refreshDataSourceIsLoading:(RHRefreshControl *)refreshControl {
    return self.isLoading; // should return if data source model is reloading
    
}

- (void) LoadComplete {
    self.loading = NO;
    [self.refreshControl refreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    [self refresh];
}




#pragma mark - UISearchBarDelegate Methods

/*
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //move the search bar up to the correct location eg
    [UIView animateWithDuration:.4
                     animations:^{
                         searchBar.frame = CGRectMake(searchBar.frame.origin.x,
                                                      100,
                                                      searchBar.frame.size.width,
                                                      searchBar.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         //whatever else you may need to do
                     }];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    //move the search bar down to the correct location eg
    [UIView animateWithDuration:.4
                     animations:^{
                         searchBar.frame = CGRectMake(searchBar.frame.origin.x,
                                                      searchBar.frame.origin.y,//SearchBar original Y
                                                      searchBar.frame.size.width,
                                                      searchBar.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         //whatever else you may need to do
                     }];
    return YES;
}
*/
/*
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}
*/
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.firstName contains[cd] %@",
                                    searchText];
    
    tableDataAfterSearcing = [NSMutableArray arrayWithArray:[tableData filteredArrayUsingPredicate:resultPredicate]];
    

}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    inSearchMode = YES;
//    [self.searchDisplayController.searchBar setShowsCancelButton: YES animated:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    inSearchMode = NO;
}

- (void) dealloc
{
//    free((__bridge void *)(self));
}



@end
