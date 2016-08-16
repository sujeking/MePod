//
//  HXSUserFinanceInfo.m
//  store
//
//  Created by hudezhi on 15/8/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSUserFinanceInfo.h"

#import "HXMacrosUtils.h"

@implementation HXSUserFinanceInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if(DIC_HAS_STRING(dictionary, @"account_name")) {
            self.accountName = [dictionary objectForKey:@"account_name"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"id_card_no")) {
            self.idCardNo = [dictionary objectForKey:@"id_card_no"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"city_name")) {
            self.cityname = [dictionary objectForKey:@"city_name"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"site_name")) {
            self.siteName = [dictionary objectForKey:@"site_name"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"entrance_year")) {
            self.entranceYear = [dictionary objectForKey:@"entrance_year"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"education_name")) {
            self.educationName = [dictionary objectForKey:@"education_name"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"major_name")) {
            self.majorName = [dictionary objectForKey:@"major_name"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"dorm_address")) {
            self.dormAddress = [dictionary objectForKey:@"dorm_address"];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"pay_password_flag")) {
            self.isSetPayPasswd = [[dictionary objectForKey:@"pay_password_flag"] boolValue];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"credit_pay_status")) {
            self.isPayOpened = [dictionary[@"credit_pay_status"] boolValue];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"exemption_status")) {
            self.isExemptionStatus = [dictionary[@"exemption_status"] boolValue];
        }
    }
    
    return self;
}

@end
