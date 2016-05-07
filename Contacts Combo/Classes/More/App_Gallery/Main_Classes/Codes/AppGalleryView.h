//
//  AppGalleryView.h
//  AppGallery
//
//  Created by Daniel Sadjadian on 16/08/2014.
//  Copyright (c) 2014 Daniel Sadjadian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomCell.h"
#import "DetailView.h"

// Replace 'danielsadjadian' with your developer name. make sure your
// developer name is typed like the above with no spaces or capital letters.
#define DEV_NAME @"partho-biswas"

@class CustomCell;
@interface AppGalleryView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    // TableView - show the logo, labels, etc...
    IBOutlet UITableView *app_table;
    
    // JSON parsing - data storage.
    NSMutableData *responseData;
    
    // App list data - name, icon, dev name
    // price, url link, etc...
    NSArray *app_names;
    NSArray *dev_names;
    NSArray *app_prices;
    NSArray *app_icons;
    NSArray *app_ids;
    NSArray *app_versions;
    NSArray *app_descriptions;
    NSArray *app_age;
    NSArray *app_ratings;
    NSArray *app_size;
    NSArray *app_screenshot_iphone;
    NSArray *app_screenshot_ipad;
    
    // How many apps need to be shown?
    // (Automatically processed).
    NSInteger result_count;
    
    // Activity indicator - data loading.
    IBOutlet UIActivityIndicatorView *active;
    
    // Detail view - pass data on.
    DetailView *data_pass;
}

// Buttons.
-(IBAction)refresh_button;
-(IBAction)done;

// Data load/reload method.
-(void)refresh;

// Detail view property - pass data on.
@property (nonatomic, retain) DetailView *data_pass;

// App logos will be cached to memory.
@property (strong ,nonatomic) NSMutableDictionary *cached_images;

@end
