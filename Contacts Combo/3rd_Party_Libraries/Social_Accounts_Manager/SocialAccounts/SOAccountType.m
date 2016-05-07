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

#import "SOAccountType.h"

NSString * const SOAccountTypeIdentifierTwitter = @"com.apple.twitter";
NSString * const SOAccountTypeIdentifierInstagram = @"com.apple.instagram";
NSString * const SOAccountTypeIdentifier500px = @"com.apple.500px";
NSString * const SOAccountTypeIdentifierTumblr = @"com.apple.tumblr";
NSString * const SOAccountTypeIdentifierLinkedIn = @"com.apple.linkedin";
NSString * const SOAccountTypeIdentifierPinterest = @"com.apple.pinterest";
NSString * const SOAccountTypeIdentifierFacebook = @"com.apple.facebook";
NSString * const SOAccountTypeIdentifierFoursquare = @"com.apple.foursquare";
NSString * const SOAccountTypeIdentifierDribbble = @"com.apple.dribbble";
NSString * const SOAccountTypeIdentifierGithub = @"com.apple.github";
NSString * const SOAccountTypeIdentifierVine = @"com.apple.vine";
NSString * const SOAccountTypeIdentifierGooglePlus = @"com.apple.googleplus";
NSString * const SOAccountTypeIdentifierVoto = @"com.apple.voto";
NSString * const SOAccountTypeIdentifierAppNet = @"com.apple.appnet";

@implementation SOAccountType

- (UIImage *)logo {
    return [UIImage imageNamed:[NSString stringWithFormat:@"SocialAccounts.bundle/%@.logo.png", self.identifier]];
}

- (UIImage *)icon {
    return [UIImage imageNamed:[NSString stringWithFormat:@"SocialAccounts.bundle/%@.icon.png", self.identifier]];
}

@end
