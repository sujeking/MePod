//
//  HXSRobTaskModel.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSTaskOrder.h"

@interface HXSRobTaskModel : NSObject

/**
 *  查询任务列表
 *
 *  @param status 0待抢单 1待处理 2已处理
 *  @param page
 *  @param size
 *  @param block
 */
+ (void)getKnightDeliveryOrderListWithStatus:(NSNumber *)status
                                        page:(NSNumber *)page
                                        size:(NSNumber *)size
                                    complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * orders))block;


/**
 *  查询已完成订单
 *
 *  @param page
 *  @param size
 *  @param block
 */
+ (void)getKnightDeliveryListHadledWithPage:(NSNumber *)page
                                       size:(NSNumber *)size
                                   complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * orders))block;

/**
 *  抢单
 *
 *  @param order_sn 订单号
 *  @param block
 */
+ (void)robTaskWithOrderSn:(NSString *)order_sn
                  complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary * dic))block;

@end
