//
//  HXSInstallmentDetailHeaderView.m
//  store
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSInstallmentDetailHeaderView.h"
#import "HXSDigitalMobileInstallmentDetailViewController.h"
#import "HXSDownpaymentEntity.h"
#import "HXSDigitalMobileInstallmentDetailEntity.h"

@implementation HXSInstallmentDetailHeaderView

- (void)initInstallHeaderView:(HXSDigitalMobileInstallmentDetailEntity *)digitalMobileInstallmentDetail
{
    self.installmentAmountLabel.text = [NSString stringWithFormat:@"￥%@",digitalMobileInstallmentDetail.installmentLimit];
    self.spendLabel.text = [NSString stringWithFormat:@"￥%0.2f",digitalMobileInstallmentDetail.spend.floatValue];
}

- (void)updateInstallHeaderView:(HXSDigitalMobileInstallmentDetailEntity *)digitalMobileInstallmentDetail
{
    self.downPaymenLabel.text = [NSString stringWithFormat:@"%@",digitalMobileInstallmentDetail.downpayment.percentDesc];
    self.paymentAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f",digitalMobileInstallmentDetail.downpayment.percent.floatValue * digitalMobileInstallmentDetail.spend.floatValue];
    self.intallmentMoneyLabel.text = [NSString stringWithFormat:@"￥%0.2f",digitalMobileInstallmentDetail.spend.floatValue * (1 - digitalMobileInstallmentDetail.downpayment.percent.floatValue)];
}

- (IBAction)selectDownPayment:(id)sender
{
    [self.controller performSelector:@selector(selectDownPayment) withObject:nil];
}


@end
