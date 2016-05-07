//
//  BackupOperationsViewController.m
//  Contacts Cop
//
//  Created by Partho on 8/21/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "BackupOperationsViewController.h"
#import <MessageUI/MessageUI.h>

#import <DropboxSDK/DropboxSDK.h>

#import "GSDropboxDestinationSelectionViewController.h"
#import "GSDropboxUploader.h"



@interface BackupOperationsViewController ()  <GSDropboxDestinationSelectionViewControllerDelegate>

//@property (nonatomic, strong) GTLService *driveService;

@end

@implementation BackupOperationsViewController

@synthesize selectedBackupEntry, driveService;

MFMailComposeViewController *mc;
UINavigationController *dropboxNavigationController;



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
    // Do any additional setup after loading the view.
    
    NSLog(@"Name: %@", selectedBackupEntry.backupFileName);
    NSString * newString = [selectedBackupEntry.backupFileName stringByReplacingOccurrencesOfString:@":" withString:@"/"];
    
    NSLog(@"URL: %@", selectedBackupEntry.backupFileURL);
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:selectedBackupEntry.backupFileName
                                                         ofType:@"vcf"];
    
    
    NSURL *fileURL = [NSURL URLWithString:[selectedBackupEntry.backupFileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDropboxFileProgressNotification:)
                                                 name:GSDropboxUploaderDidGetProgressUpdateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDropboxUploadDidStartNotification:)
                                                 name:GSDropboxUploaderDidStartUploadingFileNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDropboxUploadDidFinishNotification:)
                                                 name:GSDropboxUploaderDidFinishUploadingFileNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDropboxUploadDidFailNotification:)
                                                 name:GSDropboxUploaderDidFailNotification
                                               object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Class Member Methodes

