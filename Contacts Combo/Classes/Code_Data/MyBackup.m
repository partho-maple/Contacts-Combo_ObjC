//
//  MyBackup.m
//  Contacts Cop
//
//  Created by Partho on 8/23/14.
//  Copyright (c) 2014 www.ParthoBIswas.com. All rights reserved.
//

#import "MyBackup.h"


@implementation MyBackup

@dynamic backupType;
@dynamic backupCriteria;
@dynamic backupSize;
@dynamic backedUpContactsCount;
@dynamic backupTime;
@dynamic backupDate;
@dynamic backupFileURL;
@dynamic vCardStringFull;
@dynamic backupFileName;

-(void) awakeFromInsert {
    [super awakeFromInsert];
    
    //    TODO: Need to init all properties
    NSDate *now = [NSDate date];
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd/"];
    NSString *currentDate=[[NSString alloc]initWithString:[df stringFromDate:now]];
//    NSDate *currenrDateFromString = [df dateFromString:currentDate];
    
        
    NSString *dateAndTimeString;
    NSDate *now2 = [NSDate date];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy/MM/dd/"];
    dateAndTimeString = [dateFormatter2 stringFromDate:now2];

    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    
    
    /*
     Printing description of currenrDateFromString:
     2014-09-07 18:00:00 +0000
     Printing description of currentTime:
     1:41:16 AM
    */
//    self.backupDate = currenrDateFromString;
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yyyy/MM/dd/"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter3 dateFromString:dateAndTimeString];
    self.backupDate = currentDate;
    
    
    self.backupTime = currentTime;
    self.backupType = @"Local";
    self.backupCriteria = @"Full Backup";
    self.backupSize = @"0 KB";
    self.backedUpContactsCount = [NSNumber numberWithInt:0];
    self.backupFileURL = @"";
    self.vCardStringFull = @"";
    self.backupFileName = @"";
    
}


@end
