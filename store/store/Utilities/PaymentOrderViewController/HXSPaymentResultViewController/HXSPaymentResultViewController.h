//
//  HXSPaymentResultViewController.h
//  store
//
//  Created by ArthurWang on 16/5/12.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"


@interface HXSPaymentResultViewController : HXSBaseViewController

+ (instancetype)createPaymentResultVCWithOrderInfo:(HXSOrderInfo *)orderInfo result:(BOOL)result;

@end
