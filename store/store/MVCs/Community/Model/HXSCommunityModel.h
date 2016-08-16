//
//  HXSCommunityModel.h
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HXSPost;

@interface HXSCommunityModel : NSObject

/**
 *  获取热门帖子列表
 *
 *  @param topic_id 话题id
 *  @param site_id  学校id
 *  @param page
 *  @param block
 */
+ (void)getCommunityHotPostsWithTopicId:(NSString *)topic_id
                                siteId:(NSString *)site_id
                                  page:(NSNumber *)page
                              complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts, NSString *shareLinkStr))block;


/**
 *  获取推荐帖子列表
 *
 *  @param topic_id 话题id
 *  @param site_id  学校id
 *  @param page
 *  @param block
 */
+ (void)getCommunityRecommendPostsWithTopicId:(NSString *)topic_id
                                      siteId:(NSString *)site_id
                                        page:(NSNumber *)page
                                    complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts))block;

/**
 *  获取全部帖子列表
 *
 *  @param topic_id 话题id
 *  @param site_id  学校id
 *  @param page
 *  @param block
 */
+ (void)getCommunityAllPostsWithTopicId:(NSString *)topic_id
                                      siteId:(NSString *)site_id
                                        page:(NSNumber *)page
                                    complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts, NSString *topicShareLinkStr))block;

/**
 *  获取关注话题的帖子列表
 *
 *  @param page
 *  @param block
 */
+ (void)getCommunityFollowPostsWithPage:(NSNumber *)page
                              complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts))block;


/**
 *  根据帖子列表类型获取帖子列表
 *
 *  @param type     列表类型
 *  @param topic_id 话题id
 *  @param site_id  学校id
 *  @param page
 *  @param block
 */
+ (void)getCommunityPostListWithType:(HXSPostListType)type
                            topicId:(NSString *)topic_id
                             siteId:(NSString *)site_id
                              userId:(NSNumber *)userId
                               page:(NSNumber *)page
                           complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts, NSString *topicShareLinkStr))block;

/**
 *  获取帖子详情
 *
 *  @param post_id 帖子id
 *  @param block   
 */
+ (void)getCommunityPostDetialWithPostId:(NSString *)post_id
                               complete:(void(^)(HXSErrorCode code, NSString * message, HXSPost * post))block;
/**
 *  用户帖子列表，看某个人的帖子列表
 *
 *  @param userId
 *  @param page
 *  @param pageSize
 *  @param block
 */
+ (void)fetchCommuntiyUsersPostWithUserID:(NSString *)userId
                                  andPage:(NSNumber *)page
                              andPageSize:(NSNumber *)pageSize
                                 complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * postsArray))block;


/**
 *  根据帖子id删除帖子
 *
 *  @param post_id 帖子id
 *  @param block
 */
+ (void)communityDeletePostWithPostId:(NSString *)post_id
                             complete:(void(^)(HXSErrorCode code, NSString * message, NSNumber * result_status))block;

//获取新消息
+ (void)getCommunityNewMsgComplete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary * resultDict))block;


@end
