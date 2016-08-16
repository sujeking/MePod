//
//  HXSOrderRequest.m
//  store
//
//  Created by chsasaw on 14/12/3.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSOrderRequest.h"
#import "HXSCreateOrderParams.h"

@implementation HXSOrderRequest

- (void)getOrderInfoWithToken:(NSString *)token
                      orderSn:(NSString *)orderSn
                     complete:(void (^)(HXSErrorCode, NSString *, HXSOrderInfo *))block
{
    if (token == nil || orderSn == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:orderSn forKey:@"order_sn"];

    [HXStoreWebService getRequest:HXS_ORDER_INFO
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           HXSOrderInfo * info = [[HXSOrderInfo alloc] initWithDictionary:data];
                           block(kHXSNoError, msg, info);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)newDormOrderWithCreateOrderParams:(HXSCreateOrderParams *)createOrderParams
                                 compelte:(void (^)(HXSErrorCode code, NSString * message, HXSOrderInfo * orderInfo)) block
{
    if (nil == createOrderParams) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSDictionary *paramsDic = @{
                                @"dormentry_id":        createOrderParams.dormentryIDIntNum,
                                @"shop_id":             createOrderParams.shopIDIntNum,
                                @"delivery_type":       createOrderParams.deliveryTypeIntNum,
                                @"expect_start_time":   createOrderParams.expectStartTimeIntNum,
                                @"expect_end_time":     createOrderParams.expectEndTimeIntNum,
                                @"dormitory":           createOrderParams.dormitoryStr,
                                @"phone":               createOrderParams.phoneStr,
                                @"coupon_code":         createOrderParams.couponCodeStr,
                                @"verification_code":   createOrderParams.verificationCodeStr,
                                @"remark":              createOrderParams.remarkStr,
                                };
    
    [HXStoreWebService postRequest:HXS_NIGHT_CAT_ORDER_CREATE
                 parameters:paramsDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            HXSOrderInfo * info = [[HXSOrderInfo alloc] initWithDictionary:data];
                            block(kHXSNoError, msg, info);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
    
}

- (void)changeOrderPayTypeWithToken:(NSString *)token
                           order_sn:(NSString *)order_sn
                            payType:(int)payType
                           compelte:(void (^)(HXSErrorCode, NSString *, HXSOrderInfo *))block
{
    if (token == nil || order_sn == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:order_sn forKey:@"order_sn"];
    [dic setObject:[NSNumber numberWithInt:payType] forKey:@"paytype"];
    
    [HXStoreWebService postRequest:HXS_ORDER_CHANGEPAYTYPE
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            HXSOrderInfo * info = [[HXSOrderInfo alloc] initWithDictionary:data];
                            block(kHXSNoError, msg, info);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

- (void)cancelOrderWithToken:(NSString *)token
                    order_sn:(NSString *)order_sn
                    compelte:(void (^)(HXSErrorCode, NSString *, HXSOrderInfo *))block
{
    if (token == nil || order_sn == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:order_sn forKey:@"order_sn"];
    
    [HXStoreWebService postRequest:HXS_ORDER_CANCEL
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            HXSOrderInfo * info = [[HXSOrderInfo alloc] initWithDictionary:data];
                            block(kHXSNoError, msg, info);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
    
}

@end