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

#import "SOAccountStore.h"
#import <Security/Security.h>

// Options dictionary keys for OAuth2 service providers
NSString * const SOOAuth2ClientID = @"com.socialaccounts.oauth2.client_id";
NSString * const SOOAuth2ClientSecret = @"com.socialaccounts.oauth2.client_secret";
NSString * const SOOAuth2RedirectURI = @"com.socialaccounts.oauth2.redirect_uri";

// Options dictionary keys for OAuth1 service providers
NSString * const SOOAuth1ClientID = @"com.socialaccounts.oauth1.client_id";
NSString * const SOOAuth1ClientSecret = @"com.socialaccounts.oauth1.client_secret";
NSString * const SOOAuth1RedirectURI = @"com.socialaccounts.oauth1.redirect_uri";


@interface SOAccountStore ()

@property(nonatomic, copy) SOAccountStoreSaveCompletionHandler saveAccountHandler;

@end

@implementation SOAccountStore

- (SOAccount *)accountWithIdentifier:(NSString *)identifier {
    NSDictionary *info = [self getDictionaryForKey:identifier];
    
    SOAccountType* type = [self accountTypeWithAccountTypeIdentifier:info[@"type"]];
    SOAccount* account = [[SOAccount alloc] initWithAccountType:type];
    account.username = info[@"username"];
    account.userId = info[@"user_id"];
    
    SOAccountCredential* credential;
    
    SOAccountCredentialType credentialType = [info[@"credential.type"] integerValue];
    
    if (credentialType==SOAccountCredentialTypeOAuth2) {
        credential = [[SOAccountCredential alloc] initWithOAuth2Token:info[@"credential.oauthToken"] refreshToken:nil expiryDate:nil];
        credential.scope = info[@"credential.scope"];
        credential.refreshToken = info[@"credential.refreshToken"];
        credential.expiryDate = info[@"credential.expiryDate"];
        
    } else if (credentialType==SOAccountCredentialTypeOAuth1) {
        credential = [[SOAccountCredential alloc] initWithOAuthToken:info[@"credential.oauthToken"] tokenSecret:info[@"credential.oauthTokenSecret"]];
    } else if (credentialType==SOAccountCredentialTypeSession) {
        credential = [[SOAccountCredential alloc] initWithSessionKey:info[@"credential.sessionKey"] authToken:info[@"credential.authToken"] CSRFToken:info[@"credential.csrfToken"]];
    }
    
    account.credential = credential;
    
    return account;
}

- (void)saveAccount:(SOAccount *)account withCompletionHandler:(SOAccountStoreSaveCompletionHandler)completionHandler {
    self.saveAccountHandler = completionHandler;
    
    NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
    info[@"type"] = account.accountType.identifier;
    
    if (account.userId!=nil) {
        info[@"user_id"] = account.userId;
    }
    
    if (account.username!=nil) {
        info[@"username"] = account.username;
    }
    
    if (account.credential.credentialType==SOAccountCredentialTypeOAuth2) {
        if (account.credential.oauthToken!=nil && account.credential.scope!=nil) {
            info[@"credential.type"] = @(SOAccountCredentialTypeOAuth2);
            info[@"credential.oauthToken"] = account.credential.oauthToken;
            info[@"credential.scope"] = account.credential.scope;
            
            if (account.credential.refreshToken!=nil) {
                info[@"credential.refreshToken"] = account.credential.refreshToken;
            }
            
            if (account.credential.expiryDate!=nil) {
                info[@"credential.expiryDate"] = account.credential.expiryDate;
            }
        }
    } else if (account.credential.credentialType==SOAccountCredentialTypeOAuth1) {
        if (account.credential.oauth1Token!=nil && account.credential.oauth1Secret!=nil) {
            info[@"credential.type"] = @(SOAccountCredentialTypeOAuth1);
            info[@"credential.oauthToken"] = account.credential.oauth1Token;
            info[@"credential.oauthTokenSecret"] = account.credential.oauth1Secret;
        }
    } else if (account.credential.credentialType==SOAccountCredentialTypeSession) {
        info[@"credential.type"] = @(SOAccountCredentialTypeSession);
        info[@"credential.sessionKey"] = account.credential.sessionKey;
        info[@"credential.authToken"] = account.credential.authToken;
        info[@"credential.csrfToken"] = account.credential.csrfToken;
    }
    
    [self setDictionary:info forKey:account.identifier];
    
    
    NSMutableArray* accounts = [[self getArrayForKey:@"Accounts"] mutableCopy];
    if (accounts==nil) {
        accounts = [[NSMutableArray alloc] init];
    }
    
    // find if the account already in the database. if so, we'll remove the old copy
    for (SOAccount* localAccount in self.accounts) {
        if ([localAccount.identifier isEqualToString:account.identifier]) {
            [accounts removeObject:localAccount.identifier];
        }
    }
    
    [accounts addObject:account.identifier];
    
    [self setArray:accounts forKey:@"Accounts"];
    
    if (self.saveAccountHandler) {
        self.saveAccountHandler(YES, nil);
        self.saveAccountHandler = nil;
    }
}

