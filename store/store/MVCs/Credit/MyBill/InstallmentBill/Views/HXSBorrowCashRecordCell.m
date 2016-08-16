//
//  HXSBorrowCashRecordCell.m
//  store
//
//  Created by hudezhi on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowCashRecordCell.h"

@interface HXSBorrowCashRecordCell () {
    UILabel *   _statusLabel;
}

@property (nonatomic) NSInteger state;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;

@end

@implementation HXSBorrowCashRecordCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:15.0];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_statusLabel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _statusLabel.frame = CGRectMake(self.width - 96, 0, 60, self.height);
}

- (void)setState:(NSInteger)state
{
    _state = state;
    // 0:还款中，1：已还完， 2：待放款，3：待还款
    switch (state) {
        case 0:
            _statusLabel.textColor = [UIColor colorWithRGBHex:0x63AC5B];
            _statusLabel.text = @"待放款";
            break;
        case 1:
            _statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            _statusLabel.text = @"待还款";
            break;
        case 2:
            _statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            _statusLabel.text = @"还款中";
            break;
        case 3:
            _statusLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
            _statusLabel.text = @"已还完";
            break;
        default:
            break;
    }
}

- (void)setCashRecord:(HXSBillBorrowCashRecordItem *)cashRecord
{
    _cashRecord = cashRecord;
    _purposeLabel.text = cashRecord.installmentTextStr;
    _dateLabel.text = [HTDateConversion stringFromDate:cashRecord.installmentDate formatString:@"yyyy-MM-dd"];
    _cashAmountLabel.text = [NSString stringWithFormat:@"￥ %0.2f", cashRecord.installmentAmountNum.doubleValue];
    self.state = cashRecord.installmentStatusNum.intValue;
//    _statusLabel.text = cashRecord.statusZh;
}

@end
