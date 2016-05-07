//
//  SyncViewController.h
//  Contacts Cop
//
//  Created by Partho on 7/29/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "CommonDefs.h"
#import "REFrostedViewController.h"

@interface SyncViewController : UIViewController


- (IBAction)ShowMainMenu:(id)sender;

- (IBAction)SyncGoogle:(id)sender;
- (IBAction)SyncYahoo:(id)sender;
- (IBAction)SyncLinkedIn:(id)sender;
- (IBAction)SyncFacebook:(id)sender;
- (IBAction)SyncOutlook:(id)sender;


@end
