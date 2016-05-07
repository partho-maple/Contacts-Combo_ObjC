//
//  GlobalConstants.h
//  Platinum Dialer
//
//  Created by Partho Biswas on 2/23/14.
//  Copyright (c) 2014 Code Knight Solutions Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>



//  Global Constants

#define ITUNES_LINK_CONTACTS_COMBO @"[LINK]"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define barButtonBackgroundColor02 [UIColor colorWithRed:111.0f/255.0f green:171.0f/255.0f blue:209.0f/255.0f alpha:1.0f]

#define backgroundColorGradientTop02 [UIColor colorWithRed:83/255.0 green:131/255.0 blue:188/255.0 alpha:1.0]

#define backgroundColorGradientTop [UIColor colorWithRed:162/255.0 green:212/255.0 blue:255/255.0 alpha:1.0]

#define backgroundColorGradientBottom [UIColor whiteColor]

#define callHistoryOutgoingColor [UIColor colorWithRed:8/255.0 green:127/255.0 blue:255/255.0 alpha:1.0]


#define CONTACTS_SORT_KEY @"fullName" // OR firstName, fullName

#define APP_NAME @"Contacts Combo"
#define APP_VERSION @"Version 1.0.0"
#define COMPANY_NAME @"CodeClef Software Inc."
#define COMPANY_URL @"www.ParthoBiswas.com"


#define gmailID @"codemen.partho@gmail.com"
#define gmailpass @"c0d3men#"


#define FEEDBACK_EMAIL_lID @"partho.maple@gmail.com"


#define DROPBOX_APP_KEY @"xlyq2bmkk3cph19"
#define DROPBOX_APP_SECRET @"cf9ag4y7njs5xz1"
#define DROPBOX_ROOT kDBRootDropbox  // either kDBRootAppFolder or kDBRootDropbox


// constants for Googlw Client API authentication
static NSString *const kKeychainItemName = @"Contacts Combo";
static NSString *const kClientID = @"78217048714-sn0q727ckhrdfn9s77m5s9kain8upkng.apps.googleusercontent.com";
static NSString *const kClientSecret = @"5O9vA9n7aoSnEN8cknVLYlF-";



@interface GlobalConstants : NSObject

@end
