//
//  ContactOpsUtils.m
//  Contacts Cop
//
//  Created by Partho on 8/17/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "ContactOpsUtils.h"



@interface ContactOpsUtils ()

+ (BOOL)isABAddressBookCreateWithOptionsAvailable;

@end

@implementation ContactOpsUtils


+ (BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
}


+ (NSMutableArray *)getContactsWithMissingPhoneOutOfAddressBook
{
    NSMutableArray *contactsWithMissingPhoneArray = [NSMutableArray array];
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
            person.personRecordID = ABRecordGetRecordID(contactPerson);
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
            
            
            if (ABMultiValueGetCount(phones) <= 0) {
                [contactsWithMissingPhoneArray addObject:person];
            }
         }
    }
    
    
    
    
    CFRelease(addressBook);
    return contactsWithMissingPhoneArray;
}


+ (NSMutableArray *)getContactsWithMissingNameOutOfAddressBook
{
    NSMutableArray *contactsWithMissingNameArray = [NSMutableArray array];
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
            person.personRecordID = ABRecordGetRecordID(contactPerson);
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
            
            fullName = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
            person.fullName = fullName;
            
            
            if ( (person.fullName == nil) || ([person.fullName isEqualToString:@" "]) ) {
                [contactsWithMissingNameArray addObject:person];
            }
        }
    }
    
    
    
    
    CFRelease(addressBook);
    return contactsWithMissingNameArray;
}


+ (NSMutableArray *)getEmptyContactsOutOfAddressBook
{
    NSMutableArray *emptyContactsArray = [NSMutableArray array];
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
            person.personRecordID = ABRecordGetRecordID(contactPerson);
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
            
            fullName = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
            person.fullName = fullName;
            
            
            if ( ((person.fullName == nil) || ([person.fullName isEqualToString:@" "])) && ([person.mobile isEqualToString:@""]) && ([person.home isEqualToString:@""]) && ([person.homeEmail isEqualToString:@""]) && ([person.workEmail isEqualToString:@""]) && ([person.address isEqualToString:@""]) && ([person.zipCode isEqualToString:@""]) && ([person.city isEqualToString:@""]) ) {
                [emptyContactsArray addObject:person];
            }
        }
    }
    
    
    
    
    CFRelease(addressBook);
    return emptyContactsArray;
}


+ (NSMutableArray *) getAllContactsOutOfAddressBook
{
    NSMutableArray *allContactsArray = [NSMutableArray array];
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
            person.personRecordID = ABRecordGetRecordID(contactPerson);
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
            
            [allContactsArray addObject:person];
        }
    }
    
    //    NSLog(@"self.tableData = %@",self.tableData);
    
    for(int i = 0; i < allContactsArray.count - 1; i++) {
        
        Person *person = allContactsArray[i];
        
        NSString *phone = person.mobile;
        phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
    }
    
    
    
    CFRelease(addressBook);
    return allContactsArray;
}




@end
