//
//  MyBackup.h
//  Contacts Cop
//
//  Created by Partho on 8/23/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"
#import "AppManager.h"


@interface MyBackup : NSManagedObject

@property (nonatomic, retain) NSString * backupType; // Cloud OR Local
@property (nonatomic, retain) NSString * backupCriteria; // Full OR Partial
@property (nonatomic, retain) NSString * backupSize;
@property (nonatomic, retain) NSNumber * backedUpContactsCount;
@property (nonatomic, retain) NSString * backupTime;
@property (nonatomic, retain) NSString * backupDate;
@property (nonatomic, retain) NSString * backupFileURL;
@property (nonatomic, retain) NSString * vCardStringFull;
@property (nonatomic, retain) NSString * backupFileName;//
@end
