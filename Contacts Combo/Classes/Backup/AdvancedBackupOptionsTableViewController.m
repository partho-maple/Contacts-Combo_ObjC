//
//  AdvancedBackupOptionsTableViewController.m
//  Contacts Cop
//
//  Created by Partho on 8/18/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "AdvancedBackupOptionsTableViewController.h"

#define SECTION_BACKUP_TYPE   0
#define SECTION_BACKUP_FIELDS  1

#define  SECTION_BACKUP_TYPE_ROW_CSV  0
#define SECTION_BACKUP_TYPE_ROW_vCARD  1

#define PHOTO_SWITCH_TAG   10
#define ORG_SWITCH_TAG   20
#define BIRTHDAY_SWITCH_TAG   30
#define NOTES_SWITCH_TAG   40
#define PHONE_SWITCH_TAG   50
#define EMAIL_SWITCH_TAG   60
#define URL_SWITCH_TAG   70
#define ADDRESS_SWITCH_TAG   80
#define DATE_SWITCH_TAG   90
#define IM_SWITCH_TAG   100
#define RELATIONS_SWITCH_TAG   110



@interface AdvancedBackupOptionsTableViewController ()

@end

@implementation AdvancedBackupOptionsTableViewController

NSUInteger selectedBackupTypeRowIndex;
NSMutableDictionary *selectesBackupOptions;

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AppManager getAppManagerInstance] setAdvanceBackupSelectedType:[NSMutableString stringWithFormat:@"vCard"]];
    selectedBackupTypeRowIndex = 1;
    
    selectesBackupOptions = [NSMutableDictionary dictionary];
    [selectesBackupOptions setObject:@"YES" forKey:@"Photo"];
    [selectesBackupOptions setObject:@"YES" forKey:@"Organization"];
    [selectesBackupOptions setObject:@"YES" forKey:@"Birthday"];
    [selectesBackupOptions setObject:@"YES" forKey:@"Notes"];
    [selectesBackupOptions setObject:@"YES" forKey:@"Phone"];
    [selectesBackupOptions setObject:@"YES" forKey:@"Email"];
    [selectesBackupOptions setObject:@"YES" forKey:@"URL"];
    [selectesBackupOptions setObject:@"YES" forKey:@"Address"];
    [selectesBackupOptions setObject:@"YES" forKey:@"Date"];
    [selectesBackupOptions setObject:@"YES" forKey:@"IM"];
    [selectesBackupOptions setObject:@"YES" forKey:@"Relations"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark === UITableViewDataSource ===

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section)
    {
        case SECTION_BACKUP_TYPE:
            if (row == selectedBackupTypeRowIndex)
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section)
    {
        case SECTION_BACKUP_TYPE:
            if (row == SECTION_BACKUP_TYPE_ROW_CSV) {
                [[AppManager getAppManagerInstance] setAdvanceBackupSelectedType:[NSMutableString stringWithFormat:@"CSV"]];
                selectedBackupTypeRowIndex = 0;
            }
            else if (row == SECTION_BACKUP_TYPE_ROW_vCARD)
            {
                [[AppManager getAppManagerInstance] setAdvanceBackupSelectedType:[NSMutableString stringWithFormat:@"vCard"]];
                selectedBackupTypeRowIndex = 1;
            }
            
            [self.tableView reloadData];
            break;
    }
}


#pragma mark === Navigation === 

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BackupOptionsToPerformBackupSegue"]) {
        [[AppManager getAppManagerInstance] setAdvanceBackupSelectedOptionsDictionary:selectesBackupOptions];
    }
}

- (IBAction)switchToggled:(UISwitch *)sender {
    switch (sender.tag)
    {
        case PHOTO_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"Photo"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"Photo"];
            }
            break;
            
        case ORG_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"Organization"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"Organization"];
            }
            break;
            
        case BIRTHDAY_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"Birthday"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"Birthday"];
            }
            break;
            
        case NOTES_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"Notes"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"Notes"];
            }
            break;
            
        case PHONE_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"Phone"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"Phone"];
            }
            break;
            
        case EMAIL_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"Email"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"Email"];
            }
            break;
            
        case URL_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"URL"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"URL"];
            }
            break;
            
        case ADDRESS_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"Address"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"Address"];
            }
            break;
            
        case DATE_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"Date"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"Date"];
            }
            break;
            
        case IM_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"IM"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"IM"];
            }
            break;
            
        case RELATIONS_SWITCH_TAG:
            if (sender.isOn) {
                [selectesBackupOptions setObject:@"YES" forKey:@"Relations"];
            } else {
                [selectesBackupOptions setObject:@"NO" forKey:@"Relations"];
            }
            break;
            
    }
}

- (IBAction)PerformNext:(id)sender { //BackupOptionsToPerformBackupSegue
    [self performSegueWithIdentifier:@"BackupOptionsToPerformBackupSegue" sender: self];
}
@end
