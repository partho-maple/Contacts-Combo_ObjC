/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "ABContact.h"
#import "ABContactsHelper.h"

@implementation ABContact
@synthesize record;

// Thanks to Quentarez, Ciaran
- (id) initWithRecord: (ABRecordRef) aRecord
{
	if (self = [super init]) record = aRecord;
	return self;
}

+ (id) contactWithRecord: (ABRecordRef) person
{
	return [[ABContact alloc] initWithRecord:person];
}

+ (id) contactWithRecordID: (ABRecordID) recordID
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	ABRecordRef contactrec = ABAddressBookGetPersonWithRecordID(addressBook, recordID);
	ABContact *contact = [self contactWithRecord:contactrec];
	// CFRelease(contactrec); // Thanks Gary Fung
	return contact;
}

// Thanks to Ciaran
+ (id) contact
{
	ABRecordRef person = ABPersonCreate();
	id contact = [ABContact contactWithRecord:person];
	CFRelease(person);
	return contact;
}

- (void) dealloc
{
	if (record) CFRelease(record);
	[super dealloc];
}

#pragma mark utilities
+ (NSString *) localizedPropertyName: (ABPropertyID) aProperty
{
	return (NSString *)ABPersonCopyLocalizedPropertyName(aProperty);
}

+ (ABPropertyType) propertyType: (ABPropertyID) aProperty
{
	return ABPersonGetTypeOfProperty(aProperty);
}

// Thanks to Eridius for suggestions re switch
+ (NSString *) propertyTypeString: (ABPropertyID) aProperty
{
	switch (ABPersonGetTypeOfProperty(aProperty))
	{
		case kABInvalidPropertyType: return @"Invalid Property";
		case kABStringPropertyType: return @"String";
		case kABIntegerPropertyType: return @"Integer";
		case kABRealPropertyType: return @"Float";
		case kABDateTimePropertyType: return @"Date";
		case kABDictionaryPropertyType: return @"Dictionary";
		case kABMultiStringPropertyType: return @"Multi String";
		case kABMultiIntegerPropertyType: return @"Multi Integer";
		case kABMultiRealPropertyType: return @"Multi Float";
		case kABMultiDateTimePropertyType: return @"Multi Date";
		case kABMultiDictionaryPropertyType: return @"Multi Dictionary";
		default: return @"Invalid Property";
	}
}

+ (NSString *) propertyString: (ABPropertyID) aProperty
{
	/* switch (aProperty) // Sorry, this won't compile
	{
		case kABPersonFirstNameProperty: return @"First Name";
		case kABPersonLastNameProperty: return @"Last Name";
		case kABPersonMiddleNameProperty: return @"Middle Name";
		case kABPersonPrefixProperty: return @"Prefix";
		case kABPersonSuffixProperty: return @"Suffix";
		case kABPersonNicknameProperty: return @"Nickname";
		case kABPersonFirstNamePhoneticProperty: return @"Phonetic First Name";
		case kABPersonLastNamePhoneticProperty: return @"Phonetic Last Name";
		case kABPersonMiddleNamePhoneticProperty: return @"Phonetic Middle Name";
		case kABPersonOrganizationProperty: return @"Organization";
		case kABPersonJobTitleProperty: return @"Job Title";
		case kABPersonDepartmentProperty: return @"Department";
		case kABPersonEmailProperty: return @"Email";
		case kABPersonBirthdayProperty: return @"Birthday";
		case kABPersonNoteProperty: return @"Note";
		case kABPersonCreationDateProperty: return @"Creation Date";
		case kABPersonModificationDateProperty: return @"Modification Date";
		case kABPersonAddressProperty: return @"Address";
		case kABPersonDateProperty: return @"Date";
		case kABPersonKindProperty: return @"Kind";
		case kABPersonPhoneProperty: return @"Phone";
		case kABPersonInstantMessageProperty: return @"Instant Message";
		case kABPersonURLProperty: return @"URL";
		case kABPersonRelatedNamesProperty: return @"Related Name";			
	} */
	
	if (aProperty == kABPersonFirstNameProperty) return @"First Name";
	if (aProperty == kABPersonLastNameProperty) return @"Last Name";
	if (aProperty == kABPersonMiddleNameProperty) return @"Middle Name";
	if (aProperty == kABPersonPrefixProperty) return @"Prefix";
	if (aProperty == kABPersonSuffixProperty) return @"Suffix";
	if (aProperty == kABPersonNicknameProperty) return @"Nickname";
	if (aProperty == kABPersonFirstNamePhoneticProperty) return @"Phonetic First Name";
	if (aProperty == kABPersonLastNamePhoneticProperty) return @"Phonetic Last Name";
	if (aProperty == kABPersonMiddleNamePhoneticProperty) return @"Phonetic Middle Name";
	if (aProperty == kABPersonOrganizationProperty) return @"Organization";
	if (aProperty == kABPersonJobTitleProperty) return @"Job Title";
	if (aProperty == kABPersonDepartmentProperty) return @"Department";
	if (aProperty == kABPersonEmailProperty) return @"Email";
	if (aProperty == kABPersonBirthdayProperty) return @"Birthday";
	if (aProperty == kABPersonNoteProperty) return @"Note";
//	if (aProperty == kABPersonCreationDateProperty) return @"Creation Date";
    if (aProperty == kABPersonSocialProfileProperty) return @"Social Profile";
	if (aProperty == kABPersonModificationDateProperty) return @"Modification Date";
	if (aProperty == kABPersonAddressProperty) return @"Address";
	if (aProperty == kABPersonDateProperty) return @"Date";
	if (aProperty == kABPersonKindProperty) return @"Kind";
	if (aProperty == kABPersonPhoneProperty) return @"Phone";
	if (aProperty == kABPersonInstantMessageProperty) return @"Instant Message";
	if (aProperty == kABPersonURLProperty) return @"URL";
	if (aProperty == kABPersonRelatedNamesProperty) return @"Related Name";
	return nil;
}

