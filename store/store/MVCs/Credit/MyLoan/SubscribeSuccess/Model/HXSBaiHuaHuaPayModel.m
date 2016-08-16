//
//  HXSBaiHuaHuaPayModel.m
//  store
//
//  Created by ArthurWang on 15/8/17.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaiHuaHuaPayModel.h"

@implementation HXSBaiHuaHuaPayModel

#pragma mark - Public Methods

- (void)payCreditCardPayment:(NSDictionary *)paymentDic
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *paymentInfo))block
{
    [HXStoreWebService postRequest:HXS_CREDITCARD_TRADE
                 parameters:paymentDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (kHXSNoError == status) {
                            block(kHXSNoError, msg, data);
                        } else {
                            block(status, msg, nil);
                        }
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}


@end
