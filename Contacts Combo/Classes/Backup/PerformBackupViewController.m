//
//  PerformBackupViewController.m
//  Contacts Cop
//
//  Created by Partho on 8/19/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "PerformBackupViewController.h"

@interface PerformBackupViewController ()

@end

@implementation PerformBackupViewController

@synthesize progressView, processedContactsLable, totalContactsLable, performBackupBarButton;
int totalContactsCount;

AppDelegate *myAppDelegate;
MyBackup *newBackup;
NSMutableArray *personForBackupArray;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.hidesBackButton = YES;
    
    
    
    
    if ([[AppManager getAppManagerInstance] isAdvancedBackup]) {
        totalContactsCount = (int)[[AppManager getAppManagerInstance] selectedContactsForAdvancedBackupArray].count;
        personForBackupArray = [[NSMutableArray alloc] initWithArray:[[AppManager getAppManagerInstance] selectedContactsForAdvancedBackupArray]];
    } else {
        totalContactsCount = (int)[[AppManager getAppManagerInstance] selectedContactsForFastBackupArray].count;
        personForBackupArray = [[NSMutableArray alloc] initWithArray:[[AppManager getAppManagerInstance] selectedContactsForFastBackupArray]];
    }
    
    
    [processedContactsLable setText:[NSString stringWithFormat:@"Processed 0, Out of %d", totalContactsCount]];
    [totalContactsLable setText:[NSString stringWithFormat:@"Total Contacts: %d", totalContactsCount]];
    
    self.progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:26];
    self.progressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
    self.progressView.popUpViewCornerRadius = 16.0;
    
    [self.progressView showPopUpViewAnimated:YES];
    self.progressView.progress = 0.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    
}

#pragma mark - UINavigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PerformBackupToFinishBackupSegue"])
    {
//        [NSThread sleepForTimeInterval:2];
//        sleep(2);
    }
}

#pragma mark - Timer

- (void)progress
{
    
    NSString *vCardSctrigFull = [NSString string];
    float progress = self.progressView.progress;
    if (progress < 1.0) {
        for (int i = 0; i < totalContactsCount; i++) {
            
            // ode for backup here
            Person *person = (Person *) [personForBackupArray objectAtIndex:i];
            NSString *vCardStringOfRecordID = [VCard generateVCardStringWithRecID:person.personRecordID];
            
            vCardSctrigFull = [vCardSctrigFull stringByAppendingString:vCardStringOfRecordID];
            
            
            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // Calculating and setting progress
                progress = ((i + 1) / totalContactsCount) * 1.0;
                [progressView setProgress:progress animated:YES];
                [processedContactsLable setText:[NSString stringWithFormat:@"Processed %d, Out of %d", i + 1, totalContactsCount]];
//            }];
        }

        
    }
    
    
    //    Here we are creating a new entry to the Core Data for the new backup
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    newBackup = (MyBackup *) [NSEntityDescription insertNewObjectForEntityForName:@"MyBackup" inManagedObjectContext:[myAppDelegate managedObjectContext]];

    
    
    // create vcf file
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *folderPath = [paths objectAtIndex:0];
    
    /*
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"/MyBackup_Files"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    */
    
    
    NSString *dateAndTimeString;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    dateAndTimeString = [dateFormatter stringFromDate:now];
     NSString *fileName = [NSString stringWithFormat:@"Contacts_Backup__%@_%@.vcf", newBackup.backupCriteria, dateAndTimeString];
    
    
    
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    [vCardSctrigFull writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Documents directory: %@",[fileMgr contentsOfDirectoryAtPath: folderPath error:&error]);
    
    // calculate the size of vdf string
    NSUInteger bytes = [vCardSctrigFull lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%lu bytes", (unsigned long)bytes);
    
    NSLog(@"%@",[NSByteCountFormatter stringFromByteCount:bytes countStyle:NSByteCountFormatterCountStyleFile]);
    
    
    
    /*
    // Create VCF filw with framework provided methode
    //----------------------------------------------- create vcf file------------------------------------------
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(addressBook);
    
    CFArrayRef contacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFDataRef vcards = (CFDataRef)ABPersonCreateVCardRepresentationWithPeople(contacts);
    NSString *vcardString = [[NSString alloc] initWithData:(__bridge NSData *)vcards encoding:NSUTF8StringEncoding];
    NSLog(@"Framework vCard String: %@", vcardString);
    NSError *error2;
    NSFileManager *fileMgr2 = [NSFileManager defaultManager];
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *folderPath2 = [paths2 objectAtIndex:0];
    NSString *filePath2 = [folderPath2 stringByAppendingPathComponent:@"Framework_Contacts.vcf"];
    [vcardString writeToFile:filePath2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Documents directory: %@",[fileMgr2 contentsOfDirectoryAtPath: folderPath2 error:&error2]);
    //----------------------------------------------- create vcf file------------------------------------------
    */
    
    
    
    
    
    //TODO: here, set the value of the MyBackup properties
    newBackup.backedUpContactsCount = [NSNumber numberWithInt:totalContactsCount];
    newBackup.vCardStringFull = vCardSctrigFull;
    newBackup.backupFileURL = filePath;
    newBackup.backupFileName = fileName;
    newBackup.backupSize = [NSByteCountFormatter stringFromByteCount:bytes countStyle:NSByteCountFormatterCountStyleFile];
    
    [myAppDelegate saveContext];

    
    
    
    
    if (self.progressView.progress >= 1.0) {
        self.performBackupBarButton.enabled = NO;
        [self performSegueWithIdentifier:@"PerformBackupToFinishBackupSegue" sender:self];
    }
}



- (IBAction)PerformCancel:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    if ([[AppManager getAppManagerInstance] isAdvancedBackup]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)PerformBackup:(id)sender {
    self.progressView.progress = 0.0;
    [self progress];
}








- (void) dealloc
{
    myAppDelegate = nil;
}

@end
