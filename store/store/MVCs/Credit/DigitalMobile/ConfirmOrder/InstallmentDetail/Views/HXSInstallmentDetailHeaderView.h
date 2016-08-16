//
//  HXSInstallmentDetailHeaderView.h
//  store
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXSDigitalMobileInstallmentDetailViewController;
@class HXSDownpaymentEntity;
@class HXSDigitalMobileInstallmentDetailEntity;

@interface HXSInstallmentDetailHeaderView : UIView

@property (nonatomic, weak) HXSDigitalMobileInstallmentDetailViewController * controller;

/** 分期额度 */
@property (weak, nonatomic) IBOutlet UILabel *installmentAmountLabel;
/** 花费金额 */
@property (weak, nonatomic) IBOutlet UILabel *spendLabel;
/** 首付比例 */
@property (weak, nonatomic) IBOutlet UILabel *downPaymenLabel;
/** 首付金额 */
@property (weak, nonatomic) IBOutlet UILabel *paymentAmountLabel;
/** 分期金额 */
@property (weak, nonatomic) IBOutlet UILabel *intallmentMoneyLabel;

- (void)initInstallHeaderView:(HXSDigitalMobileInstallmentDetailEntity *)digitalMobileInstallmentDetail;
- (void)updateInstallHeaderView:(HXSDigitalMobileInstallmentDetailEntity *)digitalMobileInstallmentDetail;

@end
