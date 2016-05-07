//
//  ContactSyncingTableViewCell.h
//  Contacts Cop
//
//  Created by Partho on 7/30/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactSyncingTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
