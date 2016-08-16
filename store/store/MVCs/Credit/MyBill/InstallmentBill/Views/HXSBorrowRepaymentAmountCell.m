//
//  HXSBorrowRepaymentAmountCell.m
//  store
//
//  Created by hudezhi on 15/8/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowRepaymentAmountCell.h"

@interface HXSBorrowRepaymentAmountCell ()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeaddingConstraint;

@property (weak, nonatomic) IBOutlet UIView *expandContainerView;
@property (weak, nonatomic) IBOutlet UILabel *totalBorrowAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentRepaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentRepaymentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expandPurposeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandingLabelLeaddingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *purposeImageView;

@end

@implementation HXSBorrowRepaymentAmountCell

- (void)awakeFromNib
{
//    _imageLeaddingConstraint.constant = -10;
    self.clipsToBounds = YES;
}

- (void)setRecord:(HXSBillRepaymentItem *)record
{
    _record = record;
    
    _amountLabel.text = [NSString stringWithFormat:@"￥ %0.2f", _record.repaymentAmountNum.doubleValue];
    _purposeLabel.text = _record.installmentTextStr;
    _dateLabel.text = [HTDateConversion stringFromDate:_record.repaymentDate formatString:@"yyyy-MM-dd"]; // 还款时间
    _dateLabel.textColor = _record.repaymentStatusNum.intValue == 2 ? [UIColor colorWithRGBHex:0xF54642] :[UIColor colorWithRGBHex:0x666666];
    
    _stateImageView.image = _record.repaymentStatusNum.intValue == 2 ? [UIImage imageNamed:@"img_overdue"] : nil;
    
    _totalBorrowAmountLabel.text = [NSString stringWithFormat:@"借款总额:  %0.2f", _record.installmentAmountNum.doubleValue];
    _borrowDateLabel.text = [NSString stringWithFormat:@"借款日期:  %@", [HTDateConversion stringFromDate:_record.installmentDate formatString:@"yyyy-MM-dd"]];
    _periodCountLabel.text = [NSString stringWithFormat:@"期数:  %d/%d", _record.repaymentNumberNum.intValue, _record.installmentNumberNum.intValue];
    _currentRepaymentLabel.text = [NSString stringWithFormat:@"本期应还:  %0.2f", _record.repaymentAmountNum.doubleValue];
    _currentRepaymentDateLabel.text = [NSString stringWithFormat:@"本期还款日:  %@", [HTDateConversion stringFromDate:_record.repaymentDate formatString:@"yyyy-MM-dd"]];
    _expandPurposeLabel.text = [NSString stringWithFormat:@"用途:  %@", _record.installmentPurposeStr];
    
    NSString *purposeImgURL = [_record.installmentImageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_purposeImageView sd_setImageWithURL:[NSURL URLWithString:purposeImgURL]];
}

@end
