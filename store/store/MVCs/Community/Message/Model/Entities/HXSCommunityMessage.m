//
//  HXSCommunityMessage.m
//  store
//
//  Created by 格格 on 16/4/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityMessage.h"


@implementation HXSCommunityMessage


+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *messageMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"idStr",                   @"id",
                                    @"hostUidLongNum",          @"host_uid",
                                    @"postIdStr",               @"post_id",
                                    @"postContentStr",          @"post_content",
                                    @"postCoverImgStr",         @"post_cover_img",
                                    @"contentStr",              @"content",
                                    @"commentIdStr",            @"comment_id",
                                    @"createTimeLongNum",       @"create_time",
                                    @"typeIntNum",              @"type",
                                    @"statusIntNum",            @"status",
                                    @"guestUser",               @"guest_user",
                                    nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:messageMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSCommunityMessage alloc] initWithDictionary:object error:nil];
}

@end
