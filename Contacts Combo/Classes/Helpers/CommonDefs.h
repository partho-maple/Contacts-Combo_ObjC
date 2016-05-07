//
//  CommonDefs.h
//  Contacts Cop
//
//  Created by Partho on 7/15/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#pragma once

#ifdef __cplusplus

#include<string>
#include<map>
#include<queue>
//#include<queue>



typedef enum E_MergingTypes
{
    NoMerging = 0,
    MergeByName,
    MergeByNumber,
    MergeByEmail
}MergingType;


typedef enum E_SyncingTypes
{
    NoSyncing = 0,
    GoogleSyncing,
    YahooSyncing,
    LinkedInSyncing,
    FacebookSyncing,
    OutlookSyncing
}SyncingTypes;





#endif  //__cplusplus
