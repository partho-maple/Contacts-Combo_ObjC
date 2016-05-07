//
//  GSDropboxDestinationSelectionViewController.m
//
//  Created by Simon Whitaker on 06/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import "GSDropboxDestinationSelectionViewController.h"
#import <DropboxSDK/DropboxSDK.h>
//#import <Dropbox/Dropbox.h>

#define kDropboxConnectionMaxRetries 2

@interface GSDropboxDestinationSelectionViewController () <DBRestClientDelegate>
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) NSArray *subdirectories;
@property (nonatomic, strong) DBRestClient *dropboxClient;
@property (nonatomic) NSUInteger dropboxConnectionRetryCount;

- (void)handleApplicationBecameActive:(NSNotification *)notification;
- (void)handleCancel;
- (void)handleSelectDestination;

@end

@implementation GSDropboxDestinationSelectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _isLoading = YES;
        self.dropboxConnectionRetryCount = 0;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(handleCancel)];
    
    self.toolbarItems = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Choose", @"Title for button that user taps to specify the current folder as the storage location for uploads.")
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(handleSelectDestination)]
    ];
    
    [self.navigationController setToolbarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.toolbar.tintColor = [UIColor darkGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationBecameActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateChooseButton];
    
    if (self.rootPath == nil)
        self.rootPath = @"/";
    
    if ([self.rootPath isEqualToString:@"/"]) {
        self.title = @"Dropbox";
    } else {
        self.title = [self.rootPath lastPathComponent];
    }
    self.navigationItem.prompt = NSLocalizedString(@"Choose a destination for uploads.", @"Prompt asking user to select a destination folder on Dropbox to which uploads will be saved.") ;
    self.isLoading = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void) updateChooseButton {
    NSArray* toolbarButtons = self.toolbarItems;
    if(toolbarButtons.count < 2) {
        //Not found
        return;
    }
    UIBarButtonItem *item = toolbarButtons[1];
    BOOL hasValidData = [self hasValidData];
    item.enabled = hasValidData;
}

- (BOOL) hasValidData {
    BOOL valid = self.subdirectories != nil && self.isLoading == NO;
    return valid;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[DBSession sharedSession] isLinked]) {
        [self showLoginDialogOrCancel];
    } else {
        [self.dropboxClient loadMetadata:self.rootPath];
    }
}

- (void) showLoginDialogOrCancel {
    if(self.dropboxConnectionRetryCount < kDropboxConnectionMaxRetries) {
        self.dropboxConnectionRetryCount++;
        //disable cancel button, as if the user pressed it while we're presenting
        //the loging viewcontroller (async), UIKit crashes with multiple viewcontroller
        //animations
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [self.delegate dropboxDestinationSelectionViewControllerDidCancel:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (DBRestClient *)dropboxClient
{
    if (_dropboxClient == nil && [DBSession sharedSession] != nil) {
        _dropboxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _dropboxClient.delegate = self;
    }
    return _dropboxClient;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self hasValidData] || self.subdirectories.count < 1) return 1;

    return [self.subdirectories count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (self.isLoading) {
        cell.textLabel.text = NSLocalizedString(@"Loading...", @"Progress message while app is loading a list of folders from Dropbox");
    } else if (self.subdirectories == nil) {
        cell.textLabel.text = NSLocalizedString(@"Error loading folder contents", @"Error message if the app couldn't load a list of a folder's contents from Dropbox");
    } else if ([self.subdirectories count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"Contains no folders", @"Status message when the current folder contains no sub-folders");
    } else {
        cell.textLabel.text = [[self.subdirectories objectAtIndex:indexPath.row] lastPathComponent];
        cell.imageView.image = [UIImage imageNamed:@"folder-icon.png"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.subdirectories count] > indexPath.row) {
        GSDropboxDestinationSelectionViewController *vc = [[GSDropboxDestinationSelectionViewController alloc] init];
        vc.delegate = self.delegate;
        vc.rootPath = [self.rootPath stringByAppendingPathComponent:[self.subdirectories objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Dropbox client delegate methods

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    NSMutableArray *array = [NSMutableArray array];
    for (DBMetadata *file in metadata.contents) {
        if (file.isDirectory && [file.filename length] > 0 && [file.filename characterAtIndex:0] != '.') {
            [array addObject:file.filename];
        }
    }
    self.subdirectories = [array sortedArrayUsingSelector:@selector(compare:)];
    self.isLoading = NO;
    [self updateChooseButton];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    // Error 401 gets returned if a token is invalid, e.g. if the user has deleted
    // the app from their list of authorized apps at dropbox.com
    if (error.code == 401) {
        [self showLoginDialogOrCancel];
    } else {
        self.isLoading = NO;
    }
    [self updateChooseButton];
}

- (void)setIsLoading:(BOOL)isLoading
{
    if (_isLoading != isLoading) {
        _isLoading = isLoading;
        [self.tableView reloadData];
    }
}

- (void)handleCancel
{
    id<GSDropboxDestinationSelectionViewControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dropboxDestinationSelectionViewControllerDidCancel:)]) {
        [delegate dropboxDestinationSelectionViewControllerDidCancel:self];
    }
}

- (void)handleSelectDestination
{
    id<GSDropboxDestinationSelectionViewControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dropboxDestinationSelectionViewController:didSelectDestinationPath:)]) {
        [delegate dropboxDestinationSelectionViewController:self
                                   didSelectDestinationPath:self.rootPath];
    }
}

- (void)handleApplicationBecameActive:(NSNotification *)notification
{
    // Happens after user has been bounced out to Dropbox.app or Safari.app
    // to authenticate
    [self.dropboxClient loadMetadata:self.rootPath];
    self.isLoading = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

@end
