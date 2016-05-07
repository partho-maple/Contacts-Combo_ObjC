//
//  GSDropboxActivity.m
//
//  Created by Simon Whitaker on 19/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import "GSDropboxActivity.h"
#import "GSDropboxDestinationSelectionViewController.h"
#import "GSDropboxUploader.h"
#import <DropboxSDK/DropboxSDK.h>
//#import <Dropbox/Dropbox.h>

@interface GSDropboxActivity() <GSDropboxDestinationSelectionViewControllerDelegate>

@property (nonatomic, copy) NSArray *activityItems;
@property (nonatomic, retain) GSDropboxDestinationSelectionViewController *dropboxDestinationViewController;
@end

@implementation GSDropboxActivity

+ (NSString *)activityTypeString
{
    return @"uk.co.goosoftware.DropboxActivity";
}

- (NSString *)activityType {
    return [GSDropboxActivity activityTypeString];
}

- (NSString *)activityTitle {
    return @"Dropbox";
}
- (UIImage *)activityImage {
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] integerValue] <= 6) {
        return [UIImage imageNamed:@"GSDropboxActivityIcon-iOS6"];
    } else {
        return [UIImage imageNamed:@"GSDropboxActivityIcon"];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
};

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    // Filter out any items that aren't NSURL objects
    NSMutableArray *urlItems = [NSMutableArray arrayWithCapacity:[activityItems count]];
    for (id object in activityItems) {
        if ([object isKindOfClass:[NSURL class]]) {
            [urlItems addObject:object];
        }
    }
    self.activityItems = [NSArray arrayWithArray:urlItems];
}

- (UIViewController *)activityViewController {
    GSDropboxDestinationSelectionViewController *vc = [[GSDropboxDestinationSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.delegate = self;

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    return nc;
}

#pragma mark - GSDropboxDestinationSelectionViewController delegate methods

- (void)dropboxDestinationSelectionViewController:(GSDropboxDestinationSelectionViewController *)viewController
                         didSelectDestinationPath:(NSString *)destinationPath
{
    for (NSURL *fileURL in self.activityItems) {
        [[GSDropboxUploader sharedUploader] uploadFileWithURL:fileURL toPath:destinationPath];
    }
    self.activityItems = nil;
    [self activityDidFinish:YES];
}

- (void)dropboxDestinationSelectionViewControllerDidCancel:(GSDropboxDestinationSelectionViewController *)viewController
{
    self.activityItems = nil;
    [self activityDidFinish:NO];
}

@end