+ (ABPropertyID) propertyNameFromString: (NSString *) aPropertyNameString
{
    if ([aPropertyNameString isEqualToString:@"First Name"]) return kABPersonFirstNameProperty;
    if ([aPropertyNameString isEqualToString:@"Last Name"]) return kABPersonLastNameProperty;
    if ([aPropertyNameString isEqualToString:@"Middle Name"]) return kABPersonMiddleNameProperty;
    if ([aPropertyNameString isEqualToString:@"Prefix"]) return kABPersonPrefixProperty;
    if ([aPropertyNameString isEqualToString:@"Suffix"]) return kABPersonSuffixProperty;
    if ([aPropertyNameString isEqualToString:@"Nickname"]) return kABPersonNicknameProperty;
    if ([aPropertyNameString isEqualToString:@"Phonetic First Name"]) return kABPersonFirstNamePhoneticProperty;
    if ([aPropertyNameString isEqualToString:@"Phonetic Last Name"]) return kABPersonLastNamePhoneticProperty;
    if ([aPropertyNameString isEqualToString:@"Phonetic Middle Name"]) return kABPersonMiddleNamePhoneticProperty;
    if ([aPropertyNameString isEqualToString:@"Organization"]) return kABPersonOrganizationProperty;
    if ([aPropertyNameString isEqualToString:@"Job Title"]) return kABPersonJobTitleProperty;
    if ([aPropertyNameString isEqualToString:@"Department"]) return kABPersonDepartmentProperty;
    if ([aPropertyNameString isEqualToString:@"Email"]) return kABPersonEmailProperty;
    if ([aPropertyNameString isEqualToString:@"Birthday"]) return kABPersonBirthdayProperty;
    if ([aPropertyNameString isEqualToString:@"Note"]) return kABPersonNoteProperty;
    if ([aPropertyNameString isEqualToString:@"Social Profile"]) return kABPersonSocialProfileProperty;
    if ([aPropertyNameString isEqualToString:@"Modification Date"]) return kABPersonModificationDateProperty;
    if ([aPropertyNameString isEqualToString:@"Address"]) return kABPersonAddressProperty;
    if ([aPropertyNameString isEqualToString:@"Date"]) return kABPersonDateProperty;
    if ([aPropertyNameString isEqualToString:@"Kind"]) return kABPersonKindProperty;
    if ([aPropertyNameString isEqualToString:@"Phone"]) return kABPersonPhoneProperty;
    if ([aPropertyNameString isEqualToString:@"Instant Message"]) return kABPersonInstantMessageProperty;
    if ([aPropertyNameString isEqualToString:@"URL"]) return kABPersonURLProperty;
    if ([aPropertyNameString isEqualToString:@"Related Name"]) return kABPersonRelatedNamesProperty;

	return -1;
}

