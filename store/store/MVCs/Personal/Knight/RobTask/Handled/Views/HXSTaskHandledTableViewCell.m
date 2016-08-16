//
//  HXSTaskHandledTableViewCell.m
//  store
//
//  Created by 格格 on 16/4/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskHandledTableViewCell.h"

@interface HXSTaskHandledTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *buyerAddressLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyerAddressLabelHeight;
@property (nonatomic, weak) IBOutlet UILabel *shopAddressLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *shopAddressLabelHeight;
@property (nonatomic, weak) IBOutlet UILabel *shopPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *shopBossLabel;
@property (nonatomic, weak) IBOutlet UILabel *remarkLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *remarkLabelHeight;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *rewardLabel;
@property (nonatomic, weak) IBOutlet UIButton *phoneButton;
@property (nonatomic, weak) IBOutlet UILabel *dateNoLabel;

@end

@implementation HXSTaskHandledTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTaskOrder:(HXSTaskOrder *)taskOrder{
    _taskOrder = taskOrder;
    
    if(taskOrder.dateNoNum.intValue < 10){
        _dateNoLabel.text = [NSString stringWithFormat:@"0%d",taskOrder.dateNoNum.intValue];
    }else{
        _dateNoLabel.text = [NSString stringWithFormat:@"%d",taskOrder.dateNoNum.intValue];
    }
    _dateNoLabel.adjustsFontSizeToFitWidth = YES;
    
    NSString *str = [NSString stringWithFormat:@"送至：%@ %@",taskOrder.buyerAddress,taskOrder.buyerName];
    _buyerAddressLabel.text = str;
    _buyerAddressLabelHeight.constant = [taskOrder buyerAddressAddHeight:117] + 14;
    
    _shopAddressLabel.text = taskOrder.shopAddressStr;
    _shopAddressLabelHeight.constant = [taskOrder shopAddressAddHeight:111] + 14;
    
    _shopPhoneLabel.text = taskOrder.shopPhoneStr;
    _shopBossLabel.text = taskOrder.shopBossStr;
    
    _remarkLabel.text = taskOrder.remarkStr.length > 0 ?taskOrder.remarkStr :@"无";
    _remarkLabelHeight.constant = [taskOrder remarkAddHeightLessTwoLines:111] + 14;
    
    _statusLabel.text = [self statusStr];
    
    /*如果状态为已取消，显示取消时间，否则显示收入的佣金情况*/
    if(HXSKnightDeliveryStatusCancle == _taskOrder.statusIntNum.intValue){
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_taskOrder.cancelTimeLongNum.longValue];
        _rewardLabel.text = [NSString stringWithFormat:@"取消时间：%@",[HTDateConversion stringFromDate:date formatString:@"HH:mm"]];
    }else if(HXSKnightDeliveryStatusSettled == _taskOrder.statusIntNum.intValue){
        
        NSString *rewardPart1 = @"收入：";
        NSString *rewardPart2 = [NSString stringWithFormat:@"￥%.2f",taskOrder.rewardDoubleNum.doubleValue];
        NSString *priceStr = [NSString stringWithFormat:@"%@%@", rewardPart1, rewardPart2];
        NSMutableAttributedString *priceAttributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [priceAttributedStr addAttribute:NSForegroundColorAttributeName
                                   value:HXS_COLOR_COMPLEMENTARY
                                   range:NSMakeRange(rewardPart1.length, [rewardPart2 length])];
        _rewardLabel.attributedText = priceAttributedStr;
    }else if(HXSKnightDeliveryStatusFinish == _taskOrder.statusIntNum.intValue){
        NSString *rewardPart1 = @"可获：";
        NSString *rewardPart2 = [NSString stringWithFormat:@"￥%.2f-￥%.2f ",taskOrder.minRewardDoubleNum.doubleValue,taskOrder.maxRewardDoubleNum.doubleValue];
        NSString *priceStr = [NSString stringWithFormat:@"%@%@", rewardPart1, rewardPart2];
        NSMutableAttributedString *priceAttributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [priceAttributedStr addAttribute:NSForegroundColorAttributeName
                                   value:HXS_COLOR_COMPLEMENTARY
                                   range:NSMakeRange(rewardPart1.length, [rewardPart2 length])];
        _rewardLabel.attributedText = priceAttributedStr;
    }
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopPhoneClicked)];
    [self.shopPhoneLabel addGestureRecognizer:singleTap];
    self.shopPhoneLabel.userInteractionEnabled = YES;
}

- (IBAction)phoneButtonClicked:(id)sender {
    [self.delegate phoneButtonButtonClicked:self.taskOrder];
}

- (NSString *)statusStr{
    switch (_taskOrder.statusIntNum.intValue) {
        case HXSKnightDeliveryStatusWaitingGet:
            return @"待取货";
            break;
        case HXSKnightDeliveryStatusDelivering:
            return @"配送中";
            break;
        case HXSKnightDeliveryStatusFinish:
            return @"已完成";
            break;
        case HXSKnightDeliveryStatusCancle:
            return @"已取消";
            break;
        case HXSKnightDeliveryStatusSettled:
            return @"已完成";
            break;
        default:
            return @"";
            break;
    }
}


- (void)shopPhoneClicked{
    [self.delegate shopPhoneClicked:self.taskOrder];
}




@end
