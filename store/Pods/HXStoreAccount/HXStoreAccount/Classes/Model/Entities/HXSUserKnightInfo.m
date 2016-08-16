//
//  HXSUserKnightInfo.m
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUserKnightInfo.h"


@implementation HXSUserKnightInfo

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"new_task":  @"knightNewTaskIntNum",
                              @"reward":    @"rewardFloatNum",
                              @"status":    @"statusIntNum"
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)createUserKnightInfoWithDic:(NSDictionary *)dic
{
    return [[HXSUserKnightInfo alloc] initWithDictionary:dic error:nil];
}

@end