+ (BOOL) propertyIsMultivalue: (ABPropertyID) aProperty;
{
	if (aProperty == kABPersonFirstNameProperty) return NO;
	if (aProperty == kABPersonLastNameProperty) return NO;
	if (aProperty == kABPersonMiddleNameProperty) return NO;
	if (aProperty == kABPersonPrefixProperty) return NO;
	if (aProperty == kABPersonSuffixProperty) return NO;
	if (aProperty == kABPersonNicknameProperty) return NO;
	if (aProperty == kABPersonFirstNamePhoneticProperty) return NO;
	if (aProperty == kABPersonLastNamePhoneticProperty) return NO;
	if (aProperty == kABPersonMiddleNamePhoneticProperty) return NO;
	if (aProperty == kABPersonOrganizationProperty) return NO;
	if (aProperty == kABPersonJobTitleProperty) return NO;
	if (aProperty == kABPersonDepartmentProperty) return NO;
	if (aProperty == kABPersonBirthdayProperty) return NO;
	if (aProperty == kABPersonNoteProperty) return NO;
	if (aProperty == kABPersonCreationDateProperty) return NO;
	if (aProperty == kABPersonModificationDateProperty) return NO;
	
	return YES;
	/*
	if (aProperty == kABPersonEmailProperty) return YES;
	if (aProperty == kABPersonAddressProperty) return YES;
	if (aProperty == kABPersonDateProperty) return YES;
	if (aProperty == kABPersonPhoneProperty) return YES;
	if (aProperty == kABPersonInstantMessageProperty) return YES;
	if (aProperty == kABPersonURLProperty) return YES;
	if (aProperty == kABPersonRelatedNamesProperty) return YES;
	 */
}

+ (NSArray *) arrayForProperty: (ABPropertyID) anID inRecord: (ABRecordRef) record
{
	// Recover the property for a given record
	CFTypeRef theProperty = ABRecordCopyValue(record, anID);
	NSArray *items = (NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty);
//	CFRelease(theProperty);
	return items;
}

+ (id) objectForProperty: (ABPropertyID) anID inRecord: (ABRecordRef) record
{
    id val = nil;
    @try {
        val = (id) ABRecordCopyValue(record, anID);
    }
    @catch (NSException *NSException) {
        NSLog(@"NSException: %@", NSException);
        NSLog(@"Val: %@", val);
        val = nil;
    }
    
    if (val == nil) {
        NSLog(@"Nill ref got...");
    }
    NSLog(@"Val: %@", val);
	return (id) ABRecordCopyValue(record, anID);
}

+ (NSDictionary *) dictionaryWithValue: (id) value andLabel: (CFStringRef) label
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	if (value) [dict setObject:value forKey:@"value"];
	if (label) [dict setObject:(NSString *)label forKey:@"label"];
	return dict;
}

+ (NSDictionary *) addressWithStreet: (NSString *) street withCity: (NSString *) city
						   withState:(NSString *) state withZip: (NSString *) zip
						 withCountry: (NSString *) country withCode: (NSString *) code
{
	NSMutableDictionary *md = [NSMutableDictionary dictionary];
	if (street) [md setObject:street forKey:(NSString *) kABPersonAddressStreetKey];
	if (city) [md setObject:city forKey:(NSString *) kABPersonAddressCityKey];
	if (state) [md setObject:state forKey:(NSString *) kABPersonAddressStateKey];
	if (zip) [md setObject:zip forKey:(NSString *) kABPersonAddressZIPKey];
	if (country) [md setObject:country forKey:(NSString *) kABPersonAddressCountryKey];
	if (code) [md setObject:code forKey:(NSString *) kABPersonAddressCountryCodeKey];
	return md;
}

+ (NSDictionary *) smsWithService: (CFStringRef) service andUser: (NSString *) userName
{
	NSMutableDictionary *sms = [NSMutableDictionary dictionary];
	if (service) [sms setObject:(NSString *) service forKey:(NSString *) kABPersonInstantMessageServiceKey];
	if (userName) [sms setObject:userName forKey:(NSString *) kABPersonInstantMessageUsernameKey];
	return sms;
}

// Thanks to Eridius for suggestions re: error
- (BOOL) removeSelfFromAddressBook: (NSError **) error
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	if (!ABAddressBookRemoveRecord(addressBook, self.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook,  (CFErrorRef *) error);
}

#pragma mark Record ID and Type
- (ABRecordID) recordID {return ABRecordGetRecordID(record);}
- (ABRecordType) recordType {return ABRecordGetRecordType(record);}
- (BOOL) isPerson {return self.recordType == kABPersonType;}

