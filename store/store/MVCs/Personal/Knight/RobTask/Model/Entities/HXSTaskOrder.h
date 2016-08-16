//
//  HXSTaskOrder.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTaskOrder : HXBaseJSONModel

/** 配送单号 */
@property (nonatomic, strong) NSString *deliveryOrderIdStr;
/** 当日配送单序号（待抢单为null） */
@property (nonatomic, strong) NSString *deliveryOrderSnStr;
/** 本单配送费（待抢单为null） */
@property (nonatomic, strong) NSNumber *rewardDoubleNum;
/** 骑士id（待抢单为null） */
@property (nonatomic, strong) NSNumber *knightIdLongNum;
/** 配送单状态（待抢单为null） */
@property (nonatomic, strong) NSNumber *statusIntNum;
/** 订单号 */
@property (nonatomic, strong) NSString *orderSnStr;
/** 买家留言 */
@property (nonatomic, strong) NSString *remarkStr;
/** 买家姓名 */
@property (nonatomic, strong) NSString *buyerName;
/** 买家电话 */
@property (nonatomic, strong) NSString *buyerPhone;
/** 买家地址 */
@property (nonatomic, strong) NSString *buyerAddress;
/** 商家老板姓名 */
@property (nonatomic, strong) NSString *shopBossStr;
/** 商家联系电话 */
@property (nonatomic, strong) NSString *shopPhoneStr;
/** 商家地址 */
@property (nonatomic, strong) NSString *shopAddressStr;
/** 最小配送费 */
@property (nonatomic, strong) NSNumber *minRewardDoubleNum;
/** 最大配送费 */
@property (nonatomic, strong) NSNumber *maxRewardDoubleNum;
/** 取消时间 */
@property (nonatomic, strong) NSNumber *cancelTimeLongNum;
/** 店铺id */
@property (nonatomic, strong) NSNumber *shopIdLongNum;
/** 订单序号 */
@property (nonatomic, strong) NSNumber *dateNoNum;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

// 待处理/已处理买家地址高度计算
- (double)buyerAddressAddHeight:(int)dwith;
// 待抢单买家地址高度计算
- (double)buyerAddressAddHeightRob:(int)dwith;
// 商家地址高度计算
- (double)shopAddressAddHeight:(int)dwith;
// 备注地址计算
- (double)remarkAddHeight:(int)dwith;

- (double)remarkAddHeightLessTwoLines:(int)dwith;

- (double)cellHeightWithBuyerAddressWidth:(int)buyerAddressdwidth shopAddressWidth:(int)shopAddressWidth remarkWidth:(int)remarkWidth;


@end
