//
//  MergeViewController.h
//  Contacts Cop
//
//  Created by Partho on 7/15/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "CommonDefs.h"
#import "REFrostedViewController.h"

@interface MergeViewController : UIViewController

- (IBAction)ShowMainMenu:(id)sender;

- (IBAction)MergeByName:(id)sender;
- (IBAction)MergeByNumber:(id)sender;
- (IBAction)MergeByEmail:(id)sender;

@end