#pragma mark Getting Single Value Strings
- (NSString *) getRecordString:(ABPropertyID) anID
{
	return (NSString *) ABRecordCopyValue(record, anID);
}
- (NSString *) firstname {return [self getRecordString:kABPersonFirstNameProperty];}
- (NSString *) lastname {return [self getRecordString:kABPersonLastNameProperty];}
- (NSString *) middlename {return [self getRecordString:kABPersonMiddleNameProperty];}
- (NSString *) prefix {return [self getRecordString:kABPersonPrefixProperty];}
- (NSString *) suffix {return [self getRecordString:kABPersonSuffixProperty];}
- (NSString *) nickname {return [self getRecordString:kABPersonNicknameProperty];}
- (NSString *) firstnamephonetic {return [self getRecordString:kABPersonFirstNamePhoneticProperty];}
- (NSString *) lastnamephonetic {return [self getRecordString:kABPersonLastNamePhoneticProperty];}
- (NSString *) middlenamephonetic {return [self getRecordString:kABPersonMiddleNamePhoneticProperty];}
- (NSString *) organization {return [self getRecordString:kABPersonOrganizationProperty];}
- (NSString *) jobtitle {return [self getRecordString:kABPersonJobTitleProperty];}
- (NSString *) department {return [self getRecordString:kABPersonDepartmentProperty];}
- (NSString *) note {return [self getRecordString:kABPersonNoteProperty];}

#pragma mark Contact Name Utility
- (NSString *) contactName
{
	NSMutableString *string = [NSMutableString string];
	
	if (self.firstname || self.lastname)
	{
		if (self.prefix) [string appendFormat:@"%@ ", self.prefix];
		if (self.firstname) [string appendFormat:@"%@ ", self.firstname];
		if (self.nickname) [string appendFormat:@"\"%@\" ", self.nickname];
		if (self.lastname) [string appendFormat:@"%@", self.lastname];
		
		if (self.suffix && string.length)
			[string appendFormat:@", %@ ", self.suffix];
		else
			[string appendFormat:@" "];
	}
	
	if (self.organization) [string appendString:self.organization];
	return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) compositeName
{
	NSString *string = (NSString *)ABRecordCopyCompositeName(record);
	return string;
}

#pragma mark Dates
- (NSDate *) getRecordDate:(ABPropertyID) anID
{
	return (NSDate *) ABRecordCopyValue(record, anID);
}

- (NSDate *) birthday {return [self getRecordDate:kABPersonBirthdayProperty];}
- (NSDate *) creationDate {return [self getRecordDate:kABPersonCreationDateProperty];}
- (NSDate *) modificationDate {return [self getRecordDate:kABPersonModificationDateProperty];}

#pragma mark Getting MultiValue Elements
- (NSArray *) arrayForProperty: (ABPropertyID) anID
{
	CFTypeRef theProperty = ABRecordCopyValue(record, anID);
	NSArray *items = (NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty);
	CFRelease(theProperty);
	return items;
}

- (NSArray *) labelsForProperty: (ABPropertyID) anID
{
	CFTypeRef theProperty = ABRecordCopyValue(record, anID);
	NSMutableArray *labels = [NSMutableArray array];
	for (int i = 0; i < ABMultiValueGetCount(theProperty); i++)
	{
		NSString *label = (NSString *)ABMultiValueCopyLabelAtIndex(theProperty, i);
		[labels addObject:(label ? label : @"")];
		[label release];
	}
	CFRelease(theProperty);
	return labels;
}

- (NSArray *) emailArray {return [self arrayForProperty:kABPersonEmailProperty];}
- (NSArray *) emailLabels {return [self labelsForProperty:kABPersonEmailProperty];}
- (NSArray *) phoneArray {return [self arrayForProperty:kABPersonPhoneProperty];}
- (NSArray *) phoneLabels {return [self labelsForProperty:kABPersonPhoneProperty];}
- (NSArray *) relatedNameArray {return [self arrayForProperty:kABPersonRelatedNamesProperty];}
- (NSArray *) relatedNameLabels {return [self labelsForProperty:kABPersonRelatedNamesProperty];}
- (NSArray *) urlArray {return [self arrayForProperty:kABPersonURLProperty];}
- (NSArray *) urlLabels {return [self labelsForProperty:kABPersonURLProperty];}
- (NSArray *) dateArray {return [self arrayForProperty:kABPersonDateProperty];}
- (NSArray *) dateLabels {return [self labelsForProperty:kABPersonDateProperty];}
- (NSArray *) addressArray {return [self arrayForProperty:kABPersonAddressProperty];}
- (NSArray *) addressLabels {return [self labelsForProperty:kABPersonAddressProperty];}
- (NSArray *) smsArray {return [self arrayForProperty:kABPersonInstantMessageProperty];}
- (NSArray *) smsLabels {return [self labelsForProperty:kABPersonInstantMessageProperty];}

- (NSString *) phonenumbers {return [self.phoneArray componentsJoinedByString:@" "];}
- (NSString *) emailaddresses {return [self.emailArray componentsJoinedByString:@" "];}
- (NSString *) urls {return [self.urlArray componentsJoinedByString:@" "];}

