//
//  HXSBankEntity.m
//  store
//
//  Created by 格格 on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBankEntity.h"

@implementation HXSBankEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"codeStr",@"code",
                             @"nameStr",@"name",
                             @"imageStr",@"image",
                             nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBankEntity alloc] initWithDictionary:object error:nil];
}

@end
