//
//  HXSPaymentOrderModel.h
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSActionSheetEntity.h"
@interface HXSPaymentOrderModel : NSObject

/**
 *  获取支付方式
 *
 *  @param orderTypeNum        订单号
 *  @param payAmountFloatNum   支付金额
 *  @param isInstallmentIntNum 
 */
+ (void)fetchPayMethodsWith:(NSNumber *)orderTypeNum
                  payAmount:(NSNumber *)payAmountFloatNum
                installment:(NSNumber *)isInstallmentIntNum
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *payArr))block;
@end
