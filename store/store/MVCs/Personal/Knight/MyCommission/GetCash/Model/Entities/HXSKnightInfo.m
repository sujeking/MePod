//
//  HXSKnightInfo.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSKnightInfo.h"

@implementation HXSKnightInfo

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"idLongNum",                   @"id",
                            @"uidIntNum",                   @"uid",
                            @"nameStr",                     @"name",
                            @"idCardNoStr",                 @"id_card_no",
                            @"phoneStr",                    @"phone",
                            @"statusIntNum",                @"status",
                            @"lockTimeLongNum",             @"lock_time",
                            @"moneyDoubleNum",              @"money",
                            @"bankCardNoStr",               @"bank_card_no",
                            @"bankNameStr",                 @"bank_name",
                            @"bankCityStr",                 @"bank_city",
                            @"bankUserNameStr",             @"bank_user_name",
                            @"siteNameStr",                 @"site_name",
                            @"enterYearIntNum",             @"enter_year",
                            @"educationIntNum",             @"education",
                            @"siteIdsArr",                  @"site_ids",
                            @"bankCodeStr",                 @"bank_code",
                            nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (id)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSKnightInfo alloc] initWithDictionary:object error:nil];
}

@end
