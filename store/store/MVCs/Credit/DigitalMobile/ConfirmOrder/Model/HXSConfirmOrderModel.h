//
//  HXSConfirmOrderModel.h
//  store
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSConfirmOrderEntity.h"

@interface HXSConfirmOrderModel : NSObject

/*
 * 检查商品库存，按地址
 */
- (void)checkGoodsStockWithGoodsId:(NSNumber *)goodsId
                    andAddressCode:(NSString *)addressCode Complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *stockInfo))block;

/*
 * 分期购下单
 */
- (void)creaeOrderWithOrderInfo:(HXSConfirmOrderEntity *)confirmOrderEntity
                       Complete:(void (^)(HXSErrorCode code, NSString *message, HXSOrderInfo *orderInfo))block;

@end
