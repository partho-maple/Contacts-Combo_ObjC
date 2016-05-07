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

#import "SOTumblrUser.h"
#import "SOTumblrBlog.h"

@implementation SOTumblrUser

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    if (self) {
        _userId = dictionary[@"name"];
        _username = dictionary[@"name"];
        _fullname = dictionary[@"name"];
        _profilePicture = [NSString stringWithFormat:@"http:/api.tumblr.com/v2/blog/%@/avatar", dictionary[@"name"]];
        
        NSMutableArray* blogs = [NSMutableArray array];
        for (NSDictionary* blogDict in dictionary[@"blogs"]) {
            [blogs addObject:[[SOTumblrBlog alloc] initWithDictionary:blogDict]];
        }
        
        _blogs = blogs;
    }
    
    return self;
}


@end
