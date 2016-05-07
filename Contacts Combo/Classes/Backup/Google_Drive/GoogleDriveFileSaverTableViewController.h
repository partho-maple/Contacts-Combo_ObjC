//
//  GoogleDriveFileSaverTableViewController.h
//  Contacts Cop
//
//  Created by Partho on 9/13/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTLDrive.h"
#import "GTMOAuth2ViewControllerTouch.h"

#import "GogleDriveLocalUtilities.h"

@interface GoogleDriveFileSaverTableViewController : UITableViewController

@property(nonatomic, copy, readwrite) GTLDriveFile *selectedGTLDriveFileForTheUpload;
@property(nonatomic, copy, readwrite) NSMutableArray *subDirectoriesArray;

@end
