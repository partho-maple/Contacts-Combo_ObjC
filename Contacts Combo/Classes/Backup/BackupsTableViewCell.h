//
//  BackupsTableViewCell.h
//  Contacts Cop
//
//  Created by Partho on 8/21/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface BackupsTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *backupTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *backupTypeLable;
@property (weak, nonatomic) IBOutlet MarqueeLabel *backupInfoLable;
@property (weak, nonatomic) IBOutlet UILabel *backupContactsCountLable;

@end
