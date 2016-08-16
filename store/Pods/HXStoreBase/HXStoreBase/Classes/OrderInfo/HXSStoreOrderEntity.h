//
//  HXSStoreOrderEntity.h
//  store
//
//  Created by BeyondChao on 16/4/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

#import "HXSStoreCartItemEntity.h"

@interface HXSStoreOrderEntity : HXBaseJSONModel

/** 订单签名 */
@property (nonatomic, copy) NSString *orderSn;
/** 0待抢单,已提交  7配送中，骑士已抢单 2已送达  5已取消 */
@property (nonatomic, assign) NSInteger status;
/** 校园店订单，包括便利店、水果店 */
@property (nonatomic, assign) NSInteger orderType;
/** 支付类型 */
@property (nonatomic, assign) NSInteger payType; // 0表示现金，1表示支付宝，2表示微信公众号支付，3表示白花花，4表示支付宝扫码付，5表示微信刷开支付，6表示微信App支付, 8表示59钱包支付
/** 支付状态 */
@property (nonatomic, assign) NSInteger payStatus; // 0表示等待用户支付现金，10表示完成
/** 个数 */
@property (nonatomic, assign) NSInteger itemNum;
/** 总计 */
@property (nonatomic, strong) NSNumber *itemAmount;
/** 优惠券折扣 */
@property (nonatomic, assign) double couponDiscount;
/** 注销折扣 */
@property (nonatomic, assign) double promotionDiscount;
/** 合计的折扣 */
@property (nonatomic, strong) NSNumber *totalDiscount;
/** 实付(总计-总折扣) */
@property (nonatomic, strong) NSNumber *orderAmount;
/** 下单时间 */
@property (nonatomic, strong) NSNumber *orderCreateTime;
/** 支付时间 */
@property (nonatomic, strong) NSNumber *orderPayTime;
/** 配送时间 */
@property (nonatomic, strong) NSNumber *deliveryTime;
/** 订单取消时间 */
@property (nonatomic, strong) NSNumber *cancelTime;
/** 用户手机号 */
@property (nonatomic, copy) NSString *userPhone;
/** 配送费 */ 
@property (nonatomic, strong) NSNumber *deliveryFeeNum;
/** 具体地址 */
@property (nonatomic, copy) NSString *address;             //  "上海交通大学 东区 1号楼 3层",
/** 退款状态信息 */
@property (nonatomic, copy) NSString *refundStatusMsg;
/** 优惠券号 */
@property (nonatomic, copy) NSString *couponCode;
/** 留言备注 */
@property (nonatomic, copy) NSString *remark;
/** 卖家联系方式 */
@property (nonatomic, copy) NSString *sellerContact;
/** 骑士姓名 */
@property (nonatomic, copy) NSString *knightName;
/** 骑士联系方式 */
@property (nonatomic, copy) NSString *knightContact;

@property (nonatomic, strong) NSArray<HXSStoreCartItemEntity> *storeOrderItems; // 里面放着 HXSStoreCartItemEntity 模型
/** 商品附加信息 */
@property (nonatomic, copy) NSString *attachStr; // 支付时用来 order.productDescription = orderInfo.attach;

+ (instancetype)orderEntityWithDictionary:(NSDictionary *)orderDict;

@end
