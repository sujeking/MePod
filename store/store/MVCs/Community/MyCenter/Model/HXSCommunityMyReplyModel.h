//
//  HXSCommunityMyReplyModel.h
//  store
//  
//  Created by J006 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCommunityCommentEntity.h"

@interface HXSCommunityMyReplyModel : NSObject

/**
 *  获取用户给出的评论列表
 *
 *  @param pageSizeNum
 *  @param lastCommentID
 *  @param block
 */
- (void)fetchMyRepliesWithPageSize:(NSNumber *)pageSizeNum
              andWithLastCommentID:(NSString *)lastCommentID
                          Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXSCommunityCommentEntity *> *entityArray))block;

/**
 *  删除回复
 *
 *  @param CommentID
 *  @param postID
 *  @param block
 */
- (void)deleteTheCommentWithCommentId:(NSString *)commentID
                            andPostId:(NSString *)postID
                             Complete:(void (^)(HXSErrorCode code, NSString *message, NSString *statusStr))block;

/**
 *  获取用户收到的评论列表
 *
 *  @param pageSizeNum
 *  @param lastCommentID
 *  @param block
 */
- (void)fetchRepliesForMeWithPageSize:(NSNumber *)pageSizeNum
                 andWithLastCommentID:(NSString *)lastCommentID
                             Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXSCommunityCommentEntity *> *entityArray))block;

@end
