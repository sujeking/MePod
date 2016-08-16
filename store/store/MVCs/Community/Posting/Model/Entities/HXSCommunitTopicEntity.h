//
//  HXSCommunitTopicEntity.h
//  store
//
//  Created by J006 on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXSCommunitTopicStatusType)
{
    kHXSCommunitTopicStatusTypeNormal = 0,//正常
    kHXSCommunitTopicStatusTypeDelete = -1,//已删除
};

@interface HXSCommunitTopicEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *idStr;// id
@property (nonatomic, strong) NSString *titleStr;// title
@property (nonatomic, strong) NSString *avatarStr;// avatar
@property (nonatomic, strong) NSString *introStr;// intro
@property (nonatomic, strong) NSNumber *weightNum;// weight
@property (nonatomic, readwrite) HXSCommunitTopicStatusType     statusNum;// status

@end
