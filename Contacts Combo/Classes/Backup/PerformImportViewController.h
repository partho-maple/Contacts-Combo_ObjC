//
//  PerformImportViewController.h
//  Contacts Combo
//
//  Created by Partho on 9/20/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "GlobalConstants.h"
#import "CommonDefs.h"


@interface PerformImportViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIProgressView *importContactsProgressBar;


- (IBAction)PergormCancel:(id)sender;
- (IBAction)PerformImport:(id)sender;

@end
