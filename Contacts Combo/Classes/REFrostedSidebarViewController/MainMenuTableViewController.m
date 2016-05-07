//
//  MainMenuTableViewController.m
//  Contacts Cop
//
//  Created by Partho on 9/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "MainMenuTableViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface MainMenuTableViewController ()

@end

@implementation MainMenuTableViewController

@synthesize appTitle,profilePicture, profileName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    /*
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 210.0f)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 0, 30)];
        titleLabel.text = @"Contacts Combo";
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [titleLabel sizeToFit];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 0, 24)];
        label.text = @"Partho Biswas";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:titleLabel];
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    */
    
    profilePicture.image = [UIImage imageNamed:@"avatar.jpg"];
    profileName.text = [NSString stringWithFormat:@"Partho Biswas"];
    
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainNavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        ContactsViewController *contactsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactsViewControllerSBID"];
        navigationController.viewControllers = @[contactsViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        MainViewController *favViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        navigationController.viewControllers = @[favViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        SyncViewController *syncViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SyncViewController"];
        navigationController.viewControllers = @[syncViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        MergeViewController *mergeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MergeViewController"];
        navigationController.viewControllers = @[mergeViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 4) {
        BackupViewController *backupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BackupViewController"];
        navigationController.viewControllers = @[backupViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        CleanupViewController *cleanupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CleanupViewController"];
        navigationController.viewControllers = @[cleanupViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 6) {
        SettingsTableViewController *settingsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsTableViewController"];
        navigationController.viewControllers = @[settingsTableViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 7) {
        MoreTableViewController *moreTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreTableViewController"];
        navigationController.viewControllers = @[moreTableViewController];
    }
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Contacts", @"Favourite", @"Sync", @"Merge", @"Backup", @"Cleanup", @"Settings", @"More"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

@end