- (void)removeAccount:(SOAccount *)account withCompletionHandler:(SOAccountStoreSaveCompletionHandler)completionHandler {
    self.saveAccountHandler = completionHandler;

    NSMutableArray* accounts = [[self getArrayForKey:@"Accounts"] mutableCopy];
    if (accounts==nil) {
        accounts = [[NSMutableArray alloc] init];
    }

    // find if the account already in the database. if so, we'll remove the old copy
    for (SOAccount* localAccount in self.accounts) {
        if ([localAccount.identifier isEqualToString:account.identifier]) {
            [accounts removeObject:localAccount.identifier];
        }
    }
    
    [self setArray:accounts forKey:@"Accounts"];

    if (self.saveAccountHandler) {
        self.saveAccountHandler(YES, nil);
        self.saveAccountHandler = nil;
    }
}

- (NSArray*)accounts {
    
    NSArray* accountsKeys = [self getArrayForKey:@"Accounts"];
    
    NSMutableArray* accounts = [[NSMutableArray alloc] init];
    for (NSString* identifier in accountsKeys) {
        [accounts addObject:[self accountWithIdentifier:identifier]];
    }
    
    return accounts;
}


- (NSArray *)accountTypes {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    SOAccountType *accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierInstagram;
    accountType.accountTypeDescription = @"Instagram";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierFacebook;
    accountType.accountTypeDescription = @"Facebook";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierTwitter;
    accountType.accountTypeDescription = @"Twitter";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierGooglePlus;
    accountType.accountTypeDescription = @"Google Plus";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierVine;
    accountType.accountTypeDescription = @"Vine";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierTumblr;
    accountType.accountTypeDescription = @"Tumblr";
    [array addObject:accountType];

    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierLinkedIn;
    accountType.accountTypeDescription = @"LinkedIn";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierAppNet;
    accountType.accountTypeDescription = @"App.Net";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierFoursquare;
    accountType.accountTypeDescription = @"Foursquare";
    [array addObject:accountType];

    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierVoto;
    accountType.accountTypeDescription = @"Voto";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierGithub;
    accountType.accountTypeDescription = @"Github";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifier500px;
    accountType.accountTypeDescription = @"500px";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierDribbble;
    accountType.accountTypeDescription = @"Dribbble";
    [array addObject:accountType];
    
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierPinterest;
    accountType.accountTypeDescription = @"Pinterest";
    [array addObject:accountType];
    
    return array;
}

- (SOAccountType *)accountTypeWithAccountTypeIdentifier:(NSString *)typeIdentifier {
    NSArray* types = [self accountTypes];
    for (SOAccountType* service in types) {
        if ([typeIdentifier isEqualToString:service.identifier]) {
            return service;
        }
    }
    
    return nil;
}

- (void)requestAccessToAccountsWithType:(SOAccountType *)accountType
                                options:(NSDictionary *)options
                             completion:(SOAccountStoreSaveCompletionHandler)completion {
  
    @throw[NSException exceptionWithName:NSInvalidArgumentException
                                      reason:@"accountType is not valid"
                                    userInfo:nil];
}

- (void)clearStore {
    [self setArray:@[] forKey:@"Accounts"];
}

