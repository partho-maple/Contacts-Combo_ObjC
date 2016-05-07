//
//  MainViewController.h
//  Quick Dial
//
//  Created by Kalai Chelvan on 5/7/13.
//  Copyright (c) 2013 Kalai Chelvan. All rights reserved.

//

#import <UIKit/UIKit.h>
#import "AddItemViewController.h"
#import "REFrostedViewController.h"


//confirm additemviewcontrollerdelegate

@interface MainViewController : UITableViewController <AddItemViewControllerDelegate>
{

}

//declare uisegmentedcontrol
@property (strong, nonatomic) IBOutlet UISegmentedControl *Segment;

- (IBAction)ShowMainMenu:(id)sender;


@end
