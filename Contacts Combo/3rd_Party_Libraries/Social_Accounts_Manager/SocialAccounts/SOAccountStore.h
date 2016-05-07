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
#import "SOAccount.h"

// Options dictionary keys for OAuth2 service providers
ACCOUNTS_EXTERN NSString * const SOOAuth2ClientID;            // Your OAuth2 Client ID, as it appears on the service provider website. (required)
ACCOUNTS_EXTERN NSString * const SOOAuth2ClientSecret;            // Your OAuth2 Client Secret, as it appears on the service provider website. (required)
ACCOUNTS_EXTERN NSString * const SOOAuth2RedirectURI;            // Your OAuth2 Redirect URI, as it appears on the service provider website. (required)

// Options dictionary keys for OAuth1 service providers
ACCOUNTS_EXTERN NSString * const SOOAuth1ClientID;            // Your OAuth1 Client ID, as it appears on the service provider website. (required)
ACCOUNTS_EXTERN NSString * const SOOAuth1ClientSecret;            // Your OAuth1 Client Secret, as it appears on the service provider website. (required)
ACCOUNTS_EXTERN NSString * const SOOAuth1RedirectURI;            // Your OAuth1 Redirect URI, as it appears on the service provider website. (required)


typedef void(^SOAccountStoreSaveCompletionHandler)(BOOL success, NSError *error);

@protocol SOBaseAuthController <NSObject>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (void)dismissModalViewControllerAnimated:(BOOL)animated;
- (void)dismiss:(id)sender;

@end

@interface SOAccountStore : NSObject

@property (readonly, strong) NSArray* accountTypes;

// An array of all the accounts in an account database
@property (readonly, weak, nonatomic) NSArray *accounts;

// Returns the account matching the given account identifier
- (SOAccount *)accountWithIdentifier:(NSString *)identifier;

// Returns the account type object matching the account type identifier. See
// SOAccountType.h for well known account type identifiers
- (SOAccountType *)accountTypeWithAccountTypeIdentifier:(NSString *)typeIdentifier;

// Saves the account to the account database. If the account is unauthenticated and the associated account
// type supports authentication, the system will attempt to authenticate with the credentials provided.
// Assuming a successful authentication, the account will be saved to the account store. The completion handler
// for this method is called on an arbitrary queue.
- (void)saveAccount:(SOAccount *)account withCompletionHandler:(SOAccountStoreSaveCompletionHandler)completionHandler;

// Removes the account from the account database
- (void)removeAccount:(SOAccount *)account withCompletionHandler:(SOAccountStoreSaveCompletionHandler)completionHandler;

// Obtains permission, if necessary, from the user to access protected properties, and utilize accounts
// of a particular type in protected operations, for example OAuth signing. The completion handler for
// this method is called on an arbitrary queue.
// Certain account types (such as Facebook) require an options dictionary. A list of the required keys
// appears at the top of this file. This method will throw an NSInvalidArgumentException if the options
// dictionary is not provided for such account types. Conversely, if the account type does not require
// an options dictionary, the options parameter must be nil.
- (void)requestAccessToAccountsWithType:(SOAccountType *)accountType
                                options:(NSDictionary *)options
                             completion:(SOAccountStoreSaveCompletionHandler)completion;

// Clears the account database, including any saved accounts
- (void)clearStore;

@end
