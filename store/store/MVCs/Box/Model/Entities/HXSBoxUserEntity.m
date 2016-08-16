//
//  HXSBoxUserEntity.m
//  store
//
//  Created by 格格 on 16/6/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxUserEntity.h"

@implementation HXSBoxUserEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"uid"        : @"uidNum",
                              @"username"   : @"unameStr",
                              @"paid_amount": @"paidAmountDoubleNum",
                              @"type"       : @"typeNum",
                              @"status"     : @"statusNum",
                              @"transfer_status"    : @"transferStatusNum",
                              @"phone"              : @"phoneStr",
                              @"dormentry_id"       : @"dormentryIdNum",
                              @"room"               : @"roomStr",
                              @"gender"             : @"genderNum",
                              @"enrollment_year"    : @"enrollmentYearNum"
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBoxUserEntity alloc] initWithDictionary:object error:nil];
}

- (NSString *)statusStr{
    switch (self.statusNum.intValue) {
        case HXSBoxShareStatusNormal:
            return @"";
            break;
        case HXSBoxShareStatusRemoved:
            return @"(已移除)";
            break;
        case HXSBoxShareStatusQuit:
            return @"(已退出)";
            break;
        default:
            return @"";
            break;
    }
}

@end
