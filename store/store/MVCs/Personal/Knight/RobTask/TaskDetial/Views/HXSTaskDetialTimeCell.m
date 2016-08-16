//
//  HXSTaskDetialTimeCell.m
//  store
//
//  Created by 格格 on 16/4/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskDetialTimeCell.h"

@interface  HXSTaskDetialTimeCell()

@property (nonatomic, weak) IBOutlet UILabel *keyLabel1;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel1;
@property (nonatomic, weak) IBOutlet UILabel *keyLabel2;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel2;
@property (nonatomic, weak) IBOutlet UILabel *keyLabel3;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel3;

@end

@implementation HXSTaskDetialTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTaskOrderDetial:(HXSTaskOrderDetial *)taskOrderDetial{
    _taskOrderDetial = taskOrderDetial;
    
    switch (taskOrderDetial.statusIntNum.intValue) {
        case HXSKnightDeliveryStatusWaitingGet: // 待取货，只显示抢单时间
        {
            _keyLabel1.text = @"抢单时间：";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.confirmTimeLongNum.longValue];
            _timeLabel1.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm"]];
           
            _keyLabel1.hidden = NO;
            _timeLabel1.hidden = NO;
            
            _keyLabel2.hidden = YES;
            _timeLabel2.hidden = YES;

            _keyLabel3.hidden = YES;
            _timeLabel3.hidden = YES;
        }
            break;
        case HXSKnightDeliveryStatusDelivering: // 配送中 显示抢单时间和取货时间
        {
            _keyLabel1.text = @"抢单时间：";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.confirmTimeLongNum.longValue];
            _timeLabel1.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm"]];
            
            _keyLabel2.text = @"取货时间：";
            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.claimTimeLongNum.longValue];
            _timeLabel2.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date2 formatString:@"yyyy-MM-dd HH:mm"]];
            
            _keyLabel1.hidden = NO;
            _timeLabel1.hidden = NO;
            
            _keyLabel2.hidden = NO;
            _timeLabel2.hidden = NO;
            
            _keyLabel3.hidden = YES;
            _timeLabel3.hidden = YES;
        
        }
            break;
        case HXSKnightDeliveryStatusFinish: // 已完成：抢单时间 取货时间 完成时间
        {
            _keyLabel1.text = @"抢单时间：";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.confirmTimeLongNum.longValue];
            _timeLabel1.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm"]];
            
            _keyLabel2.text = @"取货时间：";
            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.claimTimeLongNum.longValue];
            _timeLabel2.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date2 formatString:@"yyyy-MM-dd HH:mm"]];
            
            _keyLabel3.text = @"送达时间：";
            NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.finishTimeLongNum.longValue];
            _timeLabel3.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date3 formatString:@"yyyy-MM-dd HH:mm"]];
            
            _keyLabel1.hidden = NO;
            _timeLabel1.hidden = NO;
            
            _keyLabel2.hidden = NO;
            _timeLabel2.hidden = NO;
            
            _keyLabel3.hidden = NO;
            _timeLabel3.hidden = NO;
        }
            break;
        case HXSKnightDeliveryStatusCancle: // 取消订单 抢单时间 取货时间（有显示，没有不显示）
        {
            _keyLabel1.text = @"抢单时间：";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.confirmTimeLongNum.longValue];
            _timeLabel1.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm"]];
            
            _keyLabel1.hidden = NO;
            _timeLabel1.hidden = NO;
            
            if(taskOrderDetial.claimTimeLongNum){
                _keyLabel2.text = @"取货时间：";
                NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:taskOrderDetial.claimTimeLongNum.longValue];
                _timeLabel2.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date2 formatString:@"yyyy-MM-dd HH:mm"]];
                
                _keyLabel2.hidden = NO;
                _timeLabel2.hidden = NO;
            
            }else{
                _keyLabel2.hidden = YES;
                _timeLabel2.hidden = YES;
            }
        
            _keyLabel3.hidden = YES;
            _timeLabel3.hidden = YES;
        }
            break;
        default:
        {
            _keyLabel1.hidden = YES;
            _timeLabel1.hidden = YES;
            
            _keyLabel2.hidden = YES;
            _timeLabel2.hidden = YES;
            
            _keyLabel3.hidden = YES;
            _timeLabel3.hidden = YES;
        }
            break;
    }
}

@end
