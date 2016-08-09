//
//  DetailView.h
//  AppGallery
//
//  Created by Partho Biswas on 16/08/2014.
//  Copyright (c) 2014 Partho Biswas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

// You cam change the message to whatever you want.
// However, make sure you leave the two '%@' symbols
// in the message, as they are automatically replaced
// by the 'app name' and 'developer name' respectively.
// The app url link is also attatched to the share sheet.
#define SHARE_MESS @"Check out %@ #app by %@"

// Once again you can edit the email message but make
// sure you leave the three '%@' signs. The email string
// contains an extra '%@' symbol which is automatically
// replaced with the app url link.
#define SHARE_MESS_EMAIL @"Check out %@ app by %@ - %@"

@interface DetailView : UIViewController <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate> {
    
    // App download link - for sharing and
    // for opening the app store app.
    NSString *url_with_id;
    
    // Input data - name, logo, etc...
    NSString *input_name;
    NSString *input_dev_name;
    NSString *input_logo_link;
    NSString *input_price;
    NSString *input_age;
    NSString *input_version;
    NSString *input_size;
    NSString *input_rating;
    NSString *input_id;
    NSString *input_choice;
    NSString *input_description;
    NSArray *input_screenshot;
    
    // Current screenshot being viewed.
    int current_screenshot;
    
    // Labels - name, version, etc...
    IBOutlet UILabel *label_name;
    IBOutlet UILabel *label_dev_name;
    IBOutlet UILabel *label_price;
    IBOutlet UILabel *label_age;
    IBOutlet UILabel *label_version;
    IBOutlet UILabel *label_size;
    
    // Rating star images.
    IBOutlet UIImageView *star_1;
    IBOutlet UIImageView *star_2;
    IBOutlet UIImageView *star_3;
    IBOutlet UIImageView *star_4;
    IBOutlet UIImageView *star_5;
    
    // Images - logo & screenshots.
    IBOutlet UIImageView *app_logo;
    IBOutlet UIImageView *app_screenshot;
    
    // Shows the current app screenshot.
    IBOutlet UIPageControl *pic_num;
    
    // Main scroll view - for all content.
    IBOutlet UIScrollView *scroll;
    
    // Description label - iPad ONLY.
    // On the iPhone the description is
    // shown in a Alert View.
    IBOutlet UITextView *description_text;
    
    // iPad Only - black activity indicator view.
    IBOutlet UIActivityIndicatorView *active_black;
    IBOutlet UIView *background_active_black;
}

// Buttons.
-(IBAction)done;
-(IBAction)share;
-(IBAction)download;
-(IBAction)view_description;

// Input data load method.
-(void)refresh;

// Screenshot image set method.
-(void)set_screenshot:(NSString *)input_url;

// Social sharing methods - FB/TW.
-(void)send_fb_post;
-(void)send_tweet;

// Input strng properties.
@property (nonatomic, retain) NSString *input_name;
@property (nonatomic, retain) NSString *input_dev_name;
@property (nonatomic, retain) NSString *input_logo_link;
@property (nonatomic, retain) NSString *input_price;
@property (nonatomic, retain) NSString *input_age;
@property (nonatomic, retain) NSString *input_version;
@property (nonatomic, retain) NSString *input_size;
@property (nonatomic, retain) NSString *input_rating;
@property (nonatomic, retain) NSString *input_id;
@property (nonatomic, retain) NSString *input_choice;
@property (nonatomic, retain) NSString *input_description;
@property (nonatomic, retain) NSArray *input_screenshot;

@end