- (NSArray *) dictionaryArrayForProperty: (ABPropertyID) aProperty
{
	NSArray *valueArray = [self arrayForProperty:aProperty];
	NSArray *labelArray = [self labelsForProperty:aProperty];
	
	int num = MIN(valueArray.count, labelArray.count);
	NSMutableArray *items = [NSMutableArray array];
	for (int i = 0; i < num; i++)
	{
		NSMutableDictionary *md = [NSMutableDictionary dictionary];
		[md setObject:[valueArray objectAtIndex:i] forKey:@"value"];
		[md setObject:[labelArray objectAtIndex:i] forKey:@"label"];
		[items addObject:md];
	}
	return items;
}

- (NSArray *) emailDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonEmailProperty];
}

- (NSArray *) phoneDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonPhoneProperty];
}

- (NSArray *) relatedNameDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonRelatedNamesProperty];
}

- (NSArray *) urlDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonURLProperty];
}

- (NSArray *) dateDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonDateProperty];
}

- (NSArray *) addressDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonAddressProperty];
}

- (NSArray *) smsDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonInstantMessageProperty];
}

#pragma mark Setting Strings
- (BOOL) setString: (NSString *) aString forProperty:(ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, (CFStringRef) aString, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

- (void) setFirstname: (NSString *) aString {[self setString: aString forProperty: kABPersonFirstNameProperty];}
- (void) setLastname: (NSString *) aString {[self setString: aString forProperty: kABPersonLastNameProperty];}
- (void) setMiddlename: (NSString *) aString {[self setString: aString forProperty: kABPersonMiddleNameProperty];}
- (void) setPrefix: (NSString *) aString {[self setString: aString forProperty: kABPersonPrefixProperty];}
- (void) setSuffix: (NSString *) aString {[self setString: aString forProperty: kABPersonSuffixProperty];}
- (void) setNickname: (NSString *) aString {[self setString: aString forProperty: kABPersonNicknameProperty];}
- (void) setFirstnamephonetic: (NSString *) aString {[self setString: aString forProperty: kABPersonFirstNamePhoneticProperty];}
- (void) setLastnamephonetic: (NSString *) aString {[self setString: aString forProperty: kABPersonLastNamePhoneticProperty];}
- (void) setMiddlenamephonetic: (NSString *) aString {[self setString: aString forProperty: kABPersonMiddleNamePhoneticProperty];}
- (void) setOrganization: (NSString *) aString {[self setString: aString forProperty: kABPersonOrganizationProperty];}
- (void) setJobtitle: (NSString *) aString {[self setString: aString forProperty: kABPersonJobTitleProperty];}
- (void) setDepartment: (NSString *) aString {[self setString: aString forProperty: kABPersonDepartmentProperty];}
- (void) setNote: (NSString *) aString {[self setString: aString forProperty: kABPersonNoteProperty];}

#pragma mark Setting Dates

- (BOOL) setDate: (NSDate *) aDate forProperty:(ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, (CFDateRef) aDate, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

- (void) setBirthday: (NSDate *) aDate {[self setDate: aDate forProperty: kABPersonBirthdayProperty];}

#pragma mark Setting MultiValue

- (BOOL) setMulti: (ABMutableMultiValueRef) multi forProperty: (ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, multi, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

- (ABMutableMultiValueRef) createMultiValueFromArray: (NSArray *) anArray withType: (ABPropertyType) aType
{
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(aType);
	for (NSDictionary *dict in anArray)
		ABMultiValueAddValueAndLabel(multi, (CFTypeRef) [dict objectForKey:@"value"], (CFTypeRef) [dict objectForKey:@"label"], NULL);
	return multi;
}

- (void) setEmailDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABPersonEmailProperty];
	CFRelease(multi);
}

- (void) setPhoneDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonPhoneMobileLabel, kABPersonPhoneIPhoneLabel, kABPersonPhoneMainLabel
	// kABPersonPhoneHomeFAXLabel, kABPersonPhoneWorkFAXLabel, kABPersonPhonePagerLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABPersonPhoneProperty];
	CFRelease(multi);
}

- (void) setUrlDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonHomePageLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABPersonURLProperty];
	CFRelease(multi);
}

// Not used/shown on iPhone
- (void) setRelatedNameDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonMotherLabel, kABPersonFatherLabel, kABPersonParentLabel, 
	// kABPersonSisterLabel, kABPersonBrotherLabel, kABPersonChildLabel, 
	// kABPersonFriendLabel, kABPersonSpouseLabel, kABPersonPartnerLabel, 
	// kABPersonManagerLabel, kABPersonAssistantLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABPersonRelatedNamesProperty];
}

- (void) setDateDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonAnniversaryLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiDateTimePropertyType];
	[self setMulti:multi forProperty:kABPersonDateProperty];
	CFRelease(multi);
}

