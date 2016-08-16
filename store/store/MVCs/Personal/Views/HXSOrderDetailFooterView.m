//
//  HXSOrderDetailFooterView.m
//  store
//
//  Created by ranliang on 15/5/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSOrderDetailFooterView.h"

@interface HXSOrderDetailFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@end

@implementation HXSOrderDetailFooterView

- (void)configWithOrderInfo:(HXSOrderInfo *)orderInfo
{
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@", orderInfo.order_sn];
    
    //下单时间
    NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[orderInfo.add_time integerValue]];
    NSDateFormatter *orderDateFormatter = [[NSDateFormatter alloc] init];
    orderDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    orderDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *orderDateString = [orderDateFormatter stringFromDate:orderDate];
    orderDateString = [@"下单时间：" stringByAppendingString:orderDateString];
    
    _orderNumberLabel.text = [NSString stringWithFormat:@"订单号:  %@", orderInfo.order_sn];
    _orderTimeLabel.text = [NSString stringWithFormat:@"%@", orderDateString];
    
    // 未支付订单
    if ((orderInfo.status == 0)
        && (orderInfo.paytype != 0)
        && (orderInfo.paystatus == 0)) {
        _payTypeLabel.text = nil;
        return;
    }
    
    // //0表示现金，1表示支付宝，2表示微信支付 3表示信用钱包
    NSString *payTypeText = [NSString payTypeStringWithPayType:orderInfo.paytype];
    payTypeText = (0.0 >= [orderInfo.order_amount floatValue]) ? @"无" : payTypeText;
    _payTypeLabel.text = [NSString stringWithFormat:@"支付方式: %@", payTypeText];
    
    if ((kHXSOrderTypeCharge == orderInfo.type) // 充值订单
        && (kHXSOrderStautsCaneled == orderInfo.status)
        && (0 >= [orderInfo.refund_status_msg length])) { // 手动取消
        _payTypeLabel.text = [NSString stringWithFormat:@"取消时间: %@", orderInfo.cacelTimeStr];
    }
    
}

@end
