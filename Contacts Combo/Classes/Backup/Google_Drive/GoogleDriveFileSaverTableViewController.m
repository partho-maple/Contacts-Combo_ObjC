//
//  GoogleDriveFileSaverTableViewController.m
//  Contacts Cop
//
//  Created by Partho on 9/13/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "GoogleDriveFileSaverTableViewController.h"

// Constants used for OAuth 2.0 authorization.
static NSString *const kKeychainItemName = @"Contacts Combo";
static NSString *const kClientId = @"78217048714-sn0q727ckhrdfn9s77m5s9kain8upkng.apps.googleusercontent.com";
static NSString *const kClientSecret = @"5O9vA9n7aoSnEN8cknVLYlF-";



@interface GoogleDriveFileSaverTableViewController ()

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *authButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, readonly) GTLServiceDrive *driveService;
@property (retain) NSMutableArray *driveFiles;
@property BOOL isAuthorized;

- (IBAction)authButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;

- (void)toggleActionButtons:(BOOL)enabled;
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;
- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth;
- (void)loadDriveFiles;

@end


@implementation GoogleDriveFileSaverTableViewController
//@synthesize addButton = _addButton;
//@synthesize authButton = _authButton;
//@synthesize refreshButton = _refreshButton;
@synthesize driveFiles, isAuthorized;

@synthesize selectedGTLDriveFileForTheUpload, subDirectoriesArray;


UIBarButtonItem *signinButton;
UIBarButtonItem *closeButton;

UIBarButtonItem *addButton;
UIBarButtonItem *refreshButton;
UIBarButtonItem *chooseButton;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Google Drive"];
    self.navigationItem.prompt = NSLocalizedString(@"Choose a destination for uploads.", @"Prompt asking user to select a destination folder on Dropbox to which uploads will be saved.") ;
    
    
    
    
    
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self     action:@selector(addFolderButtonClicked:)];
    refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh     target:self action:@selector(refreshButtonClicked:)];
    
    chooseButton = [[UIBarButtonItem alloc] initWithTitle:@"Choose" style:UIBarButtonItemStylePlain    target:self     action:@selector(chooseFolderToUploadButtonClicked:)];
    
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:addButton, spaceItem, refreshButton, spaceItem, chooseButton, nil];
    
    [self setToolbarItems:toolbarItems animated:NO];
    [addButton setEnabled:NO];
    [refreshButton setEnabled:NO];
    [chooseButton setEnabled:NO];
    
    

    
    
    
    
    
    
    selectedGTLDriveFileForTheUpload = [[GTLDriveFile alloc] init];
    
    
    // Shows the cancel button
    signinButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleBordered target:self action:@selector(authButtonClicked:)];
    self.navigationItem.rightBarButtonItem = signinButton;
    
    
    // Shows the cancel button
    closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(PerformCancelFromGoogleDrive)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    
    // Check for authorization.
    GTMOAuth2Authentication *auth =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientId
                                                      clientSecret:kClientSecret];
    if ([auth canAuthorize]) {
        [self isAuthorizedWithAuthentication:auth];
    }
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /*
    // Check for authorization.
    GTMOAuth2Authentication *auth =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientId
                                                      clientSecret:kClientSecret];
    if ([auth canAuthorize]) {
        [self isAuthorizedWithAuthentication:auth];
    }
    else
    {
        [self authButtonClicked:nil];
    }
    */
    
    
    // Sort Drive Files by modified date (descending order).
    [self.driveFiles sortUsingComparator:^NSComparisonResult(GTLDriveFile *lhs,
                                                             GTLDriveFile *rhs) {
        return [rhs.modifiedDate.date compare:lhs.modifiedDate.date];
    }];
    [self.tableView reloadData];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Rows: %d", self.driveFiles.count);
    return self.driveFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    GTLDriveFile *file = [self.driveFiles objectAtIndex:indexPath.row];
    cell.textLabel.text = file.title;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.driveFiles.count > 0) {
        GTLDriveFile *file = [self.driveFiles objectAtIndex:indexPath.row];
        selectedGTLDriveFileForTheUpload = file;
    }
    
    
    
    [self loadDriveFiles];
}


#pragma mark - Actions

- (void) PerformCancelFromGoogleDrive
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Calss Member Methodes

- (NSInteger)didUpdateFileWithIndex:(NSInteger)index
                          driveFile:(GTLDriveFile *)driveFile {
    if (index == -1) {
        if (driveFile != nil) {
            // New file inserted.
            [self.driveFiles insertObject:driveFile atIndex:0];
            index = 0;
        }
    } else {
        if (driveFile != nil) {
            // File has been updated.
            [self.driveFiles replaceObjectAtIndex:index withObject:driveFile];
        } else {
            // File has been deleted.
            [self.driveFiles removeObjectAtIndex:index];
            index = -1;
        }
    }
    return index;
}

