//
//  HXSBoxMessageModel.h
//  store
//
//  Created by 格格 on 16/6/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kHXSBoxMessageEventTypeShare     = 0, // 共享
    kHXSBoxMessageEventTypeTransfer  = 1, // 转让
} kHXSBoxMessageEventType;

typedef enum : NSUInteger {
    kHXSBoxMessageEventButtonTypeSure    = 0, // 确定(不执行任何操作)
    kHXSBoxMessageEventButtonTypeReject  = 1, // 拒绝(点击后请求接口)
    kHXSBoxMessageEventButtonTypeAccept  = 2, // 接受(点击后请求接口)
} kHXSBoxMessageEventButtonType;

typedef enum : NSUInteger {
    kHXSBoxMessageStatusUnread  = 0,  // 未读
    kHXSBoxMessageStatusReaded  = 1,  // 已读
    kHXSBoxMessageStatusDeleted = 2,  // 删除
} kHXSBoxMessageStatus;


// 消息响应按钮 0确定 1拒绝 2接受
@interface HXSBoxMessagEvent : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *typeNum; // 0：共享 1:转让
@property (nonatomic, strong) NSArray *buttonArr; // 0:确定(不执行任何操作) 1:拒绝(点击后请求接口) 2:接受(点击后请求接口)

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end

@interface HXSBoxMessageModel : HXBaseJSONModel

@property (nonatomic, strong) NSString *messageIdStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSNumber *createTimeNum;
@property (nonatomic, strong) NSNumber *statusNum;
@property (nonatomic, strong) NSNumber *typeNum;  // 消息类型155为盒子专用消息 (4.2新增)
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, strong) HXSBoxMessagEvent *event;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
