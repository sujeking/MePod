//
//  HXSBankCardItem.m
//  store
//
//  Created by hudezhi on 15/8/5.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBankCardItem.h"

static NSString *BankCardItemCardNumKey = @"cardNum";
static NSString *BankCardItemBankNameKey = @"bankName";
static NSString *BankCardItemBankCodeKey = @"bankCode";
static NSString *BankCardItemBankLogoKey = @"bankLogo";
static NSString *BankCardItemBindKey     = @"isBinding";
static NSString *BankCardBoundPhoneKey   = @"boundPhone";

@implementation HXSBankCardItem

- (instancetype)initWithDictionary:(NSDictionary *)response
{
    self = [super init];
    if(self) {
        self.cardNum = [response objectForKey:@"card_no"];
        self.bankName = [response objectForKey:@"bank_name"];
        self.bankCode = [response objectForKey:@"bank_code"];
        self.bankLogo = [response objectForKey:@"bank_logo"];
        self.boundPhone = [response objectForKey:@"account_phone"];
        self.isBindingByJiufu = [[response objectForKey:@"jiufu_binding_flag"] boolValue];
    }
    
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (_cardNum) {
        [aCoder encodeObject:_cardNum forKey:BankCardItemCardNumKey];
    }
    if (_bankName) {
        [aCoder encodeObject:_bankName forKey:BankCardItemBankNameKey];
    }
    if (_bankCode) {
        [aCoder encodeObject:_bankCode forKey:BankCardItemBankCodeKey];
    }
    if (_bankLogo) {
        [aCoder encodeObject:_bankLogo forKey:BankCardItemBankLogoKey];
    }
    if (_boundPhone) {
        [aCoder encodeObject:_boundPhone forKey:BankCardBoundPhoneKey];
    }
    
    [aCoder encodeBool:_isBindingByJiufu forKey:BankCardItemBindKey];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.cardNum = [aDecoder decodeObjectForKey:BankCardItemCardNumKey];
        self.bankName = [aDecoder decodeObjectForKey:BankCardItemBankNameKey];
        self.bankCode = [aDecoder decodeObjectForKey:BankCardItemBankCodeKey];
        self.bankLogo = [aDecoder decodeObjectForKey:BankCardItemBankLogoKey];
        self.boundPhone = [aDecoder decodeObjectForKey:BankCardBoundPhoneKey];
        self.isBindingByJiufu = [aDecoder decodeBoolForKey:BankCardItemBindKey];
    }
    
    return self;
}

@end
