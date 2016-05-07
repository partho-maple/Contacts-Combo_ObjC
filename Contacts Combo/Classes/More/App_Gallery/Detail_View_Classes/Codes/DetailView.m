//
//  DetailView.m
//  AppGallery
//
//  Created by Daniel Sadjadian on 16/08/2014.
//  Copyright (c) 2014 Daniel Sadjadian. All rights reserved.
//

#import "DetailView.h"

@interface DetailView ()

@end

@implementation DetailView
@synthesize input_name;
@synthesize input_dev_name;
@synthesize input_logo_link;
@synthesize input_price;
@synthesize input_age;
@synthesize input_version;
@synthesize input_size;
@synthesize input_rating;
@synthesize input_id;
@synthesize input_choice;
@synthesize input_description;
@synthesize input_screenshot;

/// Buttons ///

-(IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)share {
    
    NSString *actionSheetTitle = @"Share app";
    NSString *button_1 = @"Facebook";
    NSString *button_2 = @"Twitter";
    NSString *button_3 = @"Email";
    NSString *button_4 = @"Copy Link";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles:button_1, button_2, button_3, button_4, nil];
    
    [actionSheet showInView:self.view];
}

-(IBAction)download {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_with_id]];
}

-(IBAction)view_description {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Info" message:input_description delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

/// View Did Load ///

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get rid of the UIStatus bar.
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    // Add nice corner effect to
    // black activity indicator background.
    [background_active_black.layer setCornerRadius:16.0];
    
    // Setup the scroll view.
    [scroll setScrollEnabled:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height == 480) {
            // 3.5 inch display.
            [scroll setContentSize:CGSizeMake(320, 497)];
            star_1.frame = CGRectOffset(star_1.frame, 0, 10.0f);
            star_2.frame = CGRectOffset(star_2.frame, 0, 10.0f);
            star_3.frame = CGRectOffset(star_3.frame, 0, 10.0f);
            star_4.frame = CGRectOffset(star_4.frame, 0, 10.0f);
            star_5.frame = CGRectOffset(star_5.frame, 0, 10.0f);
        }
        
        if (result.height >= 568) {
            // 4 inch display (or bigger).
            [scroll setContentSize:CGSizeMake(320, 585)];
        }
    }
    
    // Add left/right swipe recognizers. So that the
    // user can swipe through the app screenshots.
    UISwipeGestureRecognizer *leftRecognizer;
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageswipped_left:)];
    [leftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [app_screenshot addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageswipped_right:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [app_screenshot addGestureRecognizer:rightRecognizer];
    
    // Apply nice curved border - app logo.
    [app_logo.layer setCornerRadius:16.0];
    [app_logo.layer setMasksToBounds:YES];
    
    // Load the input data.
    [self refresh];
}

/// View Did Appear ///

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    NSInteger chosen = [input_choice integerValue];
    
    // Set the screenshot.
    [self set_screenshot:[input_screenshot[chosen] firstObject]];
    [app_screenshot setUserInteractionEnabled:YES];
    
    // Set the current screentshot number.
    current_screenshot = 0;
    
    // Set the screenshot count.
    [pic_num setNumberOfPages:[input_screenshot[chosen] count]];
}

/// Input data load method ///

-(void)refresh {
    
    [active_black startAnimating];
    [background_active_black setAlpha:1.0];
    
    // Set the labels first - name, age, etc...
    label_name.text = input_name;
    label_dev_name.text = input_dev_name;
    label_price.text = input_price;
    label_size.text = input_size;
    label_age.text = input_age;
    label_version.text = input_version;
    
    // If the device is an iPad, show the description
    // text view label. On iPhone this is shown in a
    // alert view popup text view.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        description_text.text = input_description;
    }
    
    // Set the app download url.
    url_with_id = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", input_id];
    
    // Set the rating stars.
    NSInteger rating = [input_rating integerValue];
    
    for (int loop = 0; loop <= rating; loop++) {
        
        switch (loop) {
                
            case 1: star_1.alpha = 1.0; break;
            case 2: star_2.alpha = 1.0; break;
            case 3: star_3.alpha = 1.0; break;
            case 4: star_4.alpha = 1.0; break;
            case 5: star_5.alpha = 1.0; break;
                
            default: break;
        }
    }
    
    // Download and set the app logo.
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        NSURL *logo_url = [NSURL URLWithString:input_logo_link];
        NSData *logo_data = [NSData dataWithContentsOfURL:logo_url];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *logo_image = [UIImage imageWithData:logo_data];
            [app_logo setImage:logo_image];
        });
    });
}

/// Social sharing methods - FB/TW ///

