//
//  HXSTaskOrderFeeCell.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskOrderFeeCell.h"

@interface HXSTaskOrderFeeCell()

@property (nonatomic, weak) IBOutlet UILabel *keyLabel;
@property (nonatomic, weak) IBOutlet UILabel *feeLabel;

@end

@implementation HXSTaskOrderFeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTaskOrderDetial:(HXSTaskOrderDetial *)taskOrderDetial{
    _taskOrderDetial = taskOrderDetial;
    if(HXSKnightDeliveryStatusCancle == taskOrderDetial.statusIntNum.intValue){ // 已取消
        _keyLabel.hidden = YES;
        _feeLabel.text = @"￥0.00";
    }else if(HXSKnightDeliveryStatusSettled == taskOrderDetial.statusIntNum.intValue){ // 已结算
        _keyLabel.hidden = NO;
        _keyLabel.text = @"收入:";
        _feeLabel.text = [NSString stringWithFormat:@"￥%.2f",taskOrderDetial.rewardDoubleNum.doubleValue];
    }else{
        _keyLabel.hidden = NO;
        _keyLabel.text = @"可获:";
        _feeLabel.text = [NSString stringWithFormat:@"￥%.2f-￥%.2f",taskOrderDetial.minRewardDoubleNum.doubleValue,taskOrderDetial.maxRewardDoubleNum.doubleValue];
    }
}

@end