- (void)showEmail:(NSString*)file {
    
    NSString *emailTitle = @"My Contact's Backup";
    NSString *messageBody = @"The backup vcf file of my iPhone has been attached.";
    NSArray *toRecipents = [NSArray arrayWithObject:@"partho.maple@gmail.com"];
    
    mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Determine the file name and extension
    NSArray *filepart = [file componentsSeparatedByString:@"."];
    NSString *filename = [filepart objectAtIndex:0];
    NSString *extension = [filepart objectAtIndex:1];
    
    // Get the resource path and read the file using NSData
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    // Determine the MIME type
    NSString *mimeType;
    if ([extension isEqualToString:@"jpg"]) {
        mimeType = @"image/jpeg";
    } else if ([extension isEqualToString:@"png"]) {
        mimeType = @"image/png";
    } else if ([extension isEqualToString:@"doc"]) {
        mimeType = @"application/msword";
    } else if ([extension isEqualToString:@"ppt"]) {
        mimeType = @"application/vnd.ms-powerpoint";
    } else if ([extension isEqualToString:@"html"]) {
        mimeType = @"text/html";
    } else if ([extension isEqualToString:@"pdf"]) {
        mimeType = @"application/pdf";
    } else if ([extension isEqualToString:@"vcf"]) {
        mimeType = @"text/x-vcard";
    }
    
    // Add attachment
    [mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)PerformUploadToCloud:(id)sender {
}

- (IBAction)PerformSendingEmail:(id)sender {
    NSLog(@"File URL: %@", selectedBackupEntry.backupFileName);
    
    [self showEmail:selectedBackupEntry.backupFileURL];
}

- (IBAction)PerformExportingContacts:(id)sender {
    
    AAImageSize imageSize = AAImageSizeNormal;
    UIImage *image = [UIImage imageNamed:@"Safari.png"];
    NSMutableArray *array = [NSMutableArray array];
    
    
    
    
    
    
    AAActivity *dropboxActivity = [[AAActivity alloc] initWithTitle:@"Dropbox"
                                                              image:image
                                                        actionBlock:^(AAActivity *activity, NSArray *activityItems) {
                                                            NSLog(@"doing activity = %@, activityItems = %@", activity, activityItems);
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            GSDropboxDestinationSelectionViewController *vc = [[GSDropboxDestinationSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
                                                            vc.delegate = self;
                                                            
                                                            dropboxNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                                                            
                                                            
                                                            
                                                            
                                                            [[self navigationController] presentViewController:dropboxNavigationController animated:YES completion:nil];
                                                        }];
    [array addObject:dropboxActivity];
    
    AAActivity *gDriveActivity = [[AAActivity alloc] initWithTitle:@"Goole Drive"
                                                             image:image
                                                       actionBlock:^(AAActivity *activity, NSArray *activityItems) {
                                                           NSLog(@"doing activity = %@, activityItems = %@", activity, activityItems);
                                                           
                                                           
                                                           
                                                           
                                                           
                                                           /*
                                                           if (![self isAuthorized])
                                                           {
                                                               // Not yet authorized, request authorization and push the login UI onto the navigation stack.
                                                               
                                                               UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[self createAuthController]];
                                                               
                                                               [self presentViewController:navController animated:YES completion:nil];
                                                               
                                                           }
                                                           else {
                                                               // Initialize the drive service & load existing credentials from the keychain if available
                                                               self.driveService = [[GTLServiceDrive alloc] init];
                                                               self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName clientID:kClientID clientSecret:kClientSecret];
                                                               
                                                           }
                                                           */
                                                           
                                                           
                                                          
                                                           
                                                           
                                                           GoogleDriveFileSaverTableViewController *googleDriveFileSaverTableViewController = [[GoogleDriveFileSaverTableViewController alloc] init];
//                                                           GoogleDriveFileSaverViewController *googleDriveFileSaverTableViewController = [[GoogleDriveFileSaverViewController alloc] init];
                                                           
                                                           
                                                           
                                                           googleDriveFileSaverTableViewController.selectedGTLDriveFileForTheUpload.identifier = @"0BxpfCXkGloG6RjJ4d05DTG5EOW8";
                                                           googleDriveFileSaverTableViewController.subDirectoriesArray = [NSMutableArray array];
                                                           
                                                           UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:googleDriveFileSaverTableViewController];
                                                           [self presentViewController:navController animated:YES completion:nil];
                                                           
                                                           
                                                        
                                                       }];
    [array addObject:gDriveActivity];
    
    AAActivity *oDriveActivity = [[AAActivity alloc] initWithTitle:@"One Drive"
                                                             image:image
                                                       actionBlock:^(AAActivity *activity, NSArray *activityItems) {
                                                           NSLog(@"doing activity = %@, activityItems = %@", activity, activityItems);
                                                           
                                                           
                                                       }];
    [array addObject:oDriveActivity];
    
    AAActivity *copyActivity = [[AAActivity alloc] initWithTitle:@"Copy"
                                                           image:image
                                                     actionBlock:^(AAActivity *activity, NSArray *activityItems) {
                                                         NSLog(@"doing activity = %@, activityItems = %@", activity, activityItems);
                                                         
                                                         
                                                     }];
    [array addObject:copyActivity];
    
    AAActivity *boxActivity = [[AAActivity alloc] initWithTitle:@"Box"
                                                          image:image
                                                    actionBlock:^(AAActivity *activity, NSArray *activityItems) {
                                                        NSLog(@"doing activity = %@, activityItems = %@", activity, activityItems);
                                                        
                                                        
                                                    }];
    [array addObject:boxActivity];
    
    
    
    
    
    
    AAActivityAction *aa = [[AAActivityAction alloc] initWithActivityItems:@[@"http://www.apple.com/"]
                                                     applicationActivities:array
                                                                 imageSize:imageSize];
    aa.title = @"Select To Export";
    [aa show];
    
}

- (IBAction)PerformRestoringContacts:(id)sender {
}




#pragma mark === Navigation ===

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BAckupOptionsToGDUpSegue"]) {
        
        GoogleDriveFileSaverTableViewController *googleDriveFileSaverTableViewController = (GoogleDriveFileSaverTableViewController *) [segue destinationViewController];
        googleDriveFileSaverTableViewController.selectedGTLDriveFileForTheUpload.identifier = @"0BxpfCXkGloG6RjJ4d05DTG5EOW8";
        googleDriveFileSaverTableViewController.subDirectoriesArray = [NSMutableArray array];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:googleDriveFileSaverTableViewController];
        [self presentViewController:navController animated:YES completion:nil];
        
    }
}



