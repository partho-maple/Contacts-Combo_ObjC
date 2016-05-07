//
//  Person.h
//  Platinum Dialer
//
//  Created by Partho Biswas on 7/22/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "GlobalConstants.h"

@interface Person : NSObject

// Custome initilasation method
- (id) initWithPersonRef:personRecordRef;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *homeEmail;
@property (nonatomic, strong) NSString *workEmail;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *home;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) ABRecordRef personRecordRef;
@property (nonatomic) ABRecordID personRecordID;

@end
