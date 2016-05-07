//
//  ChecklistItem.h
//  Quick Dial
//
//  Created by Kalai Chelvan on 5/7/13.
//  Copyright (c) 2013 Kalai Chelvan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuicklistItem : NSObject <NSCoding>

///create property for name, mobile and image

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) UIImage *image;



@end