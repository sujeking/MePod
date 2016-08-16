//
//  HXSLoanDetailView.m
//  store
//
//  Created by ArthurWang on 16/7/22.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSLoanDetailView.h"

@interface HXSLoanDetailView ()

@property (weak, nonatomic) IBOutlet UILabel *principalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthAmountLabel;


@end

@implementation HXSLoanDetailView


#pragma mark - Publice Methods

+ (instancetype)createLoanDetailViewWithServiceFee:(NSNumber *)serviceFeeDoubleNum
                                            amount:(NSNumber *)amountDoubleNum
{
    HXSLoanDetailView *detailView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSLoanDetailView class]) owner:nil options:nil] firstObject];
    
    detailView.principalAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [amountDoubleNum doubleValue] - [serviceFeeDoubleNum doubleValue]];
    detailView.serviceFeeLabel.text = [NSString stringWithFormat:@"￥%0.2f", [serviceFeeDoubleNum doubleValue]];
    detailView.monthAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [amountDoubleNum doubleValue]];
    
    return detailView;
}

@end
