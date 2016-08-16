//
//  HXSStoreCartEntity.m
//  store
//
//  Created by BeyondChao on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSStoreCartEntity.h"

@implementation HXSStoreCartEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *cartMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"deliveryAmountNum",          @"delivery_amount",
                                 @"itemAmountNum",              @"item_amount",
                                 @"itemTotalNum",               @"item_num",
                                 @"itemsArray",                 @"items", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:cartMapping];
}

+ (instancetype)cartEntityWithDictionary:(NSDictionary *)cartDict {
    
    if ((nil == cartDict)
        || [cartDict isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return [[HXSStoreCartEntity alloc] initWithDictionary:cartDict error:nil];
}

@end
