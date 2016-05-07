//
//  ContactsTableViewCell.m
//  Contacts Cop
//
//  Created by Partho on 7/16/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "ContactsTableViewCell.h"

@implementation ContactsTableViewCell

@synthesize profileImage,name;

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
