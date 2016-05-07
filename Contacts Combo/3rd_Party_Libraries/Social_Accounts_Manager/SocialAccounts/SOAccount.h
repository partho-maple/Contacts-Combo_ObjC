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
#import "SOAccountType.h"
#import "SOAccountCredential.h"

@interface SOAccount : NSObject

// Creates a new account object with a specified account type.
- (instancetype)initWithAccountType:(SOAccountType *)type;

// This identifier can be used to look up the account using [SOAccountStore accountWithIdentifier:].
@property (readonly, weak, NS_NONATOMIC_IOSONLY) NSString      *identifier;

// Accounts are stored with a particular account type. All available accounts of a particular type
// can be looked up using [SOAccountStore accountsWithAccountType:]. When creating new accounts
// this property is required.
@property (strong, NS_NONATOMIC_IOSONLY)   SOAccountType       *accountType;

// A human readable description of the account.
@property (copy, NS_NONATOMIC_IOSONLY)     NSString            *accountDescription;

// The id for the account. This property can be set and saved during account creation.
@property (copy, NS_NONATOMIC_IOSONLY)     NSString            *userId;

// The username for the account. This property can be set and saved during account creation.
@property (copy, NS_NONATOMIC_IOSONLY)     NSString            *username;

// The credential for the account. This property can be set and saved during account creation.
@property (strong, NS_NONATOMIC_IOSONLY)   SOAccountCredential *credential;

@end
