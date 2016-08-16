//
//  HXSPayBillConfirmInstallmentSecondCell.m
//  store
//
//  Created by J006 on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPayBillConfirmInstallmentSecondCell.h"

@interface HXSPayBillConfirmInstallmentSecondCell()

@property (weak, nonatomic) IBOutlet UILabel *installmentAmountLabel;//月供

@end

@implementation HXSPayBillConfirmInstallmentSecondCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - init

- (void)initPayBillConfirmInstallmentSecondCellWithInstallmentAmount:(NSNumber *)amount
                                                        andMonthNums:(NSInteger)nums
{
    NSString *prevStr      = @"月供:";
    NSString *amoutNumStr  = [NSString stringWithFormat:@"¥%.2f",[amount doubleValue]];
    NSString *totalStr     = [NSString stringWithFormat:@"月供:%@x%ld期",amoutNumStr,(long)nums];
    NSMutableAttributedString *totalAttributeStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [totalAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf9a502) range:NSMakeRange(prevStr.length, amoutNumStr.length)];
    [_installmentAmountLabel setAttributedText:totalAttributeStr];
}

@end
