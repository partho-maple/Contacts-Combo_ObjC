//
//  CustomCell.h
//  AppGallery
//
//  Created by Daniel Sadjadian on 16/08/2014.
//  Copyright (c) 2014 Daniel Sadjadian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell {
    
}

// Name/dev labels.
@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UILabel *dev_label;

// App logo image.
@property (strong, nonatomic) IBOutlet UIImageView *logo_image;

// Rating stars.
@property (strong, nonatomic) IBOutlet UIImageView *star_1;
@property (strong, nonatomic) IBOutlet UIImageView *star_2;
@property (strong, nonatomic) IBOutlet UIImageView *star_3;
@property (strong, nonatomic) IBOutlet UIImageView *star_4;
@property (strong, nonatomic) IBOutlet UIImageView *star_5;

// Image activity indictor.
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *logo_active;

@end
