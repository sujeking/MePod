//
//  HXSTaskOrderDetial.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HXSTaskItem
@end

@interface HXSTaskItem : HXBaseJSONModel

/** 商品id */
@property (nonatomic, strong) NSNumber *idIntNum;
/** 商品名 */
@property (nonatomic, strong) NSString *nameStr;
/** 图片 */
@property (nonatomic, strong) NSString *imageStr;
/** 价格 */
@property (nonatomic, strong) NSNumber *priceDoubleNum;
/** 商品总额 */
@property (nonatomic, strong) NSNumber *amountDoubleNum;
/** 购买数量 */
@property (nonatomic, strong) NSNumber *quantityIntNum;

@end


@interface HXSTaskOrderDetial : HXBaseJSONModel

/** 配送单号 */
@property (nonatomic, strong) NSString *deliveryOrderStr;
/** 骑士id */
@property (nonatomic, strong) NSString *knightIdStr;
/** 订单id */
@property (nonatomic, strong) NSString *orderSnStr;
/* 配送状态  1:待取货 2:配送中 3: 已完成 4:* 已取消 */
@property (nonatomic, strong) NSNumber *statusIntNum;
/** 下单时间 */
@property (nonatomic, strong) NSNumber *createTimeLongNum;
/** 接单时间（待取货订单有值） */
@property (nonatomic, strong) NSNumber *confirmTimeLongNum;
/** 取货时间（配送中订单有值） */
@property (nonatomic, strong) NSNumber *claimTimeLongNum;
/** 完成时间（已完成、已取消订单有值） */
@property (nonatomic, strong) NSNumber *finishTimeLongNum;
/** 最大配送费 */
@property (nonatomic, strong) NSNumber *minRewardDoubleNum;
/** 最小配送费 */
@property (nonatomic, strong) NSNumber *maxRewardDoubleNum;
/* 本单收入(已完成订单* 有值) */
@property (nonatomic, strong) NSNumber *rewardDoubleNum;
/** 买家姓名 */
@property (nonatomic, strong) NSString *buyerNamestr;
/** 买家电话 */
@property (nonatomic, strong) NSString *buyerPhoneStr;
/** 买家地址 */
@property (nonatomic, strong) NSString *buyerAddressStr;
/** 备注 */
@property (nonatomic, strong) NSString *remarkStr;
/** 店铺老板 */
@property (nonatomic, strong) NSString *shopBossStr;
/** 店铺联系方式 */
@property (nonatomic, strong) NSString *shopPhoneStr;
/** 店铺地址 */
@property (nonatomic, strong) NSString *shopAddressStr;
/** 商品总件数 */
@property (nonatomic, strong) NSNumber *itemIntNum;
/** 商品总价值 */
@property (nonatomic, strong) NSNumber *itemAmountDoubleNum;
/** 配送单二维码，（用于确认送达） */
@property (nonatomic, strong) NSString *deliveryOrderUrlStr;

@property (nonatomic, strong) NSMutableArray<HXSTaskItem> *itemsArr;
/** 取消时间 */
@property (nonatomic, strong) NSNumber *cancelTimeLongNum;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

- (double)buyerAddressAddHeight:(int)dwith;
- (double)shopAddressAddHeight:(int)dwith;
- (double)remarkAddHeight:(int)dwith;

@end
