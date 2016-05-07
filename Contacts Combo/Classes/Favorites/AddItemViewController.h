//
//  AddItemViewController.h
//  Quick Dial
//
//  Created by Kalai Chelvan on 5/7/13.
//  Copyright (c) 2013 Kalai Chelvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


///delegate and methods. delegate confirms that added values will be presented to main view controller. additemviewcontrollerdidcanel method gets called when user choose to cancel without adding new contact. didfinishaddingitem and didFinifhEditingitem gets called when user taps on the done button

@class AddItemViewController;
@class QuicklistItem;
@protocol AddItemViewControllerDelegate <NSObject>
- (void)addItemViewControllerDidCancel:(AddItemViewController *)controller;
- (void)addItemViewController:(AddItemViewController *)controller didFinishAddingItem:(QuicklistItem *)item;
- (void)addItemViewController:(AddItemViewController *)controller didFinishEditingItem:(QuicklistItem *)item;
@end


///declare delegation of uitextfield and addressbooknavigationcontroller

@interface AddItemViewController : UITableViewController <UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate>

///declare IBOutlets for namefield, mobilefield,imagefield, done button 

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextField *notesField;
@property (strong, nonatomic) IBOutlet UIImageView *imageField;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic, weak) id <AddItemViewControllerDelegate> delegate;
@property (nonatomic, strong) QuicklistItem *itemToEdit;

///create two IBAction methods (cancel and done)

- (IBAction)cancel;
- (IBAction)done;

///user may choose to import contact from addressbook. create an IBAction to connect to UIButton

- (IBAction)fromAddressBook;


@end