- (void) setAddressDictionaries: (NSArray *) dictionaries
{
	// kABPersonAddressStreetKey, kABPersonAddressCityKey, kABPersonAddressStateKey
	// kABPersonAddressZIPKey, kABPersonAddressCountryKey, kABPersonAddressCountryCodeKey
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiDictionaryPropertyType];
	[self setMulti:multi forProperty:kABPersonAddressProperty];
	CFRelease(multi);
}

- (void) setSmsDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel, 
	// kABPersonInstantMessageServiceKey, kABPersonInstantMessageUsernameKey
	// kABPersonInstantMessageServiceYahoo, kABPersonInstantMessageServiceJabber
	// kABPersonInstantMessageServiceMSN, kABPersonInstantMessageServiceICQ
	// kABPersonInstantMessageServiceAIM, 
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiDictionaryPropertyType];
	[self setMulti:multi forProperty:kABPersonInstantMessageProperty];
	CFRelease(multi);
}

#pragma mark Images
- (UIImage *) image
{
    if (!ABPersonHasImageData(record)) return nil;
    CFDataRef imageData = ABPersonCopyImageData(record);
    UIImage *image = [UIImage imageWithData:(NSData *) imageData];
    CFRelease(imageData);
    return image;
}

- (void) setImage: (UIImage *) image
{
    CFErrorRef error;
    BOOL success;
    
    if (image == nil) // remove
    {
        if (!ABPersonHasImageData(record)) return; // no image to remove
        success = ABPersonRemoveImageData(record, &error);
        if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
        return;
    }
    
    NSData *data = UIImagePNGRepresentation(image);
    success = ABPersonSetImageData(record, (CFDataRef) data, &error);
    if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
}

- (NSData *)imageData
{
    if (!ABPersonHasImageData(record)) return nil;
    NSData *imageData = (NSData *)ABPersonCopyImageData(record);
    return [imageData autorelease];
}

- (void) setImageData: (NSData *) data
{
    [self setImage:[UIImage imageWithData:data]];
}


- (UIImage *) thumb
{
    if (!ABPersonHasImageData(record)) return nil;
    CFDataRef imageData = ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail);
    UIImage *image = [UIImage imageWithData:(NSData *) imageData];
    CFRelease(imageData);
    return image;
}

- (void) setThumb: (UIImage *) image
{
    [self setImage:image];
}

- (NSData *)thumbData
{
    if (!ABPersonHasImageData(record)) return nil;
    NSData *imageData = (NSData *)ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail);
    return [imageData autorelease];
}

- (void) setThumbData: (NSData *) data
{
    [self setThumb:[UIImage imageWithData:data]];
}

