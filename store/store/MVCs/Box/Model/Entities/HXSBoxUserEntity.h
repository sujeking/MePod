//
//  HXSBoxUserEntity.h
//  store
//
//  Created by 格格 on 16/6/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXSBoxUserStatus){
    HXSBoxUserStatusBoxer    = 0, // 盒主
    HXSBoxUserStatusSharer   = 1  // 分享者
};

typedef NS_ENUM(NSInteger, HXSBoxShareStatus){
    HXSBoxShareStatusNormal   = 0, // 正常
    HXSBoxShareStatusRemoved  = 1, // 被移除
    HXSBoxShareStatusQuit     = 2, // 已退出
    HXSBoxShareStatusLast     = 3  // 上一期
};

typedef NS_ENUM(NSInteger, HXSBoxTransferStatus){
    HXSBoxTransferStatusNormal   = 0, // 正常
    HXSBoxTransferStatusTransfer = 1, // 转让中
};

@interface HXSBoxUserEntity : HXBaseJSONModel

/** 用户ID */
@property (nonatomic, strong) NSNumber *uidNum;
/** 姓名 */
@property (nonatomic, strong) NSString *unameStr;
/** 本期已付金额 */
@property (nonatomic, strong) NSNumber *paidAmountDoubleNum;
/** 0-盒主、1-共享人 */
@property (nonatomic, strong) NSNumber *typeNum;
/** 共享人状态 （0-当前共享人、1-已被移除、2-已退出） */
@property (nonatomic, strong) NSNumber *statusNum;
/** 0:正常，1:转让中 */
@property (nonatomic, strong) NSNumber *transferStatusNum;
/** 电话 */
@property (nonatomic, strong) NSString *phoneStr;
/** 楼栋ID */
@property (nonatomic, strong) NSNumber *dormentryIdNum;
/** 寝室号 */
@property (nonatomic, strong) NSString *roomStr;
/** 性别 */
@property (nonatomic, strong) NSNumber *genderNum;
/** 入学年份 */
@property (nonatomic, strong) NSNumber *enrollmentYearNum;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

- (NSString *)statusStr;

@end
