//
//  MyBackupsTableViewController.m
//  Contacts Cop
//
//  Created by Partho on 8/21/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "MyBackupsTableViewController.h"

#define SECTION_CLOUD   0
#define SECTION_LOCAL  1

@interface MyBackupsTableViewController ()

@property (nonatomic, strong) NSMutableArray *cloudBackupsInfoArray;
@property (nonatomic, strong) NSMutableArray *localBackupsInfoArray;

@end

@implementation MyBackupsTableViewController

@synthesize cloudStorageDeviceNameLable, cloudBackupCountLable, lastCloudBackupTimeLable, lastLocalBackupTimeLable, localBackupCountLable, cloudBackupsInfoArray, localBackupsInfoArray;
@synthesize cloudBackupFetchedResultsController = _cloudBackupFetchedResultsController;
@synthesize localBackupFetchedResultsController = _localBackupFetchedResultsController;

AppDelegate *myAppDelegate;
ShowBackupsTableViewController *showBackupsTableViewController;

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
    
    //    These lines fetches the Call logs from the database.
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = myAppDelegate.managedObjectContext;

}

- (void) viewWillAppear:(BOOL)animated
{
    NSError *error = nil;
    if (![[self cloudBackupFetchedResultsController] performFetch:&error]) {
        NSLog(@"Error! %@",error);
        abort();
    }
    
    if (![[self localBackupFetchedResultsController] performFetch:&error]) {
        NSLog(@"Error! %@",error);
        abort();
    }


    cloudBackupsInfoArray = [NSMutableArray arrayWithArray:[[self cloudBackupFetchedResultsController] fetchedObjects]];
    localBackupsInfoArray = [NSMutableArray arrayWithArray:[[self localBackupFetchedResultsController] fetchedObjects]];
    
    [cloudBackupCountLable setText:[NSString stringWithFormat:@"%lu", (unsigned long)cloudBackupsInfoArray.count]];
    [localBackupCountLable setText:[NSString stringWithFormat:@"%lu", (unsigned long)localBackupsInfoArray.count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MyBackupsToShowBackupsSegue"]) {
//        showBackupsTableViewController = (ShowBackupsTableViewController *) [segue destinationViewController];
//        
//        if ([[AppManager getAppManagerInstance] isCloudBackup]) {
//            showBackupsTableViewController.tableData = cloudBackupsInfoArray;
//        } else {
//            showBackupsTableViewController.tableData = localBackupsInfoArray;
//        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section)
    {
        case SECTION_CLOUD:
            [[AppManager getAppManagerInstance] setIsCloudBackup:YES];
            break;
        case SECTION_LOCAL:
            [[AppManager getAppManagerInstance] setIsCloudBackup:NO];
            break;
    }
    [self performSegueWithIdentifier:@"MyBackupsToShowBackupsSegue" sender: self];
}




#pragma mark Fetched Results Controller section

-(NSFetchedResultsController *) cloudBackupFetchedResultsController {
    if (_cloudBackupFetchedResultsController != nil) {
        return _cloudBackupFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyBackup" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"backupType == 'Cloud'"];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"backupDate" ascending:NO];
    NSSortDescriptor *sortDescriptor02 = [[NSSortDescriptor alloc] initWithKey:@"backupTime" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, sortDescriptor02, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
//    _cloudBackupFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"backupDate" cacheName:nil];
    _cloudBackupFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _cloudBackupFetchedResultsController.delegate = self;
    
    return _cloudBackupFetchedResultsController;
}


-(NSFetchedResultsController *) localBackupFetchedResultsController {
    if (_localBackupFetchedResultsController != nil) {
        return _localBackupFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyBackup" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"backupType == 'Local'"];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"backupDate" ascending:NO];
    NSSortDescriptor *sortDescriptor02 = [[NSSortDescriptor alloc] initWithKey:@"backupTime" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, sortDescriptor02, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
//    _localBackupFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"backupDate" cacheName:nil];
    _localBackupFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _localBackupFetchedResultsController.delegate = self;
    
    return _localBackupFetchedResultsController;
}


- (IBAction)PerformCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
