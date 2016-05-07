//
//  ShowBackupsTableViewController.m
//  Contacts Cop
//
//  Created by Partho on 8/21/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "ShowBackupsTableViewController.h"

@interface ShowBackupsTableViewController ()

@end

@implementation ShowBackupsTableViewController

@synthesize tableData;
//@synthesize cloudBackupsInfoArray, localBackupsInfoArray;
@synthesize cloudBackupFetchedResultsController = _cloudBackupFetchedResultsController;
@synthesize localBackupFetchedResultsController = _localBackupFetchedResultsController;

AppDelegate *myAppDelegate;
MyBackup *selectedBackupEntry;

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
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    These lines fetches the Call logs from the database.
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = myAppDelegate.managedObjectContext;
    
    if ([[AppManager getAppManagerInstance] isCloudBackup]) {
        [self setTitle:@"Cloud Backups"];
    } else {
        [self setTitle:@"Local Backups"];
    }
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

    
    if ([[AppManager getAppManagerInstance] isCloudBackup]) {
        tableData = [NSMutableArray arrayWithArray:[[self cloudBackupFetchedResultsController] fetchedObjects]];
    } else {
        tableData = [NSMutableArray arrayWithArray:[[self localBackupFetchedResultsController] fetchedObjects]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - TableView Delegate and DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount;
    NSError *error = nil;
    
    if ([[AppManager getAppManagerInstance] isCloudBackup]) {
        
        //        id <NSFetchedResultsSectionInfo> sectionInfo = [self.cloudBackupFetchedResultsController sections][section];
        //        return [sectionInfo numberOfObjects];
        if (![[self cloudBackupFetchedResultsController] performFetch:&error]) {
            NSLog(@"Error! %@",error);
            abort();
        }
        
        
        rowCount = [[self cloudBackupFetchedResultsController] fetchedObjects].count;
        //        cloudBackupsInfoArray = [NSMutableArray arrayWithArray:[[self cloudBackupFetchedResultsController] fetchedObjects]];
        //        localBackupsInfoArray = [NSMutableArray arrayWithArray:[[self localBackupFetchedResultsController] fetchedObjects]];
        
    } else {
        
        //        id <NSFetchedResultsSectionInfo> sectionInfo = [self.localBackupFetchedResultsController sections][section];
        //        return [sectionInfo numberOfObjects];
        if (![[self localBackupFetchedResultsController] performFetch:&error]) {
            NSLog(@"Error! %@",error);
            abort();
        }
        
        
        rowCount = [[self localBackupFetchedResultsController] fetchedObjects].count;
    }
    
    
//    rowCount = tableData.count;
    return rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BackupsTableViewCell";
    
    BackupsTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    // Configure the cell...
    
    if ([[AppManager getAppManagerInstance] isCloudBackup]) {
        tableData = [NSMutableArray arrayWithArray:[[self cloudBackupFetchedResultsController] fetchedObjects]];
    } else {
        tableData = [NSMutableArray arrayWithArray:[[self localBackupFetchedResultsController] fetchedObjects]];
    }
    
//    cloudBackupsInfoArray = [NSMutableArray arrayWithArray:[[self cloudBackupFetchedResultsController] fetchedObjects]];
//    localBackupsInfoArray = [NSMutableArray arrayWithArray:[[self localBackupFetchedResultsController] fetchedObjects]];

    
    MyBackup *myBackup = [tableData objectAtIndex:indexPath.row];
    cell.backupTypeLable.text = myBackup.backupCriteria;
    cell.backupContactsCountLable.text = [NSString stringWithFormat:@"%d", [myBackup.backedUpContactsCount intValue]];
    cell.backupInfoLable.text = [NSString stringWithFormat:@"%@, %@, %@", myBackup.backupSize, myBackup.backupTime, myBackup.backupDate];
    
    return cell;
}


#pragma mark - UITableViewDelegate

//customize uitablevoewcell with uiimage  and add uitableviewcell seperator

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //  cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"Contacts_Cell_BG.png"]];
    //cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSIndexPath *index = indexPath;
     NSInteger row = index.row;
     NSInteger section = index.section;
     
     [tableView beginUpdates];
     
     if (editingStyle == UITableViewCellEditingStyleDelete) {
     // Delete the row from the data source
     
     
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     
     
     }
     
     [tableView endUpdates];
     */
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        //        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        //        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSManagedObjectContext *context;
        if ([[AppManager getAppManagerInstance] isCloudBackup]) {
            [self setTitle:@"Cloud Backups"];
            context = [self.cloudBackupFetchedResultsController managedObjectContext];
            [context deleteObject:[self.cloudBackupFetchedResultsController objectAtIndexPath:indexPath]];
        } else {
            [self setTitle:@"Local Backups"];
            context = [self.localBackupFetchedResultsController managedObjectContext];
            [context deleteObject:[self.localBackupFetchedResultsController objectAtIndexPath:indexPath]];
        }
        
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedBackupEntry = [tableData objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"BackupsToBackupOperationsSegue" sender: self];
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BackupsToBackupOperationsSegue"])
    {
        BackupOperationsViewController *backupOperationsViewController = (BackupOperationsViewController *) [segue destinationViewController];
        
        backupOperationsViewController.selectedBackupEntry = selectedBackupEntry;

    }
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
    
    
    _localBackupFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _localBackupFetchedResultsController.delegate = self;
    
    return _localBackupFetchedResultsController;
}



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}




@end
