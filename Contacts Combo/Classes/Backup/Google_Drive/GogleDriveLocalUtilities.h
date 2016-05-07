//
//  GogleDriveLocalUtilities.h
//  Contacts Cop
//
//  Created by Partho on 9/13/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GogleDriveLocalUtilities : NSObject

+ (UIAlertView *)showLoadingMessageWithTitle:(NSString *)title
                                    delegate:(id)delegate;
+ (void)showErrorMessageWithTitle:(NSString *)title
                          message:(NSString *)message
                         delegate:(id)delegate;

@end
