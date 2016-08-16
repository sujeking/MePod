//
//  HXSUpgradeAuthStatusEntity.m
//  store
//
//  Created by ArthurWang on 16/2/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUpgradeAuthStatusEntity.h"

@implementation HXSUpgradeAuthStatusEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{@"zhima_auth_status":         @"zhimaAuthStatusIntNum",
                              @"contacts_auth_status":      @"contactsAuthStatusIntNum",
                              @"emergency_contacts_status": @"emergencyContactsStatusIntNum",
                              
                              @"position_status":           @"positionStatusIntNum",
                              @"call_records_status":       @"callRecordsStatus",
                              
                              @"id_card_direct_url":        @"idCardDirectUrlStr",
                              @"id_card_back_url":          @"idCardBackUrlStr",
                              @"id_card_handheld_url":      @"idCardHandheldUrlStr"
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)createEntityWithDictionary:(NSDictionary *)infoDic
{
    return [[HXSUpgradeAuthStatusEntity alloc] initWithDictionary:infoDic error:nil];
}

@end
