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
#import <Accounts/ACAccountCredential.h>

typedef enum {
    SOAccountCredentialTypeOAuth1,
    SOAccountCredentialTypeOAuth2,
    SOAccountCredentialTypeSession
} SOAccountCredentialType;

@interface SOAccountCredential : ACAccountCredential

- (instancetype)initWithSessionKey:(NSString *)sessionKey CSRFToken:(NSString *)csrfToken;

- (instancetype)initWithSessionKey:(NSString *)sessionKey authToken:(NSString *)authToken CSRFToken:(NSString *)csrfToken;


@property (nonatomic, assign) SOAccountCredentialType credentialType;

// All credentials 
@property (copy, NS_NONATOMIC_IOSONLY) NSDictionary *info;


// This property is only valid for OAuth1 credentials
@property (copy, NS_NONATOMIC_IOSONLY) NSString *oauth1Token;
@property (copy, NS_NONATOMIC_IOSONLY) NSString *oauth1Secret;

// This property is only valid for session credentials
@property (copy, NS_NONATOMIC_IOSONLY) NSString *sessionKey;
@property (copy, NS_NONATOMIC_IOSONLY) NSString *authToken;
@property (copy, NS_NONATOMIC_IOSONLY) NSString *csrfToken;


// This property is only valid for OAuth2 credentials
@property (copy, NS_NONATOMIC_IOSONLY) NSString *refreshToken;
@property (copy, NS_NONATOMIC_IOSONLY) NSDate *expiryDate;
@property (nonatomic, strong) NSString* scope;

@end
