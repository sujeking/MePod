//
//  HXSWaitingToRobTableViewCell.m
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWaitingToRobTableViewCell.h"

@interface HXSWaitingToRobTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *buyerAddressLabel; // 买家地址
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyerAddressLabelHight;
@property (nonatomic, weak) IBOutlet UILabel *shopAddressLabel; // 卖家地址
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *shopAddressLabelHeight;
@property (nonatomic, weak) IBOutlet UILabel *shopPhoneLabel; // 卖家电话
@property (nonatomic, weak) IBOutlet UILabel *shopBossLanel; // 卖家姓名
@property (nonatomic, weak) IBOutlet UILabel *remarkLabel; // 留言
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *remarkLabelHeight;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel; // 佣金
@property (nonatomic, weak) IBOutlet UIButton *robButton; // 抢任务

@end

@implementation HXSWaitingToRobTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTaskOrder:(HXSTaskOrder *)taskOrder{
    _taskOrder = taskOrder;
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",taskOrder.buyerAddress,taskOrder.buyerName];
    _buyerAddressLabel.text = str;
    _buyerAddressLabelHight.constant = [taskOrder buyerAddressAddHeightRob:72] + 14;
    
    _shopAddressLabel.text = taskOrder.shopAddressStr;
    _shopAddressLabelHeight.constant = [taskOrder shopAddressAddHeight:72] + 14;
    
    _shopPhoneLabel.text = taskOrder.shopPhoneStr;
    _shopBossLanel.text = taskOrder.shopBossStr;
    
    _remarkLabel.text = taskOrder.remarkStr.length > 0 ? taskOrder.remarkStr : @"无";
    _remarkLabelHeight.constant = [taskOrder remarkAddHeightLessTwoLines:72] + 14;
    
    _amountLabel.text = [NSString stringWithFormat:@"￥%.2f-￥%.2f",taskOrder.minRewardDoubleNum.doubleValue, taskOrder.maxRewardDoubleNum.doubleValue];    
}

- (IBAction)taskButtonClicked:(id)sender{
    [self.delegate robTaskButtonClickedWithTaskOrder:_taskOrder];
}


@end
