//
//  HXSDigitalMobileInstallmentTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileInstallmentTableViewCell.h"

@interface HXSDigitalMobileInstallmentTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *downPaymentAmountLabel;  // "￥0.00"
@property (weak, nonatomic) IBOutlet UILabel *installmentAmountLabel;  // "￥0.00"
@property (weak, nonatomic) IBOutlet UILabel *repaymentAmountLabel;    // "￥0.00 x 7期"

@end

@implementation HXSDigitalMobileInstallmentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupCellWithOrderInfo:(HXSOrderInfo *)orderInfo
{
    // 首付金额
    self.downPaymentAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [orderInfo.downPaymentFloatNum floatValue]];
    
    // 分期金额
    self.installmentAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [orderInfo.installmentAmountFloatNum floatValue]];
    
    // 每期金额 x 期数
    self.repaymentAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f x %ld期", [orderInfo.repaymentAmountFloatNum floatValue], [orderInfo.installmentNumIntNum longValue]];
}

@end
