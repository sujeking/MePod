//
//  HXSTaskOrderTimeCell.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskOrderTimeCell.h"

@interface HXSTaskOrderTimeCell()

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *cancleTimeKeyLabel;
@property (nonatomic, weak) IBOutlet UILabel *cancleTimeLabel;

@end

@implementation HXSTaskOrderTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTaskOrderDetial:(HXSTaskOrderDetial *)taskOrderDetial{
    _taskOrderDetial = taskOrderDetial;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.createTimeLongNum.longValue];
    _timeLabel.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm"]];
    
    if(taskOrderDetial.statusIntNum.integerValue == HXSKnightDeliveryStatusCancle){
        _cancleTimeKeyLabel.hidden = NO;
        _cancleTimeLabel.hidden = NO;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.cancelTimeLongNum.longValue];
        _cancleTimeLabel.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm"]];
    
    }else{
        _cancleTimeKeyLabel.hidden = YES;
        _cancleTimeLabel.hidden = YES;
    
    }
}

@end
