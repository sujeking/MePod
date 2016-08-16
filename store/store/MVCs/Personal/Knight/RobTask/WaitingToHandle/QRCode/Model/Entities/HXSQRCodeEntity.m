//
//  HXSQRCodeEntity.m
//  store
//
//  Created by 格格 on 16/5/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSQRCodeEntity.h"

@implementation HXSQRCodeEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"deliveryOrderIdStr",     @"delivery_order_id",
                             @"orderIdStr",             @"order_id",
                             @"shopIdLongNum",          @"shop_id",
                             @"shopNameStr",            @"shop_name",
                             @"shopLogoStr",            @"shop_logo",
                             @"codeStr",                @"code",
                             nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (id)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSQRCodeEntity alloc] initWithDictionary:object error:nil];
}

@end
