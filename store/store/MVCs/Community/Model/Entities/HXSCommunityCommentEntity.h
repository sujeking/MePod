//
//  HXSCommunityCommentEntity.h
//  store
//
//  Created by J006 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSCommunityCommentUser.h"

typedef NS_ENUM(NSInteger, HXSCommunityCommentType)
{
    kHXSCommunityCommentTypeNoCommenter   = 0,// 0:被评论人为空
    kHXSCommunityCommentTypeHasCommenter  = 1,//1：被评论人不为空
};

@interface HXSCommunityCommentEntity : HXBaseJSONModel

/**"comment_id":"评论id" */
@property (nonatomic ,strong) NSString *commentIDStr;
/**"post_id":"帖子id" */
@property (nonatomic ,strong) NSString *postIDStr;
/**"topic_id" */
@property (nonatomic ,strong) NSString *topicIDStr;
/**"topic_title" */
@property (nonatomic ,strong) NSString *topicTitleStr;
/**post_content":"帖子内容" */
@property (nonatomic ,strong) NSString *postContentStr;
/**"comment_content": "评论内容" */
@property (nonatomic ,strong) NSString *commentContentStr;
/**"commented_content": "被评论人 评论内容" */
@property (nonatomic ,strong) NSString *commentedContentStr;
/**"comment_type": 0/1     // 0:被评论人为空，1：被评论人不为空 */
@property (nonatomic ,readwrite) HXSCommunityCommentType commentType;
//**create_time": "评论时间" */
@property (nonatomic ,strong) NSNumber *createTimeNum;
//**post_owner" 帖子主人 */
@property (nonatomic ,strong) HXSCommunityCommentUser *postOwner;
//**comment_user" 评论人 */
@property (nonatomic ,strong) HXSCommunityCommentUser *commentUser;
//**commented_user"://被评论人 */
@property (nonatomic ,strong) HXSCommunityCommentUser *commentedUser;

@end
