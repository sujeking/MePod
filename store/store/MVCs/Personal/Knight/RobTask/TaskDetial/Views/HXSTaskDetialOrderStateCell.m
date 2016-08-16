//
//  HXSTaskDetialOrderStateCell.m
//  store
//
//  Created by 格格 on 16/4/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskDetialOrderStateCell.h"

@interface HXSTaskDetialOrderStateCell()

@property (nonatomic, weak) IBOutlet UILabel *orderNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderStatusLabel;

@end

@implementation HXSTaskDetialOrderStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setTaskOrderDetial:(HXSTaskOrderDetial *)taskOrderDetial{
    _taskOrderDetial = taskOrderDetial;
    _orderNoLabel.adjustsFontSizeToFitWidth = YES;
    _orderNoLabel.text = [NSString stringWithFormat:@"订单号：%@",taskOrderDetial.orderSnStr];
    
    _orderStatusLabel.text = [self statusStr];
}

- (NSString *)statusStr{
    switch (_taskOrderDetial.statusIntNum.intValue) {
        case HXSKnightDeliveryStatusWaitingGet:
            [_orderStatusLabel setTextColor:[UIColor colorWithRGBHex:0xf9a502]];
            return @"待取货";
            break;
        case HXSKnightDeliveryStatusDelivering:
            [_orderStatusLabel setTextColor:[UIColor colorWithRGBHex:0x07a9fa]];
            return @"配送中";
            break;
        case HXSKnightDeliveryStatusFinish:
            [_orderStatusLabel setTextColor:[UIColor colorWithRGBHex:0x666666]];
            return @"已完成";
            break;
        case HXSKnightDeliveryStatusCancle:
            [_orderStatusLabel setTextColor:[UIColor colorWithRGBHex:0x666666]];
            return @"已取消";
            break;
        case HXSKnightDeliveryStatusSettled:
            [_orderStatusLabel setTextColor:[UIColor colorWithRGBHex:0x666666]];
            return @"已完成";
            break;
        default:
            return @"";
            break;
    }
}

@end
