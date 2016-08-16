//
//  HXSDigitalMobileOrderingInstallmentViewController.h
//  store
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSBaseViewController.h"
#import "HXSConfirmOrderEntity.h"

@interface HXSDigitalMobileOrderingInstallmentViewController : HXSBaseViewController

@property (nonatomic, weak) HXSConfirmOrderEntity *confirmOrderEntity;
@property (nonatomic, strong) HXSOrderInfo *orderInfo;

@end