- (GTLServiceDrive *)driveService {
    static GTLServiceDrive *service = nil;
    
    if (!service) {
        service = [[GTLServiceDrive alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        service.retryEnabled = YES;
    }
    return service;
}

- (IBAction)authButtonClicked:(id)sender {
    if (!self.isAuthorized) {
        // Sign in.
        SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
        GTMOAuth2ViewControllerTouch *authViewController =
        [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive // kGTLAuthScopeDriveFile
                                                   clientID:kClientId
                                               clientSecret:kClientSecret
                                           keychainItemName:kKeychainItemName
                                                   delegate:self
                                           finishedSelector:finishedSelector];
        
        
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:authViewController];
        [self presentViewController:navController animated:YES completion:nil];
        
//        [self presentModalViewController:authViewController animated:YES];
        
    } else {
        // Sign out
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
        [[self driveService] setAuthorizer:nil];
        signinButton.title = @"Sign in";
        self.isAuthorized = NO;
        [self toggleActionButtons:NO];
        [self.driveFiles removeAllObjects];
        [self.tableView reloadData];
    }
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self loadDriveFiles];
}

- (IBAction)addFolderButtonClicked:(id)sender {
    
}

- (IBAction)chooseFolderToUploadButtonClicked:(id)sender {
    
}

- (void)toggleActionButtons:(BOOL)enabled {
    addButton.enabled = enabled;
    refreshButton.enabled = enabled;
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (error == nil) {
        [self isAuthorizedWithAuthentication:auth];
    }
}

- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth {
    [[self driveService] setAuthorizer:auth];
    signinButton.title = @"Sign out";
    
    selectedGTLDriveFileForTheUpload.identifier = @"0BxpfCXkGloG6RjJ4d05DTG5EOW8";
    [addButton setEnabled:YES];
    [refreshButton setEnabled:YES];
    [chooseButton setEnabled:YES];
    
    self.isAuthorized = YES;
    [self toggleActionButtons:YES];
    [self loadDriveFiles];
    [self getFileListFromSpecifiedParentFolderWithFolderID:selectedGTLDriveFileForTheUpload.identifier];
}



// Method for loading all files from Google Drive
-(void)loadDriveFiles
{
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    
    //    query.q = [NSString stringWithFormat:@"mimeType='application/vnd.google-apps.folder' and trashed=false and '%@' IN parents", selectedFolderIDForTheUpload];
    
    query.q = [NSString stringWithFormat:@"mimeType='application/vnd.google-apps.folder' and trashed=false and '%@' IN parents", selectedGTLDriveFileForTheUpload.identifier];
    
    // root is for root folder replace it with folder identifier in case to fetch any specific folder
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,
                                                              GTLDriveFileList *files,
                                                              NSError *error) {
        if (error == nil)
        {
            self.driveFiles = [[NSMutableArray alloc] init];
            [self.driveFiles addObjectsFromArray:files.items];
            
            // Now you have all files of root folder
            for (GTLDriveFile *file in self.driveFiles)
            {
                NSLog(@"File is %@", file.title);
                NSLog(@"File ID is %@", file.identifier);
            }
        }
        else
        {
            NSLog(@"An error occurred: %@", error);
        }
        [self.tableView reloadData];
    }];
}




-(void)getFileListFromSpecifiedParentFolderWithFolderID:(NSString *)identifier {
    GTLQueryDrive *query2 = [GTLQueryDrive queryForChildrenListWithFolderId:identifier];
    query2.maxResults = 1000;
    
    // queryTicket can be used to track the status of the request.
    [self.driveService executeQuery:query2
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveChildList *children, NSError *error) {
                      NSLog(@"\nGoogle Drive: file count in the folder: %d", children.items.count);
                      //incase there is no files under this folder then we can avoid the fetching process
                      if (!children.items.count) {
                          return ;
                      }
                      
                      if (error == nil) {
                          for (GTLDriveChildReference *child in children) {
                              
                              GTLQuery *query = [GTLQueryDrive queryForFilesGetWithFileId:child.identifier];
                              
                              // queryTicket can be used to track the status of the request.
                              [self.driveService executeQuery:query
                                            completionHandler:^(GTLServiceTicket *ticket,
                                                                GTLDriveFile *file,
                                                                NSError *error) {
                                                
                                                NSLog(@"\nfile name = %@", file.originalFilename);
                                            }];
                          }
                      }
                  }];
}





@end
