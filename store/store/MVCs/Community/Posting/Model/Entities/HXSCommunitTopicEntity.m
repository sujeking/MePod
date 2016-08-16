//
//  HXSCommunitTopicEntity.m
//  store
//
//  Created by J006 on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunitTopicEntity.h"

@implementation HXSCommunitTopicEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingList = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"idStr",            @"id",
                                 @"titleStr",         @"title",
                                 @"avatarStr",        @"avatar",
                                 @"introStr",         @"intro",
                                 @"weightNum",        @"weight",
                                 @"statusNum",        @"status",nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingList];
}

@end
