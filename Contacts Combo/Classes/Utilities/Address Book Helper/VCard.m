/**
 * Copyright (c) 2010 Altosh
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/

#import "VCard.h"
#import "Base64.h"


@implementation VCard

//
static NSInteger itemCounter;
+ (NSInteger)itemCounter { return  itemCounter; };
+ (void)setItemCounter:(NSInteger)value { itemCounter = value; };

//
+ (NSString *)generateVCardStringWithRecID:(NSInteger)recID
{
	ABAddressBookRef addressBookRef = ABAddressBookCreate();
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBookRef, (ABRecordID)recID);
	
	NSString *vcard = [VCard generateVCardStringWithRec:person];
	
	CFRelease(addressBookRef);
	
	return vcard;
}

+ (NSString *)generateVCardStringWithRec:(ABRecordRef)rec
{
	[VCard setItemCounter:0];
	
	//
	ABContact *contact = [ABContact contactWithRecord:rec];
	
	//
	NSString *vcard = @"BEGIN:VCARD\nVERSION:3.0\n";
	
	// Name
	vcard = [vcard stringByAppendingFormat:@"N:%@;%@;%@;%@;%@\n",
			 (contact.lastname ? contact.lastname : @""),
			 (contact.firstname ? contact.firstname : @""),
			 (contact.middlename ? contact.middlename : @""),
			 (contact.prefix ? contact.prefix : @""),
			 (contact.suffix ? contact.suffix : @"")
			 ];
	
	vcard = [vcard stringByAppendingFormat:@"FN:%@\n",contact.compositeName];
	if(  contact.nickname ) vcard = [vcard stringByAppendingFormat:@"NICKNAME:%@\n",contact.nickname];
	if(  contact.firstnamephonetic ) vcard = [vcard stringByAppendingFormat:@"X-PHONETIC-FIRST-NAME:%@\n",contact.firstnamephonetic];
	if(  contact.lastnamephonetic ) vcard = [vcard stringByAppendingFormat:@"X-PHONETIC-LAST-NAME:%@\n",contact.lastnamephonetic];
	
	
	// Work
	if( contact.organization || contact.department ) vcard = [vcard stringByAppendingFormat:@"ORG:%@;%@\n",(contact.organization?contact.organization:@""),(contact.department?contact.department:@"")];
	if( contact.jobtitle ) vcard = [vcard stringByAppendingFormat:@"TITLE:%@\n",contact.jobtitle];
	
	
	// Mail
	vcard = [vcard stringByAppendingString:[VCard toVcardField:@"email" items:contact.emailArray labels:contact.emailLabels]];
	
	// Tel
	vcard = [vcard stringByAppendingString:[VCard toVcardField:@"phone" items:contact.phoneArray labels:contact.phoneLabels]];
	
	// Adress
	vcard = [vcard stringByAppendingString:[VCard toVcardField:@"address" items:contact.addressArray labels:contact.addressLabels]];
	
	// url
	vcard = [vcard stringByAppendingString:[VCard toVcardField:@"url" items:contact.urlArray labels:contact.urlLabels]];
	
	// IM
	vcard = [vcard stringByAppendingString:[VCard toVcardField:@"im" items:contact.smsArray labels:contact.smsLabels]];
	
	// birthday
	NSDate *birthday = contact.birthday;
	if (birthday)
	{
		NSString *bday = [NSString stringWithFormat:@"%@",birthday];
		NSArray *bdayArr = [bday componentsSeparatedByString:@" "];
		bday = [bdayArr objectAtIndex:0];
		
		vcard = [vcard stringByAppendingFormat:@"BDAY;value=date:%@\n",bday];
	}
	
	// Photo
	NSData *imageData = contact.thumbData;//contact.imageData;
	if (imageData)
	{
		vcard = [vcard stringByAppendingFormat:@"PHOTO;BASE64:%@\n",[imageData base64Encoding]];
	}
	
	// end
	vcard = [vcard stringByAppendingString:@"END:VCARD"];
	
	return vcard;
}

+ (NSString *)toVcardField:(NSString *)type items:(NSArray *)items labels:(NSArray *)labels
{
	if (!items)
	{
		return @"";
	}
	
	NSString *vcard = @"";
	
	if (items && [items count] > 0)
	{
		NSInteger len = [items count];
		for (int i = 0; i < len; i++)
		{
			if ([type isEqualToString:@"email"]) vcard = [vcard stringByAppendingString:[VCard emailToVcardField:[items objectAtIndex:i] label:[labels objectAtIndex:i]]];
			else if ([type isEqualToString:@"phone"]) vcard = [vcard stringByAppendingString:[VCard phoneToVcardField:[items objectAtIndex:i] label:[labels objectAtIndex:i]]];
			else if ([type isEqualToString:@"address"]) vcard = [vcard stringByAppendingString:[VCard addressToVcardField:[items objectAtIndex:i] label:[labels objectAtIndex:i]]];
			else if ([type isEqualToString:@"url"]) vcard = [vcard stringByAppendingString:[VCard urlToVcardField:[items objectAtIndex:i] label:[labels objectAtIndex:i]]];
			else if ([type isEqualToString:@"im"]) vcard = [vcard stringByAppendingString:[VCard imToVcardField:[items objectAtIndex:i] label:[labels objectAtIndex:i]]];
		}
	}
	
	return vcard;
}

+ (NSString *)emailToVcardField:(NSString *)email label:(NSString *)label
{
	NSString *labelLower = [label lowercaseString];
	NSString *vcard = @"";
	
	if ([labelLower isEqualToString:@"_$!<home>!$_"]) vcard = [NSString stringWithFormat:@"EMAIL;type=INTERNET;type=HOME:%@\n",email];
	else if ([labelLower isEqualToString:@"_$!<work>!$_"]) vcard = [NSString stringWithFormat:@"EMAIL;type=INTERNET;type=WORK:%@\n",email];
	else
	{
		NSInteger counter = [VCard itemCounter]+1;
		vcard = [NSString stringWithFormat:@"item%ld.EMAIL;type=INTERNET:%@\nitem%ld.X-ABLabel:%@\n",(long)counter,email,(long)counter,label];
		[VCard setItemCounter:counter];
	}
	
	return vcard;
}

+ (NSString *)phoneToVcardField:(NSString *)phone label:(NSString *)label
{
	//_$!<Mobile>!$_, iPhone, _$!<Home>!$_, _$!<Work>!$_, _$!<Main>!$_, _$!<HomeFAX>!$_, _$!<WorkFAX>!$_, _$!<Pager>!$_
	
	NSString *labelLower = [label lowercaseString];
	NSString *vcard = @"";
	
	if ([labelLower isEqualToString:@"_$!<mobile>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=CELL:%@\n",phone];
	else if ([labelLower isEqualToString:@"iphone"]) vcard = [NSString stringWithFormat:@"TEL;type=IPHONE:%@\n",phone];
	else if ([labelLower isEqualToString:@"_$!<home>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=HOME:%@\n",phone];
	else if ([labelLower isEqualToString:@"_$!<work>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=WORK:%@\n",phone];
	else if ([labelLower isEqualToString:@"_$!<main>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=MAIN:%@\n",phone];
	else if ([labelLower isEqualToString:@"_$!<homefax>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=HOME;type=FAX:%@\n",phone];
	else if ([labelLower isEqualToString:@"_$!<workfax>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=WORK;type=FAX:%@\n",phone];
	else if ([labelLower isEqualToString:@"_$!<pager>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=PAGER:%@\n",phone];
	else
	{
		NSInteger counter = [VCard itemCounter]+1;
		vcard = [NSString stringWithFormat:@"item%ld.TEL:%@\nitem%ld.X-ABLabel:%@\n",(long)counter,phone,(long)counter,label];
		[VCard setItemCounter:counter];
	}
	
	return vcard;
}

+ (NSString *)addressToVcardField:(NSDictionary *)address label:(NSString *)label
{
	NSString *vcard = @"";
	NSString *labelField = @"";
	NSString *labelLower = [label lowercaseString];
	NSString *type = @"HOME";
	
	NSInteger counter = [VCard itemCounter]+1;
	
	//
	if([labelLower isEqualToString:@"_$!<work>!$_"]) type = @"WORK";
	else if([labelLower isEqualToString:@"_$!<home>!$_"]) {}
	else if( label && [label length] > 0 )
	{
		labelField = [NSString stringWithFormat:@"item%ld.X-ABLabel:%@\n",(long)counter,label];
	}
	
	//
	NSString *street = [address objectForKey:@"Street"] ? [address objectForKey:@"Street"] : @"";
	if ([street rangeOfString:@"\n"].location != NSNotFound)
	{
		NSArray *arr = [street componentsSeparatedByString:@"\n"];
		street = [arr componentsJoinedByString:@"\\n"];
	}
	
	NSString *City = [address objectForKey:@"City"] ? [address objectForKey:@"City"] : @"";
	NSString *State = [address objectForKey:@"State"] ? [address objectForKey:@"State"] : @"";
	NSString *ZIP = [address objectForKey:@"ZIP"] ? [address objectForKey:@"ZIP"] : @"";
	NSString *Country = [address objectForKey:@"Country"] ? [address objectForKey:@"Country"] : @"";
	NSString *CountryCode = [address objectForKey:@"CountryCode"] ? [address objectForKey:@"CountryCode"] : @"";
	
	
	//
	vcard = [NSString stringWithFormat:@"item%ld.ADR;type=%@:;;%@;%@;%@;%@;%@\n%@item%ld.X-ABADR:%@\n",
			 (long)counter,
			 type,
			 street,
			 City,
			 State,
			 ZIP,
			 Country,
			 labelField,
			 (long)counter,
			 CountryCode
			 ];
	
	//
	[VCard setItemCounter:counter];
	
	return vcard;
}

+ (NSString *)urlToVcardField:(NSString *)url label:(NSString *)label
{
	NSString *labelLower = [label lowercaseString];
	NSString *vcard = @"";
	
	if ([labelLower isEqualToString:@"_$!<home>!$_"]) vcard = [NSString stringWithFormat:@"URL;type=HOME:%@\n",url];
	else if ([labelLower isEqualToString:@"_$!<work>!$_"]) vcard = [NSString stringWithFormat:@"URL;type=WORK:%@\n",url];
	else
	{
		NSInteger counter = [VCard itemCounter]+1;
		vcard = [NSString stringWithFormat:@"item%ld.URL:%@\nitem%ld.X-ABLabel:%@\n",(long)counter,url,(long)counter,label];
		[VCard setItemCounter:counter];
	}
	
	return vcard;
}

+ (NSString *)imToVcardField:(NSDictionary *)im label:(NSString *)label
{
	NSString *labelLower = [label lowercaseString];
	NSString *vcard = @"";
	
	NSString *service = [im objectForKey:@"service"] ? [im objectForKey:@"service"] : @"";
	service = [service uppercaseString];
	
	NSString *username = [im objectForKey:@"username"] ? [im objectForKey:@"username"] : @"";
	
	//
	if ([labelLower isEqualToString:@"_$!<home>!$_"] || [labelLower isEqualToString:@"_$!<work>!$_"])
	{
		NSString *type = [labelLower isEqualToString:@"_$!<home>!$_"] ? @"HOME" : @"WORK";
		vcard = [NSString stringWithFormat:@"X-%@;type=%@:%@\n",service,type,username];
	}
	
	else
	{
		NSInteger counter = [VCard itemCounter]+1;
		vcard = [NSString stringWithFormat:@"item%ld.X-%@:%@\nitem%ld.X-ABLabel:%@\n",(long)counter,service,username,(long)counter,label];
		[VCard setItemCounter:counter];
	}
	
	return vcard;
}

@end
