//
//  HXSWaitingToHandleTableViewCell.m
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWaitingToHandleTableViewCell.h"

@interface HXSWaitingToHandleTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *buyerAddressLabel; // 买家地址
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyerAddressLabelHight;
@property (nonatomic, weak) IBOutlet UILabel *shopAddressLabel; // 卖家地址
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *shopAddressLabelHeight;
@property (nonatomic, weak) IBOutlet UILabel *shopPhoneLabel; // 卖家电话
@property (nonatomic, weak) IBOutlet UILabel *shopBossLanel; // 卖家姓名
@property (nonatomic, weak) IBOutlet UILabel *remarkLabel; // 留言
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *remarkLabelHeight;
@property (nonatomic, weak) IBOutlet UILabel  *stetusLabel; // 状态
@property (nonatomic, weak) IBOutlet UIButton *phoneButton; // 电话
@property (nonatomic, weak) IBOutlet UIButton *QRCodeButton;
@property (nonatomic, weak) IBOutlet UILabel  *dateNoLabel;

@end

@implementation HXSWaitingToHandleTableViewCell

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
    _buyerAddressLabelHight.constant = [taskOrder buyerAddressAddHeight:117] + 14;
    
    _shopAddressLabel.text = taskOrder.shopAddressStr;
    _shopAddressLabelHeight.constant = [taskOrder shopAddressAddHeight:111] + 14;
    
    _shopPhoneLabel.text = taskOrder.shopPhoneStr;
    _shopBossLanel.text = taskOrder.shopBossStr;
    
    _remarkLabel.text = taskOrder.remarkStr.length > 0 ? taskOrder.remarkStr : @"无";
    _remarkLabelHeight.constant = [taskOrder remarkAddHeightLessTwoLines:111] + 14;
    
    _stetusLabel.text = [self statusStr];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopPhoneClicked)];
    [self.shopPhoneLabel addGestureRecognizer:singleTap];
    self.shopPhoneLabel.userInteractionEnabled = YES;
}

- (NSString *)statusStr{
    switch (_taskOrder.statusIntNum.intValue) {
        case HXSKnightDeliveryStatusWaitingGet:
            [_stetusLabel setTextColor:[UIColor colorWithRGBHex:0xf9a502]];
            _QRCodeButton.hidden = NO;
            return @"待取货";
            break;
        case HXSKnightDeliveryStatusDelivering:
            [_stetusLabel setTextColor:[UIColor colorWithRGBHex:0x07a9fa]];
            _QRCodeButton.hidden = YES;
            return @"配送中";
            break;
        case HXSKnightDeliveryStatusFinish:
            _QRCodeButton.hidden = YES;
            [_stetusLabel setTextColor:[UIColor colorWithRGBHex:0x666666]];
            return @"已完成";
            break;
        case HXSKnightDeliveryStatusCancle:
            _QRCodeButton.hidden = YES;
            [_stetusLabel setTextColor:[UIColor colorWithRGBHex:0x666666]];
            return @"已取消";
            break;
        default:
            return @"";
            break;
    }
}

- (void)shopPhoneClicked{
    [self.delegate shopPhoneClicked:self.taskOrder];
}

- (IBAction)rqButtonClicked:(id)sender{
    [self.delegate qrCodeButtonClicked:self.taskOrder];
}

- (IBAction)phoneButtonClicked:(id)sender{
    [self.delegate phoneButtonButtonClicked:self.taskOrder];
}

@end
