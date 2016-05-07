//
//  AppManager.h
//  Contacts Cop
//
//  Created by Partho on 7/10/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <DropboxSDK/DropboxSDK.h>

#import "CommonDefs.h"
#import "Person.h"


@interface AppManager : NSObject


// For Testing Purpose
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *tableDataSections;

@property(nonatomic, copy, readwrite) NSMutableString *mergingType;
//@property(nonatomic, readwrite) MergingType PerformMerge;

@property(nonatomic, copy, readwrite) NSMutableString *syncingType;
@property(nonatomic, copy, readwrite) NSMutableString *cleanupType;

//@property(nonatomic, readwrite) int m_iBalancePort;
@property(nonatomic, readwrite) bool isAdvancedBackup;
@property(nonatomic, readwrite) bool isCloudBackup;
@property(nonatomic, copy, readwrite) NSMutableString *advanceBackupSelectedType;
@property(nonatomic, copy, readwrite) NSMutableDictionary *advanceBackupSelectedOptionsDictionary;
@property(nonatomic, copy, readwrite) NSMutableArray *selectedContactsForAdvancedBackupArray;
@property(nonatomic, copy, readwrite) NSMutableArray *selectedContactsForFastBackupArray;

@property(nonatomic, copy, readwrite) NSMutableArray *totalLocalBackupArray;
@property(nonatomic, copy, readwrite) NSMutableArray *totalCloudBackupArray;


// For DropBox backup Export option
@property(nonatomic, copy, readwrite) DBSession *dbSession;
@property(nonatomic, copy, readwrite) UINavigationController *dropboxNavigationController;
//@property(nonatomic, copy, readwrite) DBAccount *dropboxAccount;


// this class is a singleton class.
+ (AppManager *) getAppManagerInstance;


- (BOOL) isABAddressBookCreateWithOptionsAvailable;
- (BOOL) iOSVersion6ToUpper;

@end
