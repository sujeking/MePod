//
//  HXSPayBillConfirmInstallmentCell.m
//  store
//
//  Created by J006 on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPayBillConfirmInstallmentCell.h"

@interface HXSPayBillConfirmInstallmentCell()

@property (weak, nonatomic) IBOutlet UILabel      *leftTitleLabel;//本期账单一共
@property (weak, nonatomic) IBOutlet UILabel      *rightTitleLabel;//可分期金额

@end

@implementation HXSPayBillConfirmInstallmentCell


#pragma mark - init

- (void)awakeFromNib
{
    // Initialization code
}

- (void)initPayBillConfirmInstallmentWith:(NSString *)value
                                 andTitle:(NSString *)title
                                  andType:(HXSPayBillConfirmInstallmentCellType)type
{
    if(title)
        [_leftTitleLabel setText:title];
    if(value)
        [_rightTitleLabel setText:value];
    switch (type)
    {
        case HXSPayBillConfirmInstallmentCellTypeDate:
        {
            [_rightTitleLabel setTextColor:UIColorFromRGB(0x666666)];
            break;
        }
        case HXSPayBillConfirmInstallmentCellTypePrice:
        {
            [_rightTitleLabel setTextColor:UIColorFromRGB(0xf9a502)];
            break;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
