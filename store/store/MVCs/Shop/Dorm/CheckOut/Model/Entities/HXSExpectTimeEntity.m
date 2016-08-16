//
//  HXSExpectTimeEntity.m
//  store
//
//  Created by ArthurWang on 16/1/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSExpectTimeEntity.h"

@implementation HXSExpectTimeEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"expectTimeTypeIntNum",        @"type",
                             @"expectTimeNameStr",           @"name",
                             @"expectStartTimeNum",          @"expect_start_time",
                             @"expectEndTimeNum",            @"expect_end_time", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

@end
