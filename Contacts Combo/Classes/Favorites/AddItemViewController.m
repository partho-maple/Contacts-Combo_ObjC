//
//  AddItemViewController.m
//  Quick Dial
//
//  Created by Kalai Chelvan on 5/7/13.
//  Copyright (c) 2013 Kalai Chelvan. All rights reserved.
//

#import "AddItemViewController.h"
#import "QuicklistItem.h"
#import <QuartzCore/QuartzCore.h>


@interface AddItemViewController () {
   

}

@end

@implementation AddItemViewController

/// synthesize all the created properties

@synthesize textField, notesField, imageField, doneBarButton;
@synthesize delegate;
@synthesize itemToEdit;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    ///set the tableviewbackground with our own uiimage
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"background.png"]];

  ///we check when the view loading finished, whether it is from additem segue or edititem segue. if it is editidem segue, then we set the name, mobile and image appropriately
    
    if (self.itemToEdit != nil) {
        self.title = NSLocalizedString(@"Edit Item", nil);
        self.textField.text = self.itemToEdit.name;
        self.notesField.text = self.itemToEdit.mobile;
        self.imageField.image = self.itemToEdit.image;
        self.doneBarButton.enabled = YES;
        
        ///remember to render the photoimage to circular shape
        
        imageField.layer.cornerRadius = 28.0;
        imageField.layer.masksToBounds = YES;
        imageField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        imageField.layer.borderWidth = 1.0;

    }
    else {
        
        /// if the view is presented by additem segue, we set title to "add item" and call the keyboard so that the user can input immediately
        
        self.title = NSLocalizedString(@"Add Item", nil);
        self.doneBarButton.enabled = YES;
        [self.textField becomeFirstResponder];

     
    }

}




-(void)viewWillAppear
{

}

///dismiss the presenting view when user tap on the cancel button

- (IBAction)cancel
{
    [self.delegate addItemViewControllerDidCancel:self];
}


///delegates all the information entered/imported to main viewcontroller and dismiss the view controller

- (IBAction)done
{
    if (self.itemToEdit == nil) {
        
        ///checks whether textfield at least has a text
        
        if (textField.text.length > 0 & textField.text.length > 0) {
        QuicklistItem *item = [[QuicklistItem alloc] init];
        item.name = self.textField.text;
        item.mobile = self.notesField.text;
        item.image = self.imageField.image;
        [self.delegate addItemViewController:self didFinishAddingItem:item];
        } else {
            
        }
    } else {
        self.itemToEdit.name = self.textField.text;
        self.itemToEdit.mobile = self.notesField.text;
        self.itemToEdit.image = self.imageField.image;
        [self.delegate addItemViewController:self didFinishEditingItem:self.itemToEdit];
    }
}


///this method prevents the uitableviewcell turns to blue when user tap on it

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


///when user scrolls the view, optionally we can hide keyboard

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
    [self.notesField resignFirstResponder];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


///we dispose all the resources to save memory and improve performance

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setNotesField:nil];
    [self setImageField:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

///this method confirms and turns the donebarbutton enabled only when there are text entered in name text field. otherwise, it keeps the done bar button disabled

- (BOOL)notesField:(UITextField *)theNotesField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theNotesField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
    return YES;
}



///if the user choose to import contact from addressbook, following method invoked, when user taps on the uibutton that hooked on this method

- (IBAction)fromAddressBook
{
    
    ///presents the uiaddressbook which enbedded in navigation controller
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;

    [self presentViewController:picker animated: YES completion:NO];

}


///dismiss presenting addressbook view controller if the user choose to cancel

- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated: YES completion:NO];
}


///when the user taps on the uibutton to import contact from addressbook, the first vieew shown is name list. but user might particularly wants pick a mobile number. therefore we let the user to continue enter in the address book user's information when user select a particualr contact

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    

    
    return YES;
}


///when the user pick a mobile no, we check whether are there more than one mobile no, then we check its index and then we pick the correct number and delegate to additem view controller. we set the name of the contact, mobile number and photo of the contact to appropriate fields. and then we dismiss the view controller that is currently presented


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    
    if (property == kABPersonPhoneProperty) { // if tapped is equal to a phone property
        CFStringRef cfnumber;
        ABMultiValueRef numbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(CFIndex i = 0; i < ABMultiValueGetCount(numbers); i++) {
            if(identifier == ABMultiValueGetIdentifierAtIndex (numbers, i)) { //if tapped number identifier is the same as identifier number tapped
                cfnumber = ABMultiValueCopyValueAtIndex(numbers, i); // copy the number to CFSTRING number
            }
        }
        NSString *number = [NSString stringWithFormat:@"%@",cfnumber];
        CFRelease(cfnumber);
        //do anything you want with the number
        
        self.notesField.text = number ;

    }
    
    [self displayPerson:person]; /// this the method used in intermediate state
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    return NO;
    
    
}

/// following method confirms the first name and second name of the selected contact and combines as one.

- (void)displayPerson:(ABRecordRef)person
{

NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);

    self.textField.text = [NSString stringWithFormat:@"%@ %@",  firstName ? firstName: @"", lastName ? lastName: @""];

    
    
    NSData  *imgData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
    
    UIImage  *img = [UIImage imageWithData:imgData];
    
    if (img != nil){
    self.imageField.image = img;

    }else {
       
        /// if there is no image from address book, we give our own image
        self.imageField.image = [UIImage imageNamed:@"PersonalChat.png"];

    }
    
///remmeber to render the uiimage to circular shape
    
    imageField.layer.cornerRadius = 28.0; ///radius has to half of the uiimageview width
    imageField.layer.masksToBounds = YES;
    imageField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageField.layer.borderWidth = 1.0;

}


///following method confirms which no has choosen when more than one mobile no available

-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    if (property == kABPersonPhoneProperty)
    {
        ABMultiValueRef numbers = ABRecordCopyValue(person, property);
        NSString* targetNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(numbers, ABMultiValueGetIndexForIdentifier(numbers, identifierForValue));
        
        NSLog(@"%@", targetNumber);
        

        
    }
    return YES;
}


@end