-(void)send_fb_post {
    
    // Create an instance of the FB Sheet.
    SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    // Sets the completion handler. Note that we don't know which thread the
    // block will be called on, so we need to ensure that any UI updates occur
    // on the main queue.
    fbSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        
        switch(result) {
                // This means the user cancelled without sending the FB.
            case SLComposeViewControllerResultCancelled:
                break;
                
                // This means the user hit 'Send'.
            case SLComposeViewControllerResultDone:
                break;
        }
        
        // Dismiss the FB Sheet.
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    
    // Set the initial body of the FB post.
    [fbSheet setInitialText:[NSString stringWithFormat:SHARE_MESS, input_name, input_dev_name]];
    
    // Add an URL to the FB post.
    [fbSheet addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", input_id]]];
    
    // Presents the FB Sheet to the user.
    [self presentViewController:fbSheet animated:NO completion:nil];
}

-(void)send_tweet {
    
    // Create an instance of the Tweet Sheet.
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    // Sets the completion handler. Note that we don't know which thread the
    // block will be called on, so we need to ensure that any UI updates occur
    // on the main queue.
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        
        switch(result) {
                // This means the user cancelled without sending the Tweet.
            case SLComposeViewControllerResultCancelled:
                break;
                
                // This means the user hit 'Send'.
            case SLComposeViewControllerResultDone:
                break;
        }
        
        // Dismiss the Tweet Sheet.
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    
    // Set the initial body of the Tweet.
    [tweetSheet setInitialText:[NSString stringWithFormat:SHARE_MESS, input_name, input_dev_name]];
    
    // Add an URL to the Tweet.
    [tweetSheet addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", input_id]]];
    
    // Presents the Tweet Sheet to the user.
    [self presentViewController:tweetSheet animated:NO completion:nil];
}

/// Mail sending methods ///

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	[self dismissViewControllerAnimated:NO completion:nil];
	
    if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Error" message:@"Mail was unable to send your E-Mail. Make sure you are connected to an EDGE/3G/4G or WiFi conection and try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
	}
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled: [self dismissViewControllerAnimated:YES completion:NULL]; break;
        case MessageComposeResultFailed: [self dismissViewControllerAnimated:YES completion:NULL]; break;
        case MessageComposeResultSent: [self dismissViewControllerAnimated:YES completion:NULL]; break;
        default: break;
    }
}

// Screenshot image set method.

-(void)set_screenshot:(NSString *)input_url {
    
    NSURL *image_url = [NSURL URLWithString:input_url];
    NSData *data = [NSData dataWithContentsOfURL:image_url];
    UIImage *image = [UIImage imageWithData:data];
    [app_screenshot setImage:image];
    
    [active_black stopAnimating];
    [background_active_black setAlpha:0.0];
    
    return;
}

/// Other methods ///

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            [self send_fb_post];
        }
        
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"You can't send a Facebook post right now, make sure your device has an internet connection and you have at least one Facebook account setup." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    else if (buttonIndex == 1) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            [self send_tweet];
        }
        
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    else if (buttonIndex == 2) {
        
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        composer.mailComposeDelegate = self;
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:[NSArray arrayWithObjects:@"", nil]];
            [composer setSubject:@""];
            [composer setMessageBody:[NSString stringWithFormat:SHARE_MESS_EMAIL, input_name, input_dev_name, [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", input_id]] isHTML:NO];
            
            [self presentViewController:composer animated:YES completion:nil];
        }
    }
    
    else if (buttonIndex == 3) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", input_id];
    }
}

-(void)imageswipped_left:(UISwipeGestureRecognizer*)sender {
    
    NSInteger chosen = [input_choice integerValue];
    
    if ((current_screenshot + 1) < [input_screenshot[[input_choice integerValue]] count]) {
        current_screenshot = current_screenshot + 1;
        [pic_num setCurrentPage:(pic_num.currentPage + 1)];
        
        [active_black startAnimating];
        [background_active_black setAlpha:1.0];
        [self set_screenshot:[input_screenshot[chosen] objectAtIndex:current_screenshot]];
    }
}

-(void)imageswipped_right:(UISwipeGestureRecognizer*)sender {
    
    NSInteger chosen = [input_choice integerValue];
    
    if ((current_screenshot - 1) >= 0) {
        current_screenshot = current_screenshot - 1;
        [pic_num setCurrentPage:(pic_num.currentPage - 1)];
        
        [active_black startAnimating];
        [background_active_black setAlpha:1.0];
        [self set_screenshot:[input_screenshot[chosen] objectAtIndex:current_screenshot]];
    }
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
