//
//  HXSTopic.m
//  store
//
//  Created by 格格 on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTopic.h"

@implementation HXSTopic

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"idStr",              @"id",
                                 @"titleStr",           @"title",
                                 @"smallImageStr",      @"small_image",
                                 @"bigImageStr",        @"big_image",
                                 @"introStr",           @"intro",
                                 @"weightLongNum",      @"weight",
                                 @"statusIntNum",       @"status",
                                 @"isFollowedIntNum",   @"is_followed",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSTopic alloc] initWithDictionary:object error:nil];
}

@end
