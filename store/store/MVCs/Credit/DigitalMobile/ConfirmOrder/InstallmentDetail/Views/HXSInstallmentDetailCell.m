//
//  HXSInstallmentDetailCell.m
//  store
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSInstallmentDetailCell.h"
#import "HXSInstallmentEntity.h"

@implementation HXSInstallmentDetailCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initCellLabel:(HXSInstallmentItemEntity *)installmentItem
{
    self.monthLabel.text = [NSString stringWithFormat:@"%li个月",(long)installmentItem.installmentNum.integerValue];
    self.installmentMonthLabel.text = [NSString stringWithFormat:@"￥%0.2f×%li期",installmentItem.installmentMoney.doubleValue,(long)installmentItem.installmentNum.integerValue];
    self.installmentAccount.text = [NSString stringWithFormat:@"含手续费：￥%0.2f每期",installmentItem.chargeMoney.floatValue];
}
@end
