//
//  ContactMergingTableViewCell.m
//  Contacts Cop
//
//  Created by Partho on 7/15/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "ContactMergingTableViewCell.h"

@implementation ContactMergingTableViewCell

@synthesize nameLable, numberLable;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
