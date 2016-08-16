//
//  HXSCommunityCommentUser.h
//  store
//
//  Created by J006 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

typedef NS_ENUM(NSInteger, HXSCommunityCommentUserType)
{
    kHXSCommunityCommentUserTypeOwner       = 0,//帖子主人
    kHXSCommunityCommentUserTypeCommenter   = 1,//评论人
    kHXSCommunityCommentUserTypeCommented   = 2,//被评论人
    kHXSCommunityCommentUserTypeNormal      = 3,//普通用户
};

@interface HXSCommunityCommentUser : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *uidNum; ///long型
@property (nonatomic, strong) NSString *userNameStr; //"user_name": "用户名"
@property (nonatomic, strong) NSString *userAvatarStr; //"user_avatar" :"url"
@property (nonatomic, assign) HXSCommunityCommentUserType userType; //用户类型

/**
 *  深层拷贝
 */
- (id)copyWithZone:(NSZone *)zone;

@end
