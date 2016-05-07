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

#import "SOAccount.h"

@implementation SOAccount

- (instancetype)initWithAccountType:(SOAccountType *)type {
    self = [super init];
    
    if (self) {
        self.accountType = type;
    }
    
    return self;
}

- (NSString *)identifier {
    if (self.userId) {
        return [NSString stringWithFormat:@"%@-%@", self.accountType.identifier, self.userId];
    }
    
    return [NSString stringWithFormat:@"%@-%@", self.accountType.identifier, self.username];
}

@end