-(NSString *)ToXMLString
{
    NSString *XMLStr =@"<contact>";
    if(self.firstname)
    {
        NSString *fName=[[NSString alloc] initWithFormat:@"<firstName>%@</firstName>",self.firstname];
        XMLStr=[XMLStr stringByAppendingString:fName];
        [fName release];
    }
    
    if(self.middlename)
    {
        NSString *mName=[[NSString alloc] initWithFormat:@"<middleName>%@</middleName>",self.middlename];
        XMLStr=[XMLStr stringByAppendingString:mName];
        [mName release];
    }
    
    if(self.lastname)
    {
        NSString *lName=[[NSString alloc] initWithFormat:@"<lastName>%@</lastName>", self.lastname];
        XMLStr=[XMLStr stringByAppendingString:lName];
        [lName release];
    }
    
    if(self.prefix)
    {
        NSString *prefix=[[NSString alloc] initWithFormat:@"<prefix>%@</prefix>",self.prefix];
        XMLStr=[XMLStr stringByAppendingString:prefix];
        [prefix release];
    }
    
    if(self.suffix)
    {
        NSString *suffix=[[NSString alloc] initWithFormat:@"<suffix>%@</suffix>", self.suffix ];
        XMLStr=[XMLStr stringByAppendingString:suffix];
        [suffix release];
    }
    
    if(self.nickname)
    {
        NSString *nickname=[[NSString alloc] initWithFormat:@"<nickname>%@</nickname>",self.nickname];
        XMLStr=[XMLStr stringByAppendingString:nickname];
        [nickname release];
    }
    
    if(self.firstnamephonetic)
    {
        NSString *firstnamephonetic=[[NSString alloc] initWithFormat:@"<firstnamephonetic>%@</firstnamephonetic>", self.firstnamephonetic];
        XMLStr=[XMLStr stringByAppendingString:firstnamephonetic];
        [firstnamephonetic release];
    }
    
    if(self.middlenamephonetic)
    {
        NSString *middlenamephonetic=[[NSString alloc] initWithFormat:@"<middlenamephonetic>%@</middlenamephonetic>", self.middlenamephonetic];
        XMLStr=[XMLStr stringByAppendingString:middlenamephonetic];
        [middlenamephonetic release];
    }
    
    if(self.lastnamephonetic)
    {
        NSString *lastnamephonetic=[[NSString alloc] initWithFormat:@"<lastnamephonetic>%@</lastnamephonetic>",self.lastnamephonetic];
        XMLStr=[XMLStr stringByAppendingString:lastnamephonetic];
        [lastnamephonetic release];
    }
    
    if(self.organization)
    {
        NSString *organization=[[NSString alloc] initWithFormat:@"<organization>%@</organization>", self.organization ];
        XMLStr=[XMLStr stringByAppendingString:organization];
        [organization release];
    }
    
    if(self.jobtitle)
    {
        NSString *jobtitle=[[NSString alloc] initWithFormat:@"<jobtitle>%@</jobtitle>",self.jobtitle];
        XMLStr=[XMLStr stringByAppendingString:jobtitle];
        [jobtitle release];
    }
    
    if(self.department)
    {
        NSString *department=[[NSString alloc] initWithFormat:@"<department>%@</department>",self.department];
        XMLStr=[XMLStr stringByAppendingString:department];
        [department release];
    }
    
    if(self.note)
    {
        NSString *note=[[NSString alloc] initWithFormat:@"<note>%@</note>",self.note];
        XMLStr=[XMLStr stringByAppendingString:note];
        [note release];
    }
    
    if(self.birthday)
    {
        NSString *birthday=[[NSString alloc] initWithFormat:@"<birthday>%@</birthday>",self.birthday];
        XMLStr=[XMLStr stringByAppendingString:birthday];
        [birthday release];
    }
    
    if(self.phoneDictionaries && [self.phoneDictionaries count]>0)
    {
        NSString *phoneDicts=@"<phones>";
        for(NSMutableDictionary *em in self.phoneDictionaries)
        {
            NSString *strLbl= [em objectForKey:@"label"];
            strLbl=[[strLbl stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            NSString *eml=[[NSString alloc] initWithFormat:@"<phone type=\"%@\">%@</phone>",strLbl,[em objectForKey:@"value"]];
            phoneDicts=[phoneDicts stringByAppendingString:eml];
            [eml release];
        }
        phoneDicts=[phoneDicts stringByAppendingString:@"</phones>"];
        XMLStr=[XMLStr stringByAppendingString:phoneDicts];
    }
    
    if(self.emailDictionaries && [self.emailDictionaries count]>0)
    {
        NSString *emailDicts=@"<emails>";
        for(NSMutableDictionary *em in self.emailDictionaries)
        {
            NSString *strLbl= [em objectForKey:@"label"];
            strLbl=[[strLbl stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            NSString *eml=[[NSString alloc] initWithFormat:@"<email type=\"%@\">%@</email>",strLbl,[em objectForKey:@"value"]];
            emailDicts=[emailDicts stringByAppendingString:eml];
            [eml release];
        }
        emailDicts=[emailDicts stringByAppendingString:@"</emails>"];
        XMLStr=[XMLStr stringByAppendingString:emailDicts];
    }
    
    if(self.urlDictionaries && [self.urlDictionaries count]>0)
    {
        NSString *urlDicts=@"<urls>";
        for(NSMutableDictionary *em in self.urlDictionaries)
        {
            NSString *strLbl= [em objectForKey:@"label"];
            strLbl=[[strLbl stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            NSString *eml=[[NSString alloc] initWithFormat:@"<url type=\"%@\">%@</url>",strLbl,[em objectForKey:@"value"]];
            urlDicts=[urlDicts stringByAppendingString:eml];
            [eml release];
        }
        urlDicts=[urlDicts stringByAppendingString:@"</urls>"];
        XMLStr=[XMLStr stringByAppendingString:urlDicts];
    }
    
    if(self.relatedNameDictionaries && [self.relatedNameDictionaries count]>0)
    {
        NSString *rNameDicts=@"<relatedNames>";
        for(NSMutableDictionary *em in self.relatedNameDictionaries)
        {
            NSString *strLbl= [em objectForKey:@"label"];
            strLbl=[[strLbl stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            NSString *eml=[[NSString alloc] initWithFormat:@"<relatedName type=\"%@\">%@</relatedName>",strLbl,[em objectForKey:@"value"]];
            rNameDicts=[rNameDicts stringByAppendingString:eml];
            [eml release];
        }
        rNameDicts=[rNameDicts stringByAppendingString:@"</relatedNames>"];
        XMLStr=[XMLStr stringByAppendingString:rNameDicts];
    }
    
    if(self.dateDictionaries && [self.dateDictionaries count]>0)
    {
        NSString *dateDicts=@"<dates>";
        for(NSMutableDictionary *em in self.dateDictionaries)
        {
            NSString *strLbl= [em objectForKey:@"label"];
            strLbl=[[strLbl stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            NSString *eml=[[NSString alloc] initWithFormat:@"<date type=\"%@\">%@</date>",strLbl,[em objectForKey:@"value"]];
            dateDicts=[dateDicts stringByAppendingString:eml];
            [eml release];
        }
        dateDicts=[dateDicts stringByAppendingString:@"</dates>"];
        XMLStr=[XMLStr stringByAppendingString:dateDicts];
    }
    
    if(self.addressDictionaries && [self.addressDictionaries count]>0)
    {
        NSString *addrDicts=@"<addresses>";
        for(NSMutableDictionary *em in self.addressDictionaries)
        {
            NSString *strLbl= [em objectForKey:@"label"];
            strLbl=[[strLbl stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            NSString *eml=[[NSString alloc] initWithFormat:@"<address type=\"%@\">%@</address>",strLbl,[em objectForKey:@"value"]];
            addrDicts=[addrDicts stringByAppendingString:eml];
            [eml release];
        }
        addrDicts=[addrDicts stringByAppendingString:@"</addresses>"];
        XMLStr=[XMLStr stringByAppendingString:addrDicts];
    }
    
    if(self.smsDictionaries && [self.smsDictionaries count]>0)
    {
        NSString *smsDicts=@"<smses>";
        for(NSMutableDictionary *em in self.smsDictionaries)
        {
            NSString *strLbl= [em objectForKey:@"label"];
            strLbl=[[strLbl stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            NSString *eml=[[NSString alloc] initWithFormat:@"<sms type=\"%@\">%@</sms>",strLbl,[em objectForKey:@"value"]];
            smsDicts=[smsDicts stringByAppendingString:eml];
            [eml release];
        }
        smsDicts=[smsDicts stringByAppendingString:@"</smses>"];
        XMLStr=[XMLStr stringByAppendingString:smsDicts];
    }
    
    /*
     if(self.addressDictionaries && [self.addressDictionaries count]>0)
     {
     NSString *addrDicts=@"<addresses>";
     for(NSMutableDictionary *em in self.addressDictionaries)
     {
     NSString *strLbl= [em objectForKey:@"label"];
     strLbl=[[strLbl stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
     
     NSString *eml=[[NSString alloc] initWithFormat:@"<address type=\"%@\">",strLbl];
     
     for(NSMutableDictionary *ad in [em objectForKey:@"value"]){
     strLbl= [ad objectForKey:@"label"];
     strLbl=[[strLbl stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
     NSString *addetail=[[NSString alloc] initWithFormat:@"<addrDetails type=\"%@\">%@</addrDetails>",strLbl,[ad objectForKey:@"value"]];
     eml=[eml stringByAppendingString:addetail];
     [addetail release];
     }
     eml=[eml stringByAppendingString:@"</address>"];
     addrDicts=[addrDicts stringByAppendingString:eml];
     [eml release];
     }
     addrDicts=[addrDicts stringByAppendingString:@"</addresses>"];
     XMLStr=[XMLStr stringByAppendingString:addrDicts];
     }
     */
    
    XMLStr=[XMLStr stringByAppendingString:@"</contact>"];
    return XMLStr;
}



//
+ (NSString *)normalizeLabel:(NSString *)label
{
    NSString *labelLower = [label lowercaseString];
    NSString *normLabel = label;
    
    if ([labelLower isEqualToString:@"_$!<mobile>!$_"]) normLabel = NSLocalizedString(@"mobile", nil);
    else if ([labelLower isEqualToString:@"iphone"]) normLabel = NSLocalizedString(@"iPhone", nil);
    else if ([labelLower isEqualToString:@"_$!<home>!$_"]) normLabel = NSLocalizedString(@"home", nil);
    else if ([labelLower isEqualToString:@"_$!<work>!$_"]) normLabel = NSLocalizedString(@"work", nil);
    else if ([labelLower isEqualToString:@"_$!<main>!$_"]) normLabel = NSLocalizedString(@"main", nil);
    else if ([labelLower isEqualToString:@"_$!<homefax>!$_"]) normLabel = NSLocalizedString(@"home fax", nil);
    else if ([labelLower isEqualToString:@"_$!<workfax>!$_"]) normLabel = NSLocalizedString(@"work fax", nil);
    else if ([labelLower isEqualToString:@"_$!<pager>!$_"]) normLabel = NSLocalizedString(@"pager", nil);
    else if ([labelLower isEqualToString:@"_$!<other>!$_"]) normLabel = NSLocalizedString(@"other", nil);
    
    return normLabel;
}



@end
