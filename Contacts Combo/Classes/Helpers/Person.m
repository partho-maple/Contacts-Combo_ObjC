//
//  Person.m
//  Platinum Dialer
//
//  Created by Partho Biswas on 7/22/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id) initWithPersonRef:personRecordRef
{
    self = [super init];
    if (self) {
        
        ABRecordRef contactPerson = (__bridge ABRecordRef)(personRecordRef);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
        NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        _personRecordRef = contactPerson;
        _personRecordID =  ABRecordGetRecordID((__bridge ABRecordRef)(personRecordRef));
        _firstName = firstName;
        _lastName = lastName;
        _fullName = fullName;
        
        
        
        
        //mobile
        
        ABMultiValueRef phones = ABRecordCopyValue(contactPerson,
                                                   kABPersonPhoneProperty);
        NSUInteger i = 0;
        for (i = 0; i < ABMultiValueGetCount(phones); i++)
        {
            NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            if (i == 0)
            {
                _mobile = phone;
                //   NSLog(@"person.homeEmail = %@ ", person.homeEmail);
            }
            else if (i==1)
                _home = phone;
        }
        
        
        
        //photo
        
        
        NSData  *imgData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatThumbnail);
        
        UIImage  *img = [UIImage imageWithData:imgData];
        
        
        if (img != nil){
            _image = img;
            
        }else {
            
            // if there is no image from address book, we give our own image
            _image = [UIImage imageNamed:@"Contact.png"];
            
        }
        
        
        
        
        // Get the first street address among all addresses of the selected contact.
        ABMultiValueRef addressRef = ABRecordCopyValue(contactPerson, kABPersonAddressProperty);
        if (ABMultiValueGetCount(addressRef) > 0) {
            NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
            
            //                [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressStreetKey] forKey:@"address"];
            //                [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressZIPKey] forKey:@"zipCode"];
            //                [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressCityKey] forKey:@"city"];
            
            _address = [addressDict objectForKey:(NSString *)kABPersonAddressStreetKey];
            _zipCode = [addressDict objectForKey:(NSString *)kABPersonAddressZIPKey];
            _city = [addressDict objectForKey:(NSString *)kABPersonAddressCityKey];
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
                _homeEmail = email;
                //   NSLog(@"person.homeEmail = %@ ", person.homeEmail);
            }
            else if (j==1)
                _workEmail = email;
        }
        
    }
    return self;
}



- (void) dealloc
{
    _firstName = @"";
   _lastName = @"";
    _fullName = @"";
    _homeEmail = @"";
    _workEmail = @"";
    _mobile = @"";
    _home = @"";
    _image = nil;
    _address = @"";
    _zipCode = @"";
    _city = @"";
}


@end
