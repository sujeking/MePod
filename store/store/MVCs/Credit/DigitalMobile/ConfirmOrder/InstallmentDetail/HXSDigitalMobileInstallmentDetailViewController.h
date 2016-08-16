//
//  HXSDigitalMobileInstallmentDetailViewController.h
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSConfirmOrderEntity.h"

@protocol HXSSelectInstallmentDetailDelegate <NSObject>

- (void)didSelectInstallmentDetail:(HXSConfirmOrderEntity *)confirmOrderEntity;

@end

@interface HXSDigitalMobileInstallmentDetailViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSSelectInstallmentDetailDelegate> delegate;

- (void)initDigitalMobileInstallmentDetailEntity:(HXSConfirmOrderEntity *)confirmOrderEntity;
/*
 * 选择首付比例
 */
- (void)selectDownPayment;

@end
