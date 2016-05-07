//
//  AppGalleryView.m
//  AppGallery
//
//  Created by Daniel Sadjadian on 16/08/2014.
//  Copyright (c) 2014 Daniel Sadjadian. All rights reserved.
//

#import "AppGalleryView.h"

@interface AppGalleryView ()

@end

@implementation AppGalleryView
@synthesize data_pass;

/// Buttons ///

-(IBAction)refresh_button {
    [self refresh];
}

-(IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// View Did Load ///

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initilise the app logo image cache.
    self.cached_images = [[NSMutableDictionary alloc] init];
    
    // Get rid of the UIStatus bar.
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    // Start loading the data.
    [self refresh];
}

/// Data load/reload method ///

-(void)refresh {
    
    // Show the user the data is loading.
    [active startAnimating];
    
    // Setup the JSON url and download the data on request.
    NSString *link = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&country=us&entity=software", DEV_NAME];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    NSURLConnection *theConnection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        responseData = [[NSMutableData alloc] init];
    }
    
    else {
        NSLog(@"Error");
    }
}

/// Data loading methods ///

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSString *msg = [NSString stringWithFormat:@"Failed: %@", [error description]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data loading error" message:msg delegate:self cancelButtonTitle:@"Dismiss"otherButtonTitles:nil];
    [alert show];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // Store how many apps need to be loaded.
    result_count = [[res valueForKey:@"resultCount"] integerValue];

    // Store the app data - name, icon, etc...
    app_names = [[res objectForKey:@"results"] valueForKey:@"trackName"];
    dev_names = [[res objectForKey:@"results"] valueForKey:@"sellerName"];
    app_prices = [[res objectForKey:@"results"] valueForKey:@"formattedPrice"];
    app_icons = [[res objectForKey:@"results"] valueForKey:@"artworkUrl512"];
    app_ids = [[res objectForKey:@"results"] valueForKey:@"trackId"];
    app_versions = [[res objectForKey:@"results"] valueForKey:@"version"];
    app_descriptions = [[res objectForKey:@"results"] valueForKey:@"description"];
    app_age = [[res objectForKey:@"results"] valueForKey:@"contentAdvisoryRating"];
    app_ratings = [[res objectForKey:@"results"] valueForKey:@"averageUserRating"];
    app_size = [[res objectForKey:@"results"] valueForKey:@"fileSizeBytes"];
    app_screenshot_iphone = [[res objectForKey:@"results"] valueForKey:@"screenshotUrls"];
    app_screenshot_ipad = [[res objectForKey:@"results"] valueForKey:@"ipadScreenshotUrls"];
    
    // Data is now saved locally, so lets load
    // it into the UITableView to be presented
    // to the user and stop the activity indicator.
    [active stopAnimating];
    [app_table reloadData];
}

