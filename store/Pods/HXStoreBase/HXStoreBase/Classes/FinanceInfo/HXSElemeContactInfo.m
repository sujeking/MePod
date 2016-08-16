//
//  HXSElemeContactInfo.m
//  store
//
//  Created by hudezhi on 15/8/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSElemeContactInfo.h"

#import "HXMacrosUtils.h"

static NSString *ElemeContactInfoUserNameKey = @"ElemeContactInfoUaerNameKey";
static NSString *ElemeContactInfoUserPhoneKey = @"ElemeContactInfoUaerPhoneKey";
static NSString *ElemeContactInfoUserAddressKey = @"ElemeContactInfoUaerAddressKey";
static NSString *ElemeContactInfoUserSiteIdKey = @"ElemeContactInfoUaerSiteIdKey";
static NSString *ElemeContactInfoUserSiteNameKey = @"ElemeContactInfoUaerSiteNameKey";

@implementation HXSElemeContactInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (DIC_HAS_STRING(dictionary, @"user_name")) {
            self.userName = dictionary[@"user_name"];
        }
        if (DIC_HAS_STRING(dictionary, @"user_phone")) {
            self.userPhone = dictionary[@"user_phone"];
        }
        if (DIC_HAS_STRING(dictionary, @"user_address")) {
            self.userAddress = dictionary[@"user_address"];
        }
        if (DIC_HAS_NUMBER(dictionary, @"site_id")) {
            self.siteId = [dictionary[@"site_id"] integerValue];
        }
    }
    
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (_userName.length > 0) {
        [aCoder encodeObject:_userName forKey:ElemeContactInfoUserNameKey];
    }
    if (_userPhone.length > 0) {
        [aCoder encodeObject:_userPhone forKey:ElemeContactInfoUserPhoneKey];
    }
    if (_userAddress.length > 0) {
        [aCoder encodeObject:_userAddress forKey:ElemeContactInfoUserAddressKey];
    }
    
    [aCoder encodeObject:@(_siteId) forKey:ElemeContactInfoUserSiteIdKey];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.userName = [aDecoder decodeObjectForKey:ElemeContactInfoUserNameKey];
        self.userPhone = [aDecoder decodeObjectForKey:ElemeContactInfoUserPhoneKey];
        self.userAddress = [aDecoder decodeObjectForKey:ElemeContactInfoUserAddressKey];
        NSNumber* siteId = [aDecoder decodeObjectForKey:ElemeContactInfoUserSiteIdKey];
        
        self.siteId = [siteId integerValue];
    }
    
    return self;
}

@end
