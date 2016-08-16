//
//  HXSCreditOrderDetailModel.m
//  store
//
//  Created by ArthurWang on 16/3/4.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditOrderDetailModel.h"

@implementation HXSCreditOrderDetailModel

- (void)fetchCreditCardOrderInfoWithOrderInfo:(NSString *)orderSnStr
                                         type:(NSNumber *)typeIntNum
                                     complete:(void(^)(HXSErrorCode status, NSString *message, HXSOrderInfo *orderInfo))block
{
    NSDictionary *parametersDic = @{
                                    @"order_sn": orderSnStr,
                                    @"type":     typeIntNum
                                    };
    
    [HXStoreWebService getRequest:HXS_CHARGE_CENTER_ORDER_INFO
                parameters:parametersDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] initWithDictionary:data];
                       
                       block(status, msg, orderInfo);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)cancelCreditCardOrderWithOrderSN:(NSString *)orderSnStr
                                    type:(NSNumber *)typeIntNum
                                complete:(void(^)(HXSErrorCode status, NSString *message, HXSOrderInfo *orderInfo))block
{
    NSDictionary *parametersDic = @{
                                    @"order_sn": orderSnStr,
                                    @"type":     typeIntNum
                                    };
    
    [HXStoreWebService postRequest:HXS_CHARGE_CENTER_ORDER_CANCEL
                parameters:parametersDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] initWithDictionary:data];
                       
                       block(status, msg, orderInfo);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)confirmCreditCardOrderWithOrderSN:(NSString *)orderSnStr
                                 complete:(void(^)(HXSErrorCode status, NSString *message, HXSOrderInfo *orderInfo))block
{
    NSDictionary *parametersDic = @{
                                    @"order_sn": orderSnStr,
                                    };
    
    [HXStoreWebService postRequest:HXS_TIP_ORDER_CONFIRM
                parameters:parametersDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] initWithDictionary:data];
                       
                       block(status, msg, orderInfo);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

@end
