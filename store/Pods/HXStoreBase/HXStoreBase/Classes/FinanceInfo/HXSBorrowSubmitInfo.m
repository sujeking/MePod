//
//  HXSBorrowSubmitInfo.m
//  store
//
//  Created by hudezhi on 15/8/3.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowSubmitInfo.h"

#import "HXLocationManager.h"
#import "HXSContactManager.h"
#import "HXMacrosUtils.h"

// =================== HXSBorrowContactInfo Keys ===================

static NSString *BorrowContactNameKey = @"contactName";
static NSString *BorrowContactPhoneKey = @"contactPhone";
static NSString *BorrowContactRelationshipKey = @"contactRelationship";

@implementation HXSBorrowContactInfo

+ (instancetype) borrowContactInfoWithName:(NSString *)name phoneNum: (NSString *)phoneNum relationShip:(NSString *)relationship
{
    HXSBorrowContactInfo *contactInfo = [[HXSBorrowContactInfo alloc] init];
    contactInfo.contactName = (name.length > 0) ? name : @"";
    contactInfo.contactPhone = (phoneNum.length > 0) ? phoneNum : @"";
    contactInfo.relationShip = (relationship.length > 0) ? relationship : @"";
    
    return contactInfo;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_contactName forKey:BorrowContactNameKey];
    [aCoder encodeObject:_contactPhone forKey:BorrowContactPhoneKey];
    [aCoder encodeObject:_relationShip forKey:BorrowContactRelationshipKey];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.contactName = [aDecoder decodeObjectForKey:BorrowContactNameKey];
        self.contactPhone = [aDecoder decodeObjectForKey:BorrowContactPhoneKey];
        self.relationShip = [aDecoder decodeObjectForKey:BorrowContactRelationshipKey];
    }
    
    return self;
}

@end


/*
 *  =================== HXSBorrowSubmitInfo ===================
 */

// =================== Borrow Submit Information Keys ===================

static NSString *BorrowPurposeKey = @"purpose";
static NSString *BorrowInstallmentEncashmentKey = @"installmentEncashment";
static NSString *BorrowAmountKey = @"amount";

static NSString *BorrowAccountNameKey = @"accountName";
static NSString *BorrowIdCardNumKey  = @"idCardNum";
static NSString *BorrowBoundBankCardKey = @"boundBankCard";

static NSString *BorrowCollegeNameKey = @"collegeName";
static NSString *BorrowEntranceYearKey = @"entranceYear";
static NSString *BorrowEducationBackgroundKey = @"educationBackground";
static NSString *BorrowMajorKey = @"majorName";
static NSString *BorrowAddressKey = @"address";

static NSString *BorrowContactListKey = @"contactList";



// ===================  ===================

@implementation HXSBorrowSubmitInfo

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // step 1
    if (_purpose != nil) {
        [aCoder encodeObject:_purpose forKey:BorrowPurposeKey];
    }
    if (_installmentSelectEntity != nil) {
        [aCoder encodeObject:_installmentSelectEntity forKey:BorrowInstallmentEncashmentKey];
    }
    
    [aCoder encodeDouble:_amount forKey:BorrowAmountKey];
    
    // step 2
    if (_accountName != nil) {
        [aCoder encodeObject:_accountName forKey:BorrowAccountNameKey];
    }
    if (_idCardNum !=  nil) {
        [aCoder encodeObject:_idCardNum forKey:BorrowIdCardNumKey];
    }
    if (_boundBankCard != nil) {
        [aCoder encodeObject:_boundBankCard forKey:BorrowBoundBankCardKey];
    }
    
    // step 3
    if (_collegeName != nil) {
        [aCoder encodeObject:_collegeName forKey:BorrowCollegeNameKey];
    }
    if (_entranceYear != nil) {
        [aCoder encodeObject:_entranceYear forKey:BorrowEntranceYearKey];
    }
    if (_educationBackground != nil) {
        [aCoder encodeObject:_educationBackground forKey:BorrowEducationBackgroundKey];
    }
    if (_majorName != nil) {
        [aCoder encodeObject:_majorName forKey:BorrowMajorKey];
    }
    if (_address != nil) {
        [aCoder encodeObject:_address forKey:BorrowAddressKey];
    }
    
    // step 4
    if (_contactList.count > 0) {
        [aCoder encodeObject:_contactList forKey:BorrowContactListKey];
    }
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        // step 1
        self.purpose = [aDecoder decodeObjectForKey:BorrowPurposeKey];
        self.installmentSelectEntity = [aDecoder decodeObjectForKey:BorrowInstallmentEncashmentKey];
        self.amount = [aDecoder decodeDoubleForKey:BorrowAmountKey];
        
        // step 2
        self.accountName = [aDecoder decodeObjectForKey:BorrowAccountNameKey];
        self.idCardNum = [aDecoder decodeObjectForKey:BorrowIdCardNumKey];
        self.boundBankCard = [aDecoder decodeObjectForKey:BorrowBoundBankCardKey];
        
        // step 3
        self.collegeName = [aDecoder decodeObjectForKey:BorrowCollegeNameKey];
        self.entranceYear = [aDecoder decodeObjectForKey:BorrowEntranceYearKey];
        self.educationBackground = [aDecoder decodeObjectForKey:BorrowEducationBackgroundKey];
        self.majorName = [aDecoder decodeObjectForKey:BorrowMajorKey];
        self.address = [aDecoder decodeObjectForKey:BorrowAddressKey];
        
        // step 4
        self.contactList = [aDecoder decodeObjectForKey:BorrowContactListKey];
    }
    
    return self;
}

