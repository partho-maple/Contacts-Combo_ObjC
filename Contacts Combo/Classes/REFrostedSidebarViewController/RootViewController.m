//
//  RootViewController.m
//  Contacts Cop
//
//  Created by Partho on 9/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuTableViewController"];
}

@end