- (BOOL)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
	if (dictionary == nil || key == nil) {
		return NO;
	}
	
	key = [NSString stringWithFormat:@"%@ - %@", @"SocialAccounts", key];
    
	// First check if it already exists, by creating a search dictionary and requesting that
	// nothing be returned, and performing the search anyway.
	NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
	
    NSString* error = nil;
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	existsQueryDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	
	// Add the keys to the search dict
	existsQueryDictionary[(__bridge id)kSecAttrService] = @"service";
	existsQueryDictionary[(__bridge id)kSecAttrAccount] = key;
    
    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef) existsQueryDictionary, NULL);
    
	if (res == errSecItemNotFound) {
		if (dictionary != nil) {
			NSMutableDictionary *addDict = existsQueryDictionary;
			addDict[(__bridge id)kSecValueData] = data;
            
			res = SecItemAdd((__bridge CFDictionaryRef)addDict, NULL);
			NSAssert1(res == errSecSuccess, @"Recieved %ld from SecItemAdd!", res);
		}
	} else if (res == errSecSuccess) {
		// Modify an existing one
		// Actually pull it now of the keychain at this point.
		NSDictionary *attributeDict = @{(__bridge id)kSecValueData: data};
		res = SecItemUpdate((__bridge CFDictionaryRef)existsQueryDictionary, (__bridge CFDictionaryRef)attributeDict);
		NSAssert1(res == errSecSuccess, @"SecItemUpdated returned %ld!", res);
	} else {
		NSAssert1(NO, @"Received %ld from SecItemCopyMatching!", res);
	}
	return YES;
}

- (NSDictionary*)getDictionaryForKey:(NSString*)key
{
	key = [NSString stringWithFormat:@"%@ - %@", @"SocialAccounts", key];

	NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
	existsQueryDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	
	// Add the keys to the search dict
	existsQueryDictionary[(__bridge id)kSecAttrService] = @"service";
	existsQueryDictionary[(__bridge id)kSecAttrAccount] = key;
	
	// We want the data back!
	CFTypeRef data = nil;
	
	existsQueryDictionary[(__bridge id)kSecReturnData] = (id)kCFBooleanTrue;
    
	OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)existsQueryDictionary, &data);
    
	if (res == errSecSuccess) {
        NSString* error = nil;

        NSDictionary *dictionary = [NSPropertyListSerialization propertyListFromData:(__bridge NSData*)data mutabilityOption:NSPropertyListImmutable format:nil errorDescription:&error];

		return dictionary;
	} else {
		NSAssert1(res == errSecItemNotFound, @"SecItemCopyMatching returned %ld!", res);
	}
	
	return nil;
}


- (BOOL)setArray:(NSArray*)array forKey:(NSString*)key
{
	if (array == nil || key == nil) {
		return NO;
	}
	
	key = [NSString stringWithFormat:@"%@ - %@", @"SocialAccounts", key];
    
	// First check if it already exists, by creating a search dictionary and requesting that
	// nothing be returned, and performing the search anyway.
	NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
	
    NSString* error = nil;
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:array format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	existsQueryDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	
	// Add the keys to the search dict
	existsQueryDictionary[(__bridge id)kSecAttrService] = @"service";
	existsQueryDictionary[(__bridge id)kSecAttrAccount] = key;
    
    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef) existsQueryDictionary, NULL);
    
	if (res == errSecItemNotFound) {
		if (array != nil) {
			NSMutableDictionary *addDict = existsQueryDictionary;
			addDict[(__bridge id)kSecValueData] = data;
            
			res = SecItemAdd((__bridge CFDictionaryRef)addDict, NULL);
			NSAssert1(res == errSecSuccess, @"Recieved %ld from SecItemAdd!", res);
		}
	} else if (res == errSecSuccess) {
		// Modify an existing one
		// Actually pull it now of the keychain at this point.
		NSDictionary *attributeDict = @{(__bridge id)kSecValueData: data};
		res = SecItemUpdate((__bridge CFDictionaryRef)existsQueryDictionary, (__bridge CFDictionaryRef)attributeDict);
		NSAssert1(res == errSecSuccess, @"SecItemUpdated returned %ld!", res);
	} else {
		NSAssert1(NO, @"Received %ld from SecItemCopyMatching!", res);
	}
	return YES;
}

- (NSArray*)getArrayForKey:(NSString*)key
{
	key = [NSString stringWithFormat:@"%@ - %@", @"SocialAccounts", key];
    
	NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
	existsQueryDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	
	// Add the keys to the search dict
	existsQueryDictionary[(__bridge id)kSecAttrService] = @"service";
	existsQueryDictionary[(__bridge id)kSecAttrAccount] = key;
	
	// We want the data back!
	CFTypeRef data = nil;
	
	existsQueryDictionary[(__bridge id)kSecReturnData] = (id)kCFBooleanTrue;
    
	OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)existsQueryDictionary, &data);
    
	if (res == errSecSuccess) {
        NSString* error = nil;
        
        NSArray *array = [NSPropertyListSerialization propertyListFromData:(__bridge NSData*)data mutabilityOption:NSPropertyListImmutable format:nil errorDescription:&error];
        
		return array;
	} else {
		NSAssert1(res == errSecItemNotFound, @"SecItemCopyMatching returned %ld!", res);
	}
	
	return nil;
}

@end
