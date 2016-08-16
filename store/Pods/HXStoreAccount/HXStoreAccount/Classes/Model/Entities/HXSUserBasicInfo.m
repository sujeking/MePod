//
//  HXSUserBasicInfo.m
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSUserBasicInfo.h"

#import "HXStoreWebServiceURL.h"
#import "HXMacrosUtils.h"

@implementation HXSUserBasicInfo

- (id) initWithLocalDic:(NSDictionary *)dic
{
    self = [super init];
    if (self != nil)
    {
        if ([dic objectForKey:@"uid"])
        {
            self.uid = [NSNumber numberWithLongLong:[[dic objectForKey:@"uid"] longLongValue]];
        }
        
        if ([dic objectForKey:@"uname"] &&
            [[dic objectForKey:@"uname"] isKindOfClass:[NSString class]])
        {
            self.uName = [dic objectForKey:@"uname"];
        }
        
        if ([dic objectForKey:@"nick_name"] &&
            [[dic objectForKey:@"nick_name"] isKindOfClass:[NSString class]])
        {
            self.nickName = [dic objectForKey:@"nick_name"];
        }
        
        if ([dic objectForKey:@"email"] &&
            [[dic objectForKey:@"email"] isKindOfClass:[NSString class]])
        {
            self.email = [dic objectForKey:@"email"];
        }
        
        if ([dic objectForKey:@"portrait_big"] &&
            [[dic objectForKey:@"portrait_big"] isKindOfClass:[NSString class]])
        {
            self.portrait_big = [dic objectForKey:@"portrait_big"];
        }
        else
        {
            self.portrait_big = [NSString stringWithFormat:@"%@%@", kBundlePath, @"new_logo"];
        }
        
        if ([dic objectForKey:@"portrait_medium"] &&
            [[dic objectForKey:@"portrait_medium"] isKindOfClass:[NSString class]])
        {
            self.portrait_medium = [dic objectForKey:@"portrait_medium"];
        }
        else
        {
            self.portrait_medium = [NSString stringWithFormat:@"%@%@", kBundlePath, @"new_logo"];
        }
        
        if ([dic objectForKey:@"portrait"] &&
            [[dic objectForKey:@"portrait"] isKindOfClass:[NSString class]])
        {
            self.portrait = [dic objectForKey:@"portrait"];
        }
        else
        {
            self.portrait = [NSString stringWithFormat:@"%@%@", kBundlePath, @"new_logo"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"gender"))
        {
            self.gender = [[dic objectForKey:@"gender"] intValue];
        }
        else
        {
            self.gender = 0;
        }
        
        if (DIC_HAS_NUMBER(dic, @"role"))
        {
            self.role = [[dic objectForKey:@"role"] intValue];
        }
        else
        {
            self.role = 0;
        }
        
        if (DIC_HAS_NUMBER(dic, @"level"))
        {
            self.level = [[dic objectForKey:@"level"] intValue];
        }
        else
        {
            self.level = 0;
        }
        
        if (DIC_HAS_NUMBER(dic, @"credit"))
        {
            self.credit = [[dic objectForKey:@"credit"] intValue];
        }
        else
        {
            self.credit = 0;
        }
        
        if (DIC_HAS_NUMBER(dic, @"historycredit"))
        {
            self.historycredit = [[dic objectForKey:@"historycredit"] intValue];
        }
        else
        {
            self.historycredit = 0;
        }
        
        if (DIC_HAS_STRING(dic, @"location"))
        {
            self.location = [dic objectForKey:@"location"];
        }
        
        if (DIC_HAS_STRING(dic, @"geo_location"))
        {
            NSString * str = [dic objectForKey:@"geo_location"];
            NSArray * array = [str componentsSeparatedByString:@","];
            if (array.count == 2)
            {
                self.longitude = [array objectAtIndex:0];
                self.latitude = [array objectAtIndex:1];
            }
        }
        
        if(DIC_HAS_NUMBER(dic, @"coupon_quantity"))
        {
            self.couponQuantity = [[dic objectForKey:@"coupon_quantity"] intValue];
        }
        
        if (DIC_HAS_STRING(dic, @"phone")) {
            self.phone = [dic objectForKey:@"phone"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"password_flag")) {
            self.passwordFlag = [[dic objectForKey:@"password_flag"] intValue];
        }
        
        if (DIC_HAS_NUMBER(dic, @"sign_in_flag")) {
            self.signInFlag = [[dic objectForKey:@"sign_in_flag"] intValue];
        }
        
        if (DIC_HAS_NUMBER(dic, @"register_time")) {
            self.registerTimeLongNum = [dic objectForKey:@"register_time"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"sign_in_credit")) {
            self.signInCreditIntNum = [dic objectForKey:@"sign_in_credit"];
        }
    }
    
    return self;
}

- (id) initWithServerDic:(NSDictionary *)dic
{
    return [self initWithLocalDic:dic];
}

- (NSDictionary *) encodeAsLocalDic
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (self.uid)
    {
        [dic setObject:self.uid forKey:@"uid"];
    }
    if (self.nickName)
    {
        [dic setObject:self.nickName forKey:@"nick_name"];
    }
    if (self.uName)
    {
        [dic setObject:self.uName forKey:@"uname"];
    }
    if (self.email)
    {
        [dic setObject:self.email forKey:@"email"];
    }
    if (self.gender)
    {
        [dic setObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
    }
    if (self.level)
    {
        [dic setObject:[NSNumber numberWithInt:self.level] forKey:@"level"];
    }
    if (self.credit)
    {
        [dic setObject:[NSNumber numberWithInt:self.credit] forKey:@"credit"];
    }
    if (self.historycredit)
    {
        [dic setObject:[NSNumber numberWithInt:self.historycredit] forKey:@"historycredit"];
    }
    if (self.role)
    {
        [dic setObject:[NSNumber numberWithInt:self.role] forKey:@"role"];
    }
    if (self.portrait)
    {
        [dic setObject:self.portrait forKey:@"portrait"];
    }
    if (self.portrait_medium)
    {
        [dic setObject:self.portrait_medium forKey:@"portrait_medium"];
    }
    if (self.portrait_big)
    {
        [dic setObject:self.portrait_big forKey:@"portrait_big"];
    }
    if (self.location)
    {
        [dic setObject:self.location forKey:@"location"];
    }
    if (self.longitude && self.latitude)
    {
        [dic setObject:[NSString stringWithFormat:@"%@,%@", self.longitude, self.latitude] forKey:@"geo_location"];
    }
    if (self.couponQuantity)
    {
        [dic setObject:@(self.couponQuantity) forKey:@"coupon_quantity"];
    }
    
    if (self.phone) {
        [dic setObject:self.phone forKey:@"phone"];
    }
    
    if (self.passwordFlag) {
        [dic setObject:@(self.passwordFlag) forKey:@"password_flag"];
    }
    
    if (self.signInFlag) {
        [dic setObject:@(self.signInFlag) forKey:@"sign_in_flag"];
    }
    
    
    return dic;
}

@end
