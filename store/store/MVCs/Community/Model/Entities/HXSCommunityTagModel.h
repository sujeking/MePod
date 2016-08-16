//
//  HXSCommunityTagModel.h
//  store
//
//  Created by 格格 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCommunityTagModel : NSObject


/**
 *  点赞
 *
 *  @param post_id 帖子id
 *  @param block
 */
+ (void)communityAddLikeWithPostId:(NSString *)post_id
                         complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;


/**
 *  评论帖子
 *
 *  @param post_id
 *  @param content
 *  @param block   
 */
+(void)communityAddCommentWithPostId:(NSString *)post_id
                             content:(NSString *)content complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary*dic))block;

/**
 *  评论回复的回复
 *
 *  @param post_id 帖子id
 *  @param content 评论内容
 *  @param post_id          帖子id
 *  @param content          回复内容
 *  @param commentedUserId  被回复人id 【可选】
 *  @param commentedContent 被回复人内容 【可选】
 *  @param block
 */
+ (void)communityAddCommentWithPostId:(NSString *)post_id
                             content:(NSString *)content
                     commentedUserId:(NSNumber *)commentedUserId
                    commentedContent:(NSString *)commentedContent
                            complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;

/**
 *  获取评论列表
 *
 *  @param post_id 帖子id
 *  @param page
 *  @param block   
 */
+ (void)getCommunityCommentListWithPostId:(NSString *)post_id
                                     page:(NSNumber *)page
                                 complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *comments))block;

/**
 *  分享成功后调用
 *
 *  @param post_id
 *  @param block
 */
+ (void)communityAddShareWithPostId:(NSString *)post_id
                          complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;
@end
