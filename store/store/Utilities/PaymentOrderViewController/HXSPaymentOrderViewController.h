//
//  HXSPaymentOrderViewController.h
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSBaseViewController.h"

@interface HXSPaymentOrderViewController : HXSBaseViewController

/**
 *  设置支付信息
 *
 *  @param orderinfo 订单信息
 *  @param install 是否分期
 */
+ (instancetype)createPaymentOrderVCWithOrderInfo:(HXSOrderInfo *)orderInfo installment:(BOOL)installment;

@end