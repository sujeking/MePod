//
//  HXSOrderPayTableViewCell.m
//  store
//
//  Created by ArthurWang on 15/7/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSOrderPayTableViewCell.h"

@implementation HXSOrderPayTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}


#pragma mark - Public Methods

- (void)setupOrderPayCellWithDiscountDetail:(HXSOrderDiscountDetail *)discountDetail
{
    self.ordrePayCouponNameLabel.text = discountDetail.discountDescStr;
    self.orderPayPriceLabel.text      = [NSString stringWithFormat:@"-￥%0.2f", [discountDetail.discountAmountFloatNum doubleValue]];
}

@end
