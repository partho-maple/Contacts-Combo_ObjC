//
//  PBAppDelegate.h
//  Contacts Cop
//
//  Created by Partho on 7/10/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppManager.h"

#import <DropboxSDK/DropboxSDK.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GSDropboxDestinationSelectionViewController.h"
#import "GSDropboxUploader.h"

#import "Harpy.h"

#import "LTHPasscodeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Core Data Stack
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void) saveContext;
- (NSURL *) applicationDocumentsDirectory;

- (void) SetupDropBoxForBackupAndSyncing;

- (void) checkVersionAndShowAlert;
- (void) customizeAppearance;

@end