- (NSDictionary *)contactDictionary:(HXSBorrowContactInfo *)info
{
    return @{@"number" : info.contactPhone,
             @"cached_name" : info.contactName,
             @"user_relation" : info.relationShip};
}

- (NSString *)stringFromDictionary:(NSDictionary *)dictionary
{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dictionary options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    DLog(@"%@",myString);
    
    return myString;
}

- (NSDictionary *)dictionary
{
    NSDictionary *amoutDic = @{ @"purpose_type_code": _purpose.purposeCode,
                                @"purpose_type_name": _purpose.purposeName,
                                @"encashment_amount": @(_amount),
                                @"monthly_amount":    self.installmentSelectEntity.installmentAmountNum,
                               };
    
    NSDictionary *userDic = @{@"account_name" : _accountName,
                              @"id_card_no" : _idCardNum,
                              @"card_no" : _boundBankCard.cardNum};
    
    NSDictionary *studentInfo = @{ @"city_name" : @"",
                                   @"site_name" : _collegeName,
                                   @"entrance_year" : _entranceYear,
                                   @"education_name" : _educationBackground,
                                   @"major_name" : _majorName,
                                   @"dorm_address" : _address};
    
    HXLocationManager *locationManager = [HXLocationManager shareInstance];
    NSDictionary *auth_position = @{ @"latitude" : [[NSNumber alloc]initWithDouble:locationManager.latitude],
                                     @"longitude" : [[NSNumber alloc]initWithDouble:locationManager.longitude]};
    NSDictionary *systemInfo = @{ @"platform" : @"IOS",
                                  @"version" : [[UIDevice currentDevice] systemVersion] == nil ? [NSNull null]:[[UIDevice currentDevice] systemVersion],
                                  @"uuid" : [[[UIDevice currentDevice] identifierForVendor] UUIDString]};
    
    NSMutableArray *callList = [NSMutableArray array];
    for (int i = 0 ; i < _contactList.count ; i++) {
        HXSBorrowContactInfo *info = _contactList[i];
        [callList addObject:[self contactDictionary:info]];
    }
    
    NSDictionary *addressListInfo = @{@"auth_position" : auth_position,
                                        @"auth_setup" : systemInfo,
                                        @"auth_call_list" : callList,
                                        @"auth_contacts_list" : [HXSContactManager exportAllContactsForUserInfoAuth]};
    
    return @{@"loan_application_json" : [self stringFromDictionary: amoutDic],
             @"repayment_user_json" : [self stringFromDictionary: userDic],
             @"student_status_json" :  [self stringFromDictionary: studentInfo],
             @"address_list_info_json" : [self stringFromDictionary: addressListInfo]
             
             };
}

- (NSDictionary *)contactDictionary
{
    HXLocationManager *locationManager = [HXLocationManager shareInstance];
    NSDictionary *auth_position = @{ @"latitude" : @(locationManager.latitude),
                                     @"longitude" : @(locationManager.longitude)};
    NSDictionary *systemInfo = @{ @"platform" : @"IOS",
                                  @"version" : [[UIDevice currentDevice] systemVersion],
                                  @"uuid" : [[[UIDevice currentDevice] identifierForVendor] UUIDString]
                                  };
    
    NSMutableArray *callList = [[NSMutableArray alloc]init];;
    for (int i = 0 ; i < _contactList.count ; i++)
    {
        HXSBorrowContactInfo *info = _contactList[i];
        [callList addObject:[self contactDictionary:info]];
    }
    
    NSDictionary *addressListInfo = @{@"auth_position" : auth_position,
                                      @"auth_setup" : systemInfo,
                                      @"auth_call_list" : callList,
                                      @"auth_contacts_list" : [HXSContactManager exportAllContactsForUserInfoAuth]
                                      };
    return @{
             @"contacts_info" : [self stringFromDictionary: addressListInfo]
             };
}
@end
