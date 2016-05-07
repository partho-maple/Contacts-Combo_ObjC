//
//  CleanupViewController.h
//  Contacts Cop
//
//  Created by Partho on 8/14/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactOpsUtils.h"
#import "REFrostedViewController.h"

@interface CleanupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *MassDeletionButton;
@property (weak, nonatomic) IBOutlet UIButton *MissingNameButton;
@property (weak, nonatomic) IBOutlet UIButton *MissingPhoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *EmptyContactsButton;


- (IBAction)ShowMainMenu:(id)sender;

- (IBAction)MassDeletionButtonTapped:(id)sender;
- (IBAction)MissingNameButtonTapped:(id)sender;
- (IBAction)MissingPhoneNumberButtonTapped:(id)sender;
- (IBAction)EmptyContactsButtonTapped:(id)sender;

@end
