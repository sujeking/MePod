//
//  HXSDeliveryEntity.m
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDeliveryEntity.h"

@implementation HXSDeliveryTime

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"typeIntNum",     @"type",
                         @"nameStr",        @"name",
                         @"expectStartTimeLongNum", @"expect_start_time",
                         @"expectEndTimeLongNum",   @"expect_end_time",
                         nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}

@end

@implementation HXSDeliveryEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *deliveryEntityDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"sendTypeIntNum",         @"send_type",
                                       @"deliveryAmountDoubleNum",@"delivery_amount",
                                       @"freeDeliveryAmountDoubleNum",@"free_delivery_amount",
                                       @"descriptionStr",             @"description",
                                       @"pickAddressStr",             @"pick_address",
                                       @"pickTimeStr",                @"pick_time_string",
                                       @"deliveryTimesMutArr", @"delivery_times",
                                       nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:deliveryEntityDic];
}

@end
