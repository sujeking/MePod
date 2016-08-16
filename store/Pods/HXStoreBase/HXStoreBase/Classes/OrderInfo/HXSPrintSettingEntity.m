//
//  HXSPrintSettingEntity.m
//  store
//
//  Created by J006 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintSettingEntity.h"

@implementation HXSPrintSettingEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingPrint  = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"printNameStr",            @"name",
                                   @"printTypeNum",            @"type",
                                   @"unitPriceNum",            @"unit_price",
                                   @"pageSideTypeNum",         @"page_side",nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingPrint];
}

@end

@implementation HXSPrintSettingReducedEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingReduce = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"reduceedNameStr",         @"name",
                                   @"reduceedTypeNum",         @"type",
                                   @"reduceedNum",             @"reduced",nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingReduce];
}

@end