#pragma mark - Class Member methods


-(void)uploadFileToGoogleDrive:(NSString*)fileName
{
    GTLDriveFile *driveFile = [[GTLDriveFile alloc]init];
    
    driveFile.mimeType = @"text/x-vcard";
    driveFile.originalFilename = selectedBackupEntry.backupFileName;
    driveFile.title = selectedBackupEntry.backupFileName;
    
    NSString *filePath = selectedBackupEntry.backupFileURL;
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters
                                             uploadParametersWithData:[NSData dataWithContentsOfFile:filePath]
                                             MIMEType:@"text/x-vcard"];
    
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:driveFile uploadParameters:uploadParameters];
    
    [driveService executeQuery:query
             completionHandler:^(GTLServiceTicket *ticket,
                                 GTLDriveFile *updatedFile,
                                 NSError *error) {
                 if (error == nil) {
                     NSLog(@"\n\nfile uploaded into google drive\\<my_folder> foler");
                 } else {
                     NSLog(@"\n\nfile uplod failed google drive\\<my_folder> foler");
                 }
             }];
    
}


// Helper to check if user is authorized
- (BOOL)isAuthorized
{
    return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to Google Drive.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and updates the Drive service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    if (error != nil)
    {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.driveService.authorizer = nil;
    }
    else
    {
        self.driveService.authorizer = authResult;
    }
}

// Uploads a photo to Google Drive
- (void)uploadPhoto:(UIImage*)image
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"'Quickstart Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"];
    
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = [dateFormat stringFromDate:[NSDate date]];
    file.descriptionProperty = @"Uploaded from the Google Drive iOS Quickstart";
    file.mimeType = @"image/png";
    
    NSData *data = UIImagePNGRepresentation((UIImage *)image);
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                       uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          [self showAlert:@"Google Drive" message:@"File saved!"];
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                          [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                      }
                  }];
}

// Helper for showing a wait indicator in a popup
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
}




#pragma mark - GSDropboxDestinationSelectionViewController delegate methods

- (void)dropboxDestinationSelectionViewController:(GSDropboxDestinationSelectionViewController *)viewController
                         didSelectDestinationPath:(NSString *)destinationPath
{
    NSLog(@"Name: %@", selectedBackupEntry.backupFileName);
    NSLog(@"URL: %@", selectedBackupEntry.backupFileURL);
    
    NSString * fileURLString = [selectedBackupEntry.backupFileURL stringByReplacingOccurrencesOfString:@":" withString:@"/"];
    NSLog(@"fileURLString: %@", fileURLString);
    NSURL *fileURL = [NSURL URLWithString:[fileURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[GSDropboxUploader sharedUploader] uploadFileWithURL:fileURL toPath:destinationPath];
    NSLog(@"dropboxDestinationSelectionViewController");
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropboxDestinationSelectionViewControllerDidCancel:(GSDropboxDestinationSelectionViewController *)viewController
{
    //    self.activityItems = nil;
    //    [self activityDidFinish:NO];
    
    NSLog(@"dropboxDestinationSelectionViewControllerDidCancel");
    [viewController dismissViewControllerAnimated:YES completion:nil];
}







- (void)handleDropboxFileProgressNotification:(NSNotification *)notification
{
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    float progress = [notification.userInfo[GSDropboxUploaderProgressKey] floatValue];
    NSLog(@"Upload of %@ now at %.0f%%", fileURL.absoluteString, progress * 100);
    
    //    self.progressView.progress = progress;
}

- (void)handleDropboxUploadDidStartNotification:(NSNotification *)notification
{
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    NSLog(@"Started uploading %@", fileURL.absoluteString);
    
    //    self.progressView.progress = 0.0;
    //    self.progressView.hidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)handleDropboxUploadDidFinishNotification:(NSNotification *)notification
{
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    NSLog(@"Finished uploading %@", fileURL.absoluteString);
    
    //    self.progressView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)handleDropboxUploadDidFailNotification:(NSNotification *)notification
{
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    NSLog(@"Failed to upload %@", fileURL.absoluteString);
    
    //    self.progressView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



@end
