//
//  HXSBoxInfoEntity.h
//  store
//
//  Created by ArthurWang on 16/5/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXSBoxStatus){
    kHXSBoxStatusNotApply = 0, // 未申请
    kHXSBoxStatusApplyed  = 1, // 已提交
    kHXSBoxStatusDispath  = 2, // 配送中
    kHXSBoxStatusNormal   = 3, // 正常
    kHXSBoxStatusChecking = 4, // 清点中
    kHXSBoxStatusClearing = 5, // 结算中
};

typedef NS_ENUM(NSInteger, HXSBoxRelatedStatus){
    HXSBoxUserStatusNo    = 0, // 不是盒子主人
    HXSBoxUserStatusYes   = 1  // 是盒子主人
};

typedef NS_ENUM(NSInteger, HXSBoxLastBillStatus){
    HXSBoxLastBillStatusNo    = 0, // 没上期账单
    HXSBoxLastBillStatusYes   = 1  // 有上期账单
};

@interface HXSBoxRelatedEntity : HXBaseJSONModel

/** 姓名 */
@property (nonatomic, strong) NSString *userNameStr;
/** 电话 */
@property (nonatomic, strong) NSString *phoneStr;
/** 楼栋id */
@property (nonatomic, strong) NSNumber *dormentryIdNum;
/** 地址 */
@property (nonatomic, strong) NSString *addressStr;
/** 寝室号 */
@property (nonatomic, strong) NSString *roomStr;
/** 性别 */
@property (nonatomic, strong) NSNumber *genderNum;
/** 入学年份 */
@property (nonatomic, strong) NSNumber *enrollmentYearNum;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end


@interface HXSBoxInfoEntity : HXBaseJSONModel

/** 盒子ID */
@property (nonatomic, strong) NSNumber *boxIdNum;
/** 是否盒主 1:是,0:否 */
@property (nonatomic, strong) NSNumber *isBoxerNum;
/** 批次号 */
@property (nonatomic, strong) NSNumber *batchNoNum;
/** 是否有上期账单 1:是,0:否 */
@property (nonatomic, strong) NSNumber *hasLastBillNum;
/** 共享用户数 */
@property (nonatomic, strong) NSNumber *sharedUserNum;
/** 盒主头像 */
@property (nonatomic, strong) NSString *boxerAvatarStr;
/** 零食盒子状态 */
@property (nonatomic, strong) NSNumber *statusNum;
/** 店长信息 */
@property (nonatomic, strong) HXSBoxRelatedEntity *dormInfo;
/** 盒主信息 */
@property (nonatomic, strong) HXSBoxRelatedEntity *boxerInfo;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
