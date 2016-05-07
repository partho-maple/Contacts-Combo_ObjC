//
// Copyright 2011-2012 Adar Porat (https://github.com/aporat)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "SOFacebookUser.h"

@implementation SOFacebookUser

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    if (self) {
        _userId = [NSString stringWithFormat:@"%@", dictionary[@"id"]];
        _username = @"";
        _fullname = dictionary[@"name"];
        _profilePicture = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", dictionary[@"id"]];
    }
    
    return self;
}

@end
