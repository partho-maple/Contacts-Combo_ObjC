//
//  ChecklistItem.m
//  Quick Dial
//
//  Created by Kalai Chelvan on 5/7/13.
//  Copyright (c) 2013 Kalai Chelvan. All rights reserved.
//

#import "QuicklistItem.h"

@implementation QuicklistItem


///synthesize the created properties

@synthesize name, mobile, image;


///declare method to encode and decode the info from plist file

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.mobile = [aDecoder decodeObjectForKey:@"Mobile"];
        self.image = [aDecoder decodeObjectForKey:@"Image"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.mobile forKey:@"Mobile"];
    [aCoder encodeObject:self.image forKey:@"Image"];
}






@end
