//
//  HXSCommunityCommentUser.m
//  store
//
//  Created by J006 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityCommentUser.h"

@implementation HXSCommunityCommentUser

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *guestUserMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"uidNum",           @"uid",
                                   @"userNameStr",      @"user_name",
                                   @"userAvatarStr",    @"user_avatar",
                                   nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:guestUserMapping];
}

- (id)copyWithZone:(NSZone *)zone
{
    HXSCommunityCommentUser *copy = [[HXSCommunityCommentUser allocWithZone:zone] init];
    
    [copy setUidNum:self.uidNum];
    [copy setUserNameStr:self.userNameStr];
    [copy setUserAvatarStr:self.userAvatarStr];
    [copy setUserType:self.userType];
    
    return copy;
}

@end
