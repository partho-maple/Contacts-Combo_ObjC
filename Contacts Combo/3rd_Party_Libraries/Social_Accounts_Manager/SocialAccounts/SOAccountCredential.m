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

#import "SOAccountCredential.h"

@implementation SOAccountCredential

- (instancetype)init {
    self = [super init];

    self.sessionKey = @"";
    self.authToken = @"";
    self.csrfToken = @"";
    
    return self;
}

- (instancetype)initWithOAuth2Token:(NSString *)token
             refreshToken:(NSString *)refreshToken
               expiryDate:(NSDate *)expiryDate {
    self = [self init];

    self.oauthToken = token;
    self.refreshToken = refreshToken;
    self.expiryDate = expiryDate;
    
    self.credentialType = SOAccountCredentialTypeOAuth2;
    
    return self;
}

- (instancetype)initWithOAuthToken:(NSString *)token tokenSecret:(NSString *)secret {
    self = [self init];

    self.oauth1Token = token;
    self.oauth1Secret = secret;
    
    self.credentialType = SOAccountCredentialTypeOAuth1;
    
    return self;
}

- (instancetype)initWithSessionKey:(NSString *)sessionKey CSRFToken:(NSString *)csrfToken {
    self = [self init];

    self.sessionKey = sessionKey;
    self.csrfToken = csrfToken;
    
    self.credentialType = SOAccountCredentialTypeSession;
    
    return self;
}

- (id)initWithSessionKey:(NSString*)sessionKey authToken:(NSString*)authToken CSRFToken:(NSString*)csrfToken {
    self = [self initWithSessionKey:sessionKey CSRFToken:csrfToken];
    self.authToken = authToken;
    
    return self;
}


- (NSDictionary *)info {
    if (self.credentialType==SOAccountCredentialTypeOAuth2) {
        return @{@"access_token": self.oauthToken, @"scope" : self.scope };
    } else if (self.credentialType==SOAccountCredentialTypeOAuth1 && self.oauth1Token!=nil && self.oauth1Secret!=nil) {
        return @{@"oauth_token": self.oauth1Token, @"oauth_token_secret" : self.oauth1Secret};
    } else if (self.credentialType==SOAccountCredentialTypeSession) {
        if (self.authToken==nil) {
            self.authToken = @"";
        }
        
        return @{@"session_key": self.sessionKey, @"auth_token" : self.authToken, @"csrf_token" : self.csrfToken};
    }
    
    return @{};
}

@end
