//
//  HXSPrintModel.h
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
// Model
#import "HXSMyPrintOrderItem.h"
#import "HXSPrintCartEntity.h"
#import "HXSPrintOrderInfo.h"
#import "HXSPrintDownloadsObjectEntity.h"
#import "HXSMainPrintTypeEntity.h"

@interface HXSPrintModel : NSObject

/**
 * 云印店 订单列表
 */
+ (void)getPrintOrderListWithPage:(int)page
                         complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * orders)) block;

/** 
 * 云印店 订单详情
 */
+ (void)getPrintOrderDetialWithOrderSn:(NSString *)orderSn
                              complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *printOrder))block;

/**
 * 云印店 取消订单
 */
+ (void)cancelPrintOrderWithOrderSn:(NSString *)orderSn
                           complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;

/** 
 * 云印店 订单更改支付方式
 */
+ (void)changePrintOrderPayType:(NSString *)orderSn
                       complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;


/**
 *  云印店 计算订单价格 创建购物车
 *
 *  @param printCartEntity  购物车实体
 *  @param shopid           店铺id
 *  @param openAd           是否使用福利纸
 *  @param block
 */
+ (void)createOrCalculatePrintOrderWithPrintCartEntity:(HXSPrintCartEntity *)printCartEntity
                                                shopId:(NSNumber *)shopid
                                                openAd:(NSNumber *)openAd
                                              complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintCartEntity *printCartEntity))block;

/**
 *  云印店 下单
 *
 *  @param coupon_code       优惠券code (不使用优惠券不传这个值)
 *  @param phone             手机号码
 *  @param address           寝室地址
 *  @param remark            备注
 *  @param pay_type          支付方式
 *  @param dormentry_id      用户所在楼栋id
 *  @param shop_id           店铺id
 *  @param open_ad           是否免费打印 0不开启  1开启免费打印
 *  @param block
 */
+ (void)createPrintOrderWithPhone:(NSString *)phone
                              address:(NSString *)address
                               remark:(NSString *)remark
                             pay_type:(NSNumber *)pay_type
                         dormentry_id:(NSNumber *)dormentry_id
                              shop_id:(NSNumber *)shop_id
                              open_ad:(NSNumber *)open_ad
                    printOrderEntity:(HXSPrintCartEntity *)printCartEntity
                              apiStr:(NSString *)apiStr
                             complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *orderInfo))block;

/**
 *  上传文档
 *
 *  @param entity
 *  @param block
 */
- (NSURLSessionDataTask *)uploadTheDocument:(HXSPrintDownloadsObjectEntity *)entity
                                   complete:(void (^)(HXSErrorCode code, NSString *message, HXSMyPrintOrderItem *orderItem))block;
/**
 *  设置打印主界面中所有支持的打印类型集合
 *
 *  @return
 */
+ (NSArray<HXSMainPrintTypeEntity *> *)createTheMainPrintTypeArray;

@end
