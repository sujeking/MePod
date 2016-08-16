//
//  HXSMyOrderHeaderTableViewCell.m
//  store
//
//  Created by ArthurWang on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSMyOrderHeaderTableViewCell.h"

#import "HXSBoxOrderEntity.h"
#import "HXSCreditOrderEntity.h"
#import "HXSPrintOrderInfo.h"
#import "HXSStoreOrderEntity.h"
#import "HXSBoxOrderModel.h"

@implementation HXSMyOrderHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

#pragma mark - Setter Methods

- (void)setOrderInfo:(HXSOrderInfo *)orderInfo
{
    _orderInfo = orderInfo;
    
    if (kHXSOrderTypeDorm == orderInfo.type) { // 夜猫店
    
        [self setupCellWithStatus:orderInfo.status
                          orderSn:orderInfo.order_sn
                          payType:orderInfo.paytype
                        payStatus:orderInfo.paystatus
                        refundMsg:orderInfo.refund_status_msg];
        
        return;
    }
    
    // 分期数码
    NSTimeInterval timeInterval = [orderInfo.add_time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateStr = [HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"];
    
    self.timeLabel.text = dateStr;
    
    switch (orderInfo.status) {
        case kHXSOrderStautsCommitted:
        {
            if (kHXSOrderTypeOneDream == orderInfo.type) {
                self.statusLabel.text = @"待开奖";
                self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            } else {
                self.statusLabel.text = @"未支付";
                self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            }
            
        }
            break;
        case kHXSOrderStautsConfirmed:
        {
            // Do nothing
        }
            break;
        case kHXSOrderStautsSent:
        {
            self.statusLabel.text = @"配货中";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
        }
            break;
            
        case kHXSOrderStautsWaiting:
        {
            self.statusLabel.text = @"待发货";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
        }
            break;
            
        case kHXSOrderStautsDone:
        {
            if (kHXSOrderTypeOneDream == orderInfo.type) {
                self.statusLabel.text = @"已开奖";
                self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            } else {
                self.statusLabel.text = @"已完成";
                self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            }
        }
            break;
        case kHXSOrderStautsCaneled:
        {
            if ([orderInfo.refund_status_msg length] > 0) {
                self.statusLabel.text = [NSString stringWithFormat:@"已取消(%@)", orderInfo.refund_status_msg];
            }
            else {
                self.statusLabel.text = @"已取消";
            }
            
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        }
            break;
            
        default:
            break;
    }
    
    
    if (0 < [orderInfo.iconURLStr length])
    {
        [self.iconImageView setHidden:NO];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:orderInfo.iconURLStr]
                              placeholderImage:[UIImage imageNamed:@"ic_order_digit"]];
        
        
        [self.timeLabel.superview removeConstraint:self.timeLabelLeftConstraint];
        
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).with.mas_offset(10);
        }];
    }
}

- (void)setBoxOrderEntity:(HXSBoxOrderEntity *)boxOrderEntity
{
    _boxOrderEntity = boxOrderEntity;
    
    self.timeLabel.text = [NSString stringWithFormat:@"订单号：%@", boxOrderEntity.orderSNStr ? boxOrderEntity.orderSNStr : @""];
    self.statusLabel.text = [boxOrderEntity getStatus];
    
    switch ([boxOrderEntity.status intValue]) {
        case kHSXBoxOrderStatusUnpay: // 订单等待支付
        {
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
        }
            break;
            
        case kHXSBoxOrderStatusPayed: // 订单已完成
        {
            self.statusLabel.textColor = HXS_INFO_NOMARL_COLOR;
        }
            break;
        case kHXSBoxOrderStatusCanceled: // 订单取消
        {
            self.statusLabel.textColor = HXS_INFO_NOMARL_COLOR;
        }
            break;
            
        default:
            break;
    }
}


- (void)setStoreOrder:(HXSStoreOrderEntity *)storeOrder { // 云超市
    _storeOrder = storeOrder;
    
    [self setupStoreCellInfoWithStatus:storeOrder.status
                               orderSn:storeOrder.orderSn
                               payType:storeOrder.payType
                             payStatus:storeOrder.payStatus
                       refundStatusMsg:storeOrder.refundStatusMsg];
}

