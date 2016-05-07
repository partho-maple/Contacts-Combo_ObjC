//
//  AppManager.m
//  Contacts Cop
//
//  Created by Partho on 7/10/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

@synthesize mergingType, syncingType, cleanupType, advanceBackupSelectedType, advanceBackupSelectedOptionsDictionary, selectedContactsForAdvancedBackupArray, isAdvancedBackup, selectedContactsForFastBackupArray, isCloudBackup, totalCloudBackupArray, totalLocalBackupArray, dbSession, dropboxNavigationController;


+ (AppManager *) getAppManagerInstance
{
    static AppManager *appManager = nil;
    if (appManager == nil) {
        appManager = [[super allocWithZone:NULL] init];
    }
    return appManager;
}

// singleton methods
+ (id)allocWithZone:(NSZone *)zone {
    return [self getAppManagerInstance];
}

- (id)init {
    self = [super init];
    if (self) {
//        Custome Initialisation
        mergingType = [NSMutableString stringWithString:@"None"];
        syncingType = [NSMutableString stringWithString:@"None"];
        cleanupType = [NSMutableString stringWithString:@"None"];
        isAdvancedBackup = NO;
        isCloudBackup = NO;
        advanceBackupSelectedType = [NSMutableString stringWithString:@"None"];
        advanceBackupSelectedOptionsDictionary = [NSMutableDictionary dictionary];
        selectedContactsForAdvancedBackupArray = [NSMutableArray array];
        selectedContactsForFastBackupArray = [NSMutableArray array];
        
        totalLocalBackupArray = [NSMutableArray array];
        totalCloudBackupArray = [NSMutableArray array];
        
        // Setting up Dropbox
        dbSession = [[DBSession alloc] initWithAppKey:DROPBOX_APP_KEY
                                            appSecret:DROPBOX_APP_SECRET
                                                 root:kDBRootDropbox];
        [DBSession setSharedSession:dbSession];
        
    }
    return self;
}


-(BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
}


- (BOOL)iOSVersion6ToUpper {
    //    NSLog(@"System Version is %@", \
    [[UIDevice currentDevice] systemVersion]);
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 6.0) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
