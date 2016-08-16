//
//  HXSCommissionEntity.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommissionEntity.h"

@implementation HXSCommissionEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"typeIntNum",     @"type",
                             @"timeLongNum",    @"time",
                             @"amountIntNum",   @"amount",
                             @"contentStr",     @"content",
                             nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSCommissionEntity alloc] initWithDictionary:object error:nil];
}

@end
