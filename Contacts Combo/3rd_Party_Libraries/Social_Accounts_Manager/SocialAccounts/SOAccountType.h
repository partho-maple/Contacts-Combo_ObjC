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

#import <Foundation/Foundation.h>
#import <Accounts/AccountsDefines.h>
#import <Accounts/ACAccountType.h>
#import <UIKit/UIKit.h>

// The identifiers for supported system account types are listed here:
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierTwitter;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierInstagram;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifier500px;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierTumblr;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierLinkedIn;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierPinterest;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierFacebook;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierFoursquare;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierDribbble;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierGithub;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierVine;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierGooglePlus;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierVoto;
ACCOUNTS_EXTERN NSString * const SOAccountTypeIdentifierAppNet;


@interface SOAccountType : ACAccountType

// A human readable description of the account type.
@property (nonatomic, strong) NSString *accountTypeDescription;

// A unique identifier for the account type. Well known system account type identifiers are listed above.
@property (nonatomic, strong) NSString *identifier;

// A big logo image of the social network
@property (nonatomic, strong) UIImage *logo;

// An icon image of the social network
@property (nonatomic, strong) UIImage *icon;

@end