- (void)setupStoreCellInfoWithStatus:(NSInteger)status
                    orderSn:(NSString *)orderSNStr
                    payType:(NSInteger)payType
                  payStatus:(NSInteger)payStatus
            refundStatusMsg:(NSString *)refundStatusMsg{
    self.timeLabel.text = [NSString stringWithFormat:@"订单号: %@", orderSNStr ? orderSNStr : @""];
    
    switch (status) {
        case HXSStoreOrderStatusCreated:
        {
            if(payStatus == 0) {
                self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502]; // 橙色
            } else {
                self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA]; // 蓝色
            }
        }
            break;
        case HXSStoreOrderStatusReceived:
        case HXSStoreOrderStatusDistributing:
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            break;
        case HXSStoreOrderStatusCancel:
        case HXSStoreOrderStatusCompleted:
        case HXSStoreOrderStatusDeliveried:
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            break;
            
        default:
            break;
    }
    self.statusLabel.text = [NSString storeOrderStatusDescWithType:status payStatus:payStatus refundStatusMsg:refundStatusMsg];
}

#pragma mark - Private Methods

- (void)setupCellWithStatus:(NSInteger)status
                    orderSn:(NSString *)orderSNStr
                    payType:(NSInteger)payType
                  payStatus:(NSInteger)payStatus
                  refundMsg:(NSString *)refundMsgStr
{
    self.timeLabel.text = [NSString stringWithFormat:@"订单号: %@", orderSNStr ? orderSNStr : @""];
    
    switch (status) {
        case kHXSOrderStautsCommitted:
        {
            if(payType != 0 && payStatus == 0) {
                self.statusLabel.text = @"未支付";
                self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            }
            else {
                self.statusLabel.text = @"已下单";
                self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            }
        }
            break;
        case kHXSOrderStautsConfirmed:
            self.statusLabel.text = @"配货中";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            break;
        case kHXSOrderStautsSent:
        case kHXSOrderStautsDone:
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            break;
        case kHXSOrderStautsCaneled:
            if ([refundMsgStr length] > 0) {
                self.statusLabel.text = [NSString stringWithFormat:@"已取消(%@)", refundMsgStr];
            }
            else {
                self.statusLabel.text = @"已取消";
            }
            
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            break;
            
        default:
            break;
    }
}

#pragma mark - PrintOrder
-(void)setPrintOrder:(HXSPrintOrderInfo *)printOrder{
    _printOrder = printOrder;
    // 订单号
    self.timeLabel.text = [NSString stringWithFormat:@"订单号：%@", printOrder.orderSnLongNum ? printOrder.orderSnLongNum : @""];
    // 订单状态
    [self printOrderStatus];
}
-(void)printOrderStatus{
    switch (self.printOrder.statusIntNum.intValue) {
        case HXSPrintOrderStatusNotPay:
            self.statusLabel.text = @"未支付";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            break;
        case HXSPrintOrderStatusConfirmed:
            self.statusLabel.text = @"未打印";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            break;
        case HXSPrintOrderStatusDistribution:
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            break;
        case HXSPrintOrderStatusCompleted:
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            break;
        case HXSPrintOrderStatusCanceled:{
            if(_printOrder.refundStatusMsgStr)
                self.statusLabel.text = [NSString stringWithFormat:@"已取消(%@)",_printOrder.refundStatusMsgStr ];
            else
                self.statusLabel.text = @"已取消";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            break;
          }
        case HXSPrintOrderStatusPrinted:
            self.statusLabel.text = @"已打印";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            break;
        default:
            break;
    }
}


#pragma mark - 零食盒子
- (void)setBoxOrderModel:(HXSBoxOrderModel *)boxOrderModel{
    _boxOrderModel = boxOrderModel;
    self.timeLabel.text = [NSString stringWithFormat:@"订单号：%@", _boxOrderModel.orderIdStr];
    [self boxOrderStatus];
}

- (void)boxOrderStatus{
    switch (_boxOrderModel.orderStatusNum.intValue) {
        case kHXSBoxOrderStayusNotPay:
            self.statusLabel.text = @"未支付";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            break;
        case kHXSBoxOrderStayusFinished:
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            break;
        case kHXSBoxOrderStayusCancled:
            if(_boxOrderModel.refundStatusMsg)
                self.statusLabel.text = [NSString stringWithFormat:@"已取消(%@)",_printOrder.refundStatusMsgStr ];
            else
                self.statusLabel.text = @"已取消";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            break;
        default:
            self.statusLabel.text = @"未知状态";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            break;
    }


}


@end
