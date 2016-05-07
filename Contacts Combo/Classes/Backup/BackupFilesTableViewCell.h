//
//  BackupFilesTableViewCell.h
//  Contacts Combo
//
//  Created by Partho on 9/21/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface BackupFilesTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet MarqueeLabel *backupFileName;
@property (weak, nonatomic) IBOutlet MarqueeLabel *backupFileInfo;

@end
