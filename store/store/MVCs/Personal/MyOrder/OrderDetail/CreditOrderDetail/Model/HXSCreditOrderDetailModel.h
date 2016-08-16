//
//  HXSCreditOrderDetailModel.h
//  store
//
//  Created by ArthurWang on 16/3/4.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCreditOrderDetailModel : NSObject

- (void)fetchCreditCardOrderInfoWithOrderInfo:(NSString *)orderSnStr
                                         type:(NSNumber *)typeIntNum
                                     complete:(void(^)(HXSErrorCode status, NSString *message, HXSOrderInfo *orderInfo))block;

- (void)cancelCreditCardOrderWithOrderSN:(NSString *)orderSnStr
                                    type:(NSNumber *)typeIntNum
                                complete:(void(^)(HXSErrorCode status, NSString *message, HXSOrderInfo *orderInfo))block;

- (void)confirmCreditCardOrderWithOrderSN:(NSString *)orderSnStr
                                complete:(void(^)(HXSErrorCode status, NSString *message, HXSOrderInfo *orderInfo))block;

@end