/// UITableView methods ///

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Check the rating, make sure it is
    // not null first and then pass it on.
    NSInteger rating;
    
    if (![app_ratings[indexPath.row] isKindOfClass:[NSNull class]]) {
        rating = [app_ratings[indexPath.row] integerValue];
    }
    
    else {
        rating = 0;
    }
    
    // Open the detail view and pass the data
    // to be presented in detail to the user.
    NSString *view_name;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        view_name = [NSString stringWithFormat:@"DetailView_IPAD"];
    }
    
    else {
        view_name = [NSString stringWithFormat:@"DetailView_IPHONE"];
    }
    
    // Edit the input size to MB.
    float size = [app_size[indexPath.row] integerValue];
    size = (size / 1000000);
    
    UIStoryboard *newStoryboard = [UIStoryboard storyboardWithName:view_name bundle:nil];
    DetailView *firstvc = [newStoryboard instantiateInitialViewController];
    self.data_pass = firstvc;
    
    // Set the data to be passed - names, links, etc...
    data_pass.input_name = [NSString stringWithFormat:@"%@", app_names[indexPath.row]];
	data_pass.input_dev_name = [NSString stringWithFormat:@"%@", dev_names[indexPath.row]];
    data_pass.input_price = [NSString stringWithFormat:@"%@", app_prices[indexPath.row]];
    data_pass.input_size = [NSString stringWithFormat:@"%.1fMB", size];
    data_pass.input_age = [NSString stringWithFormat:@"%@", app_age[indexPath.row]];
    data_pass.input_version = [NSString stringWithFormat:@"V%@", app_versions[indexPath.row]];
    data_pass.input_id = [NSString stringWithFormat:@"%@", app_ids[indexPath.row]];
    data_pass.input_rating = [NSString stringWithFormat:@"%ld", (long)rating];
    data_pass.input_logo_link = [NSString stringWithFormat:@"%@", app_icons[indexPath.row]];
    data_pass.input_choice = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    data_pass.input_description = [NSString stringWithFormat:@"%@", app_descriptions[indexPath.row]];
    
    // Pass the screenshot array. We will show the
    // correct image type depending on the device
    // and then what type of screenshots are available.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        // If the device is an iPad, we will show iPad
        // size screenshots. However if the app is an iPhone
        // only app then we will have to show the iPhone
        // sized screenshots.
        
        if ([app_screenshot_ipad[indexPath.row] count] > 0) {
            data_pass.input_screenshot = app_screenshot_ipad;
        }
        
        else {
            data_pass.input_screenshot = app_screenshot_iphone;
        }
    }
    
    else {
        
        // If the device is an iPhone/iPod Touch, we will show
        // iPhone size screenshots. However if the app is an iPad
        // only app then we will have to show the iPad sized screenshots.
        
        if ([app_screenshot_iphone[indexPath.row] count] > 0) {
            data_pass.input_screenshot = app_screenshot_iphone;
        }
        
        else {
            data_pass.input_screenshot = app_screenshot_ipad;
        }
    }
    
    [self presentViewController:firstvc animated:YES completion:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Delegate call back for cell at index path.
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.logo_image.image = nil;
    
    // Set the labels - name, info, etc...
    cell.name_label.text = [NSString stringWithFormat:@"%@", app_names[indexPath.row]];
    cell.dev_label.text = [NSString stringWithFormat:@"%@", dev_names[indexPath.row]];
    
    // Set the rating stars to the correct number
    // and then show the stars.
    NSInteger rating;
    
    if (![app_ratings[indexPath.row] isKindOfClass:[NSNull class]]) {
        
        rating = [app_ratings[indexPath.row] integerValue];
        
        for (int loop = 0; loop <= rating; loop++) {
            
            switch (loop) {
                    
                case 1: cell.star_1.alpha = 1.0; break;
                case 2: cell.star_2.alpha = 1.0; break;
                case 3: cell.star_3.alpha = 1.0; break;
                case 4: cell.star_4.alpha = 1.0; break;
                case 5: cell.star_5.alpha = 1.0; break;
                    
                default: break;
            }
        }
    }
    
    // Set the app logo in the imageview. We will also be caching
    // the images in asynchronously so that there is no image
    // flickering issues and so the UITableView uns smoothly
    // while being scrolled.
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];
    
    if ([self.cached_images objectForKey:identifier] != nil) {
        cell.logo_image.image = [self.cached_images valueForKey:identifier];
    }
    
    else {
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            NSURL *imageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@", app_icons[indexPath.row]]];
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *image = [UIImage imageWithData:data];
                [cell.logo_image setImage:image];
                
                [self.cached_images setValue:image forKey:identifier];
                cell.logo_image.image = [self.cached_images valueForKey:identifier];
                
                // Content has been loaded into the cell, so stop
                // the activity indicator from spinning.
                [cell.logo_active stopAnimating];
            });
        });
    }
    
    // Apply image boarder effects. It looks
    // much nicer with rounded corners. You can
    // also apply other effect too if you wish.
    [cell.logo_image.layer setCornerRadius:16.0];
    
    // Set the cell background colour.
    cell.backgroundColor = [UIColor whiteColor];
    
    // Set the content restraints. Keep things in place
    // otherwise the image/labels dont seem to appear in
    // the correct position on the cell.
    cell.logo_image.clipsToBounds = YES;
    cell.name_label.clipsToBounds = YES;
    cell.dev_label.clipsToBounds = YES;
    cell.star_1.clipsToBounds = YES;
    cell.star_2.clipsToBounds = YES;
    cell.star_3.clipsToBounds = YES;
    cell.star_4.clipsToBounds = YES;
    cell.star_5.clipsToBounds = YES;
    cell.logo_active.clipsToBounds = YES;
    cell.contentView.clipsToBounds = NO;
    
    return cell;
}

-(CGFloat)tableView :(UITableView *)tableView heightForRowAtIndexPath :(NSIndexPath *)indexPath {
    return 116;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return result_count;
}

/// Other methods ///

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
