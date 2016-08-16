//
//  HXSOrderRequest.h
//  store
//
//  Created by chsasaw on 14/12/3.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXSCreateOrderParams;

@interface HXSOrderRequest : NSObject

- (void)getOrderInfoWithToken:(NSString *)token
                      orderSn:(NSString *)orderSn
                     complete:(void (^)(HXSErrorCode code, NSString * message, HXSOrderInfo * orderInfo)) block;

- (void)newDormOrderWithCreateOrderParams:(HXSCreateOrderParams *)createOrderParams
                     compelte:(void (^)(HXSErrorCode code, NSString * message, HXSOrderInfo * orderInfo)) block;

- (void)cancelOrderWithToken:(NSString *)token
                    order_sn:(NSString *)order_sn
                    compelte:(void (^)(HXSErrorCode code, NSString * message, HXSOrderInfo * orderInfo)) block;

- (void)changeOrderPayTypeWithToken:(NSString *)token
                           order_sn:(NSString *)order_sn
                            payType:(int)type
                           compelte:(void (^)(HXSErrorCode code, NSString * message, HXSOrderInfo * orderInfo)) block;

@end
