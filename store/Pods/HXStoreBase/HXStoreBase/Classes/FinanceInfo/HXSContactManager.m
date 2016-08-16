//
//  HXSContactManager.m
//  store
//
//  Created by chsasaw on 14-10-16.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSContactManager.h"

#import <AddressBook/AddressBook.h>
#import "NSMutableDictionary+Safety.h"
#import "HXDataFormatter.h"

@implementation HXSContactInfo

- (NSString *)description
{
    return [NSString stringWithFormat:@"name is %@, phoneNumber is %@.", self.name, self.phoneNumber];
}

@end



#define KEY_ID @"id"
#define KEY_RAWID @"rawid"
#define KEY_DISPLAY_NAME @"display_name"
#define KEY_GIVEN_NAME  @"give_name"
#define KEY_HONORIFIC_SUFFIX @"honorific_suffix"
#define KEY_FORMATTED @"formatted"
#define KEY_MIDDLE_NAME @"middle_name"
#define KEY_FAMILY_NAME @"family_name"
#define KEY_HONORIFIC_PREFIX @"honorific_prefix"
#define KEY_NICK_NAME @"nickname"
#define KEY_BIRTHDAY @"birthday"
#define KEY_NOTE @"note"
#define KEY_PHOTOS @"photos"
#define KEY_CATEGORIES @"categories"
#define KEY_AUTH_CONTACTS_GENERAL_LIST @"auth_contacts_general_list"
#define KEY_CONTACTS_TYPE @"contacts_type"
#define KEY_VALUE @"value"
#define KEY_PREF @"pref"
#define KEY_TYPE @"type"
#define KEY_TITLE @"title"
#define KEY_NAME @"name"
#define KEY_DEPARTMENT @"department"
#define KEY_LOCALITY @"locality"
#define KEY_REGION @"region"
#define KEY_POSTAL_CODE @"postal_code"
#define KEY_COUNTRY @"country"
#define KEY_STREET_ADDRESS @"street_address"


@implementation HXSContactManager


#pragma mark - Public Methods

+ (NSMutableArray *) getAllContacts
{
    static NSMutableArray *contactsArray = nil;
    
    if (contactsArray == nil)
    {
        contactsArray = [[NSMutableArray alloc] init];
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        NSString *firstName, *lastName, *fullName;
        CFArrayRef personArray  = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        for (int i=0; i < CFArrayGetCount(personArray); i++)
        {
            ABRecordRef person = CFArrayGetValueAtIndex(personArray, i);
            
            HXSContactInfo * contactInfo = [[HXSContactInfo alloc] init];
            firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            fullName = @"";
            if (lastName != nil) {
                fullName = [fullName stringByAppendingFormat:@"%@", lastName];
            }
            if (firstName != nil) {
                fullName = [fullName stringByAppendingFormat:@"%@", firstName];
            }
            contactInfo.name = fullName;
            
            ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            if(ABMultiValueGetCount(phones) > 0)
            {
                NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
                contactInfo.phoneNumber = phone;
                
                if (phone.length > 0 && contactInfo.name.length > 0)
                {
                    [contactsArray addObject:contactInfo];
                }
            }
        }
        
        CFRelease(addressBook);
    }
    
    
    
    return contactsArray;
}

+ (NSArray *)exportAllContactsForUserInfoAuth
{
    static NSArray *contactsArr = nil;
    
    if (nil != contactsArr) {
        return contactsArr;
    }
    
    if (kABAuthorizationStatusAuthorized != ABAddressBookGetAuthorizationStatus()) {
        return nil;
    }

    CFErrorRef error = NULL;
    ABAddressBookRef addressBook  = ABAddressBookCreateWithOptions(NULL, &error);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    CFArrayRef allPeopleArr = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSMutableArray *allContactsMArr = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < CFArrayGetCount(allPeopleArr); i++) {
        ABRecordRef people = CFArrayGetValueAtIndex(allPeopleArr, i);
        NSMutableDictionary *peopleMDic = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        // given name
        NSString *givenNameStr = (__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
        [peopleMDic setObjectExceptNil:givenNameStr forKey:KEY_GIVEN_NAME];
        
        // honorific suffix
        NSString *honorificSuffixStr = (__bridge NSString *)ABRecordCopyValue(people, kABPersonSuffixProperty);
        [peopleMDic setObjectExceptNil:honorificSuffixStr forKey:KEY_HONORIFIC_SUFFIX];
        
        // middle name
        NSString *middleNameStr = (__bridge NSString *)ABRecordCopyValue(people, kABPersonMiddleNameProperty);
        [peopleMDic setObjectExceptNil:middleNameStr forKey:KEY_MIDDLE_NAME];
        
        // family name
        NSString *familyNameStr = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
        [peopleMDic setObjectExceptNil:familyNameStr forKey:KEY_FAMILY_NAME];
        
        // honorific prefix
        NSString *honorificPrefixStr = (__bridge NSString *)ABRecordCopyValue(people, kABPersonPrefixProperty);
        [peopleMDic setObjectExceptNil:honorificPrefixStr forKey:KEY_HONORIFIC_PREFIX];
        
        // nickname
        NSString *nicknameStr = (__bridge NSString *)ABRecordCopyValue(people, kABPersonNicknameProperty);
        [peopleMDic setObjectExceptNil:nicknameStr forKey:KEY_NICK_NAME];
        
        // birthday
        NSDate *birthdayDate = (__bridge NSDate *)ABRecordCopyValue(people, kABPersonBirthdayProperty);
        NSString *birthdayStr = [HXDataFormatter stringFromDate:birthdayDate formatString:@"yyyy-MM-dd HH:mm:ss"];
        [peopleMDic setObjectExceptNil:birthdayStr forKey:KEY_BIRTHDAY];
        
        // note
        NSString *noteStr = (__bridge NSString *)ABRecordCopyValue(people, kABPersonNoteProperty);
        [peopleMDic setObjectExceptNil:noteStr forKey:KEY_NOTE];
        
        
        // authContactGeneralList
        NSMutableArray *generalListMArr = [[NSMutableArray alloc] initWithCapacity:5];
        
        // phoneNumbers
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(people, kABPersonPhoneProperty);
        if (0 < ABMultiValueGetCount(phoneNumbers)) {
            NSString *phoneStr = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
            NSDictionary *phoneDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"phoneNumbers", KEY_CONTACTS_TYPE,
                                      phoneStr, KEY_VALUE, nil];
            
            [generalListMArr addObject:phoneDic];
        }
        
        //  emails
        ABMultiValueRef emailNumbers = ABRecordCopyValue(people, kABPersonEmailProperty);
        if (0 < ABMultiValueGetCount(emailNumbers)) {
            NSString *emailStr = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emailNumbers, 0);
            
            NSDictionary *emailDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"emails", KEY_CONTACTS_TYPE,
                                      emailStr, KEY_VALUE, nil];
            
            [generalListMArr addObject:emailDic];
        }
        
        [peopleMDic setObjectExceptNil:generalListMArr forKey:KEY_AUTH_CONTACTS_GENERAL_LIST];
        

        [allContactsMArr addObject:peopleMDic];
    }
    
    CFRelease(addressBook);

    return allContactsMArr;
}


#pragma mark - Private Methods




@end
