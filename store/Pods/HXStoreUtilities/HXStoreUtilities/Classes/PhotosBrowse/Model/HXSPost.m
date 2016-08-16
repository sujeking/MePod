//
//  HXSPost.m
//  store
//
//  Created by 格格 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPost.h"

@implementation HXSImage

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"heightLongNum",          @"height",
                                 @"sizeLongNum",            @"size",
                                 @"widthLongNum",           @"width",
                                 @"urlStr",                 @"url",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSImage alloc] initWithDictionary:object error:nil];
}

@end


@implementation HXSLike

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"idStr",          @"id",
                                 @"postIdStr",      @"post_id",
                                 @"likeUidLongNum", @"like_uid",
                                 @"statusIntNum",   @"status",
                                 @"likeUser",       @"like_user",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;
{
    return [[HXSLike alloc] initWithDictionary:object error:nil];
}

@end







@implementation HXSComment

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"idStr",                  @"id",
                                 @"topicIdStr",             @"topic_id",
                                 @"topicTitleStr",          @"topic_title",
                                 @"postIdStr",              @"post_id",
                                 @"postUidLongNum",         @"post_uid",
                                 @"postContentStr",         @"post_content",
                                 @"commentUidLongNum",      @"comment_uid",
                                 @"contentStr",             @"content",
                                 @"createTimeLongNum",      @"create_time",
                                 @"statusIntNum",           @"status",
                                 @"commentedUidLongNum",    @"commented_uid",
                                 @"commentedContentStr",    @"commented_content",
                                 @"commentUser",            @"comment_user",
                                 @"commentedUser",          @"commented_user",
                                 @"postOwner",              @"post_owner",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSComment alloc] initWithDictionary:object error:nil];
}

@end



@implementation HXSPost

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *postMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"idStr",                      @"id",
                                 @"userIdStr",                  @"user_id",
                                 @"viewCountNum",               @"view_count",
                                 @"userNameStr",                @"user_name",
                                 @"userAvatarStr",              @"user_avatar",
                                 @"siteIdStr",                  @"site_id",
                                 @"siteNameStr",                @"site_name",
                                 @"topicIdStr",                 @"topic_id",
                                 @"shareLinkStr",               @"share_link",
                                 @"topicTitleStr",              @"topic_title",
                                 @"contentStr",                 @"content",
                                 @"createTimeLongNum",          @"create_time",
                                 @"likeCountLongNum",           @"like_count",
                                 @"commentCountLongNum",        @"comment_count",
                                 @"shareCountLongNum",          @"share_count",
                                 @"isLikeIntNum",               @"is_like",
                                 @"isOficialIntNum",            @"is_official",
                                 @"postUser",                   @"post_user",
                                 @"imagesArr",                  @"images",
                                 @"likeListArr",                @"like_list",
                                 @"commentListArr",             @"comment_list",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:postMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSPost alloc] initWithDictionary:object error:nil];
}

@end
