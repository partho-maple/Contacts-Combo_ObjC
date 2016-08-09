//
//  CustomCell.m
//  AppGallery
//
//  Created by Partho Biswas on 16/08/2014.
//  Copyright (c) 2014 Partho Biswas. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //_thumbnail.alpha = 1.0;
}

@end
