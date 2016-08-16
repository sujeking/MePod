//
//  HXSDigitalMobileResultViewController.h
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSOrderInfo.h"

@interface HXSDigitalMobileResultViewController : HXSBaseViewController

- (void)initDataWithOrderInfo:(HXSOrderInfo *)orderInfo success:(BOOL)isSuccess;

@end
