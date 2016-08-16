//
//  HXSBorrowRepaymentPlanCell.m
//  store
//
//  Created by hudezhi on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowRepaymentPlanCell.h"

@interface HXSBorrowRepaymentPlanCell()

@property (nonatomic) int state;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *leftCircle;

@end

@implementation HXSBorrowRepaymentPlanCell

- (void)awakeFromNib {
    // Initialization code
    
    _leftCircle.layer.masksToBounds = YES;
    _leftCircle.layer.cornerRadius = 6.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setState:(int)state
{
    _state = state;
    switch (state) {
        case 0:
            _dateLabel.textColor = [UIColor colorWithRGBHex:0x999999];
            _moneyAmountLabel.textColor = [UIColor colorWithRGBHex:0x999999];
            _statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            _statusLabel.text = @"待还款";
            _leftCircle.backgroundColor = [UIColor colorWithRGBHex:0x07A9FA];
            break;
        case 1:
            _dateLabel.textColor = [UIColor colorWithRGBHex:0x999999];
            _moneyAmountLabel.textColor = [UIColor colorWithRGBHex:0x999999];
            _statusLabel.textColor = [UIColor colorWithRGBHex:0x999999];
            _statusLabel.text = @"已还款";
            _leftCircle.backgroundColor = [UIColor colorWithRGBHex:0xE1E2E3];
            break;
        case 2:
            _dateLabel.textColor = [UIColor colorWithRGBHex:0xF54642];
            _moneyAmountLabel.textColor = [UIColor colorWithRGBHex:0xF54642];
            _statusLabel.textColor = [UIColor colorWithRGBHex:0xF54642];
            _leftCircle.backgroundColor = [UIColor colorWithRGBHex:0xF54642];
            _statusLabel.text = @"已逾期";
            break;
        default:
            break;
    }
}

- (void)setScheduleItem:(HXSBillRepaymentScheduleItem *)scheduleItem
{
    _scheduleItem = scheduleItem;
    
    self.state = _scheduleItem.repaymentStatusNum.intValue;
    _dateLabel.text = [HTDateConversion stringFromDate:_scheduleItem.repaymentDate formatString:@"yyyy-MM-dd"];
    _moneyAmountLabel.text = [NSString stringWithFormat:@"￥ %0.2f", _scheduleItem.repaymentAmountNum.doubleValue];
}

@end
