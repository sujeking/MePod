//
//  HXSTaskDetialModel.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSTaskOrderDetial.h"

@interface HXSTaskDetialModel : NSObject

/**
 *  查询订单详情
 *
 *  @param delivery_order_id 配送单号
 *  @param block             
 */
+ (void)getTaskOrderDerialWithDeliveryOrderId:(NSString *)delivery_order_id
                                      complete:(void(^)(HXSErrorCode code, NSString * message, HXSTaskOrderDetial * orderDetial))block;
/**
 *  取消订单
 *
 *  @param delivery_order_id 配送单号
 *  @param block
 */
+ (void)cancleKnightDeliveryOrderWithDeliveryorderId:(NSString *)delivery_order_id
                                            complete:(void(^)(HXSErrorCode code, NSString * message,NSDictionary * dic))block;

/**
 *  完成订单
 *
 *  @param delivery_order_id 配送单号
 *  @param block
 */
+ (void)finishKnightDeliveryOrderWithDeliveryOrderId:(NSString *)delivery_order_id
                                            complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary * dic))block;



@end
