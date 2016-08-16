//
//  HXSQRModel.h
//  store
//
//  Created by 格格 on 16/5/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSQRCodeEntity.h"

@interface HXSQRModel : NSObject

/**
 *  获取二维码信息
 *
 *  @param delivery_order_id 配送单号
 *  @param order_id          订单号
 *  @param shop_id           店铺id
 *  @param block
 */
+ (void)knightDelverlyOrderCodeWithDeliveryOrderId:(NSString *)delivery_order_id
                                           orderId:(NSString *)order_id
                                            shopId:(NSNumber *)shop_id
                                          complete:(void(^)(HXSErrorCode code, NSString * message, HXSQRCodeEntity * codeEntity))block;


@end
