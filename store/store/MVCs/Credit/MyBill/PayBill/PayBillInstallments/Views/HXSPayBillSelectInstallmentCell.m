//
//  HXSPayBillSelectInstallmentCell.m
//  store
//
//  Created by J006 on 16/3/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPayBillSelectInstallmentCell.h"

@interface HXSPayBillSelectInstallmentCell()

@property (weak, nonatomic) IBOutlet UILabel *monthNumsLabel;

@end

@implementation HXSPayBillSelectInstallmentCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark - init

- (void)initPayBillSelectInstallmentCellWithMonthNums:(NSInteger)nums
{
    [_monthNumsLabel setText:[NSString stringWithFormat:@"%ld个月",(long)nums]];
}

@end
