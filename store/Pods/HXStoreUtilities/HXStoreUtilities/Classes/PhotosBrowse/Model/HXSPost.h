//
//  HXSPost.h
//  store
//
//  Created by 格格 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSCommunityCommentUser.h"
#import "HXBaseJSONModel.h"

@protocol HXSImage
@end

@interface HXSImage : HXBaseJSONModel

@property(nonatomic, strong) NSNumber *heightLongNum;
@property(nonatomic, strong) NSNumber *sizeLongNum;
@property(nonatomic, strong) NSNumber *widthLongNum;
@property(nonatomic, strong) NSString *urlStr;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end


/**
 *  点赞
 */
@protocol HXSLike 
@end
@interface HXSLike : HXBaseJSONModel

@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *postIdStr;
@property(nonatomic, strong) NSNumber *likeUidLongNum;
@property(nonatomic, strong) NSNumber *statusIntNum;
@property(nonatomic, strong) HXSCommunityCommentUser *likeUser;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
/**
 *  评论对象
 */
@protocol HXSComment
@end
@interface HXSComment : HXBaseJSONModel

@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *topicIdStr;
@property(nonatomic, strong) NSString *topicTitleStr;
@property(nonatomic, strong) NSString *postIdStr;
@property(nonatomic, strong) NSNumber *postUidLongNum;
@property(nonatomic, strong) NSString *postContentStr;
@property(nonatomic, strong) NSNumber *commentUidLongNum;
@property(nonatomic, strong) NSString *contentStr;
@property(nonatomic, strong) NSNumber *createTimeLongNum;
@property(nonatomic, strong) NSNumber *statusIntNum;
@property(nonatomic, strong) NSNumber *commentedUidLongNum;
@property(nonatomic, strong) NSString *commentedContentStr;

@property(nonatomic, strong) HXSCommunityCommentUser *commentUser;     //评论的人
@property(nonatomic, strong) HXSCommunityCommentUser *commentedUser;   //被评论的人
@property(nonatomic, strong) HXSCommunityCommentUser *postOwner;       //帖子主人

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end


/**
 *  帖子对象
 */
@interface HXSPost : HXBaseJSONModel

@property(nonatomic, strong) NSString *idStr; // 帖子id
@property(nonatomic, strong) NSString *userIdStr; // 用户id
@property(nonatomic, strong) NSNumber *viewCountNum; // 浏览量
@property(nonatomic, strong) NSString *userNameStr; // 用户名
@property(nonatomic, strong) NSString *userAvatarStr; // 用户头像
@property(nonatomic, strong) NSString *siteIdStr; // 学校id
@property(nonatomic, strong) NSString *siteNameStr; // 学校名称
@property(nonatomic, strong) NSString *topicIdStr; // 话题id
@property(nonatomic, strong) NSString *topicTitleStr; //话题标题
@property(nonatomic, strong) NSString *contentStr; // 内容
@property(nonatomic, strong) NSMutableArray *picturesArr; // 图片
@property(nonatomic, strong) NSNumber *createTimeLongNum; // 创建时间
@property(nonatomic, strong) NSNumber *likeCountLongNum; // 点赞数量
@property(nonatomic, strong) NSNumber *commentCountLongNum; // 评论数量
@property(nonatomic, strong) NSNumber *shareCountLongNum; // 分享数量
@property(nonatomic, strong) NSString *shareLinkStr; // 分享链接
@property(nonatomic, strong) NSNumber *isLikeIntNum; // 如果用户未登录，直接返回0，如果用户已登录，0 表示未点赞，1表示点赞
@property(nonatomic, strong) NSNumber *isOficialIntNum; // 1:官方

@property(nonatomic, strong) NSMutableArray<HXSComment> *commentListArr; // 评论列表
@property(nonatomic, strong) NSMutableArray<HXSLike> *likeListArr; // 点赞列表
@property(nonatomic, strong) NSMutableArray<HXSImage> *imagesArr; // 图片集合
@property(nonatomic, strong) HXSCommunityCommentUser *postUser;  //发帖的人

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
