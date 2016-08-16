//
//  HXSPrintTotalSettingEntity.m
//  store
//
//  Created by J006 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintTotalSettingEntity.h"

@implementation HXSPrintTotalSettingEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingTotal = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"printSettingArray", @"print_types",
                                  @"reduceSettingArray", @"reduced_types", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingTotal];
}

@end
