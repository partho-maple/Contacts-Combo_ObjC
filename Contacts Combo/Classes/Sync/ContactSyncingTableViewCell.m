//
//  ContactSyncingTableViewCell.m
//  Contacts Cop
//
//  Created by Partho on 7/30/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "ContactSyncingTableViewCell.h"

@implementation ContactSyncingTableViewCell

@synthesize profileImage, name, number;

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
