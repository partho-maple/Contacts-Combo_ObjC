//
//  ContactOpsUtils.h
//  Contacts Cop
//
//  Created by Partho on 8/17/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "AppManager.h"
#import "ContactSyncingTableViewCell.h"
#import "Person.h"
#import "ABContact.h"

@interface ContactOpsUtils : NSObject

+ (NSMutableArray *) getContactsWithMissingPhoneOutOfAddressBook;
+ (NSMutableArray *) getContactsWithMissingNameOutOfAddressBook;
+ (NSMutableArray *) getEmptyContactsOutOfAddressBook;
+ (NSMutableArray *) getAllContactsOutOfAddressBook;

@end
