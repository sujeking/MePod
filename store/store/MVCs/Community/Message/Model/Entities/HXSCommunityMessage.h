//
//  HXSCommunityMessage.h
//  store
//
//  Created by 格格 on 16/4/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSCommunityCommentUser.h"

@interface HXSCommunityMessage : HXBaseJSONModel

@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSNumber *hostUidLongNum;
@property(nonatomic, strong) NSString *postIdStr;
@property(nonatomic, strong) NSString *postContentStr;
@property(nonatomic, strong) NSString *postCoverImgStr;
@property(nonatomic, strong) NSString *contentStr;
@property(nonatomic, strong) NSString *commentIdStr;
@property(nonatomic, strong) NSNumber *createTimeLongNum;
@property(nonatomic, strong) NSNumber *typeIntNum;
@property(nonatomic, strong) NSNumber *statusIntNum;
@property(nonatomic, strong) HXSCommunityCommentUser *guestUser;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
