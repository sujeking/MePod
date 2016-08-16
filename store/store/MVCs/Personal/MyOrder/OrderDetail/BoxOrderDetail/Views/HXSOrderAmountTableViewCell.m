//
//  HXSOrderAmountTableViewCell.m
//  store
//
//  Created by ArthurWang on 15/7/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSOrderAmountTableViewCell.h"

@implementation HXSOrderAmountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Public Methods

- (void)setupOrderAmountCellWith:(HXSOrderInfo *)orderInfo
{
    if (kHXSOrderTypeNewBox == orderInfo.type) {
        switch (orderInfo.status) {
            case kHSXBoxOrderStatusUnpay: // 订单等待支付
            {
                [self.titleBtn setTitle:[orderInfo getStatus] forState:UIControlStateNormal];
                [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0xF9A502] forState:UIControlStateNormal];
                [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_unpayment"] forState:UIControlStateNormal];
            }
                break;
                
            case kHXSBoxOrderStatusPayed: // 订单已完成
            {
                [self.titleBtn setTitle:[orderInfo getStatus] forState:UIControlStateNormal];
                [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
                [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_complete"] forState:UIControlStateNormal];
            }
                break;
                
            case kHXSBoxOrderStatusCanceled: // 订单取消
            {
                if (orderInfo.refund_status_msg.length > 0) {
                    [self.titleBtn setTitle: [NSString stringWithFormat:@"已取消(%@)", orderInfo.refund_status_msg] forState:UIControlStateNormal];
                }
                else {
                    [self.titleBtn setTitle:@"已取消" forState:UIControlStateNormal];
                }
                
                [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
                [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_cancel"] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (orderInfo.status) {
            case kHXSOrderStautsCommitted:
            {
                if (kHXSOrderTypeOneDream == orderInfo.type) {
                    [self.titleBtn setTitle:@"待开奖" forState:UIControlStateNormal];
                    [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0xF9A502] forState:UIControlStateNormal];
                    [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_unpayment"] forState:UIControlStateNormal];
                } else {
                    if((0 != orderInfo.paytype)
                       && (0 == orderInfo.paystatus)) {
                        [self.titleBtn setTitle:@"未支付" forState:UIControlStateNormal];
                        [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0xF9A502] forState:UIControlStateNormal];
                        [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_unpayment"] forState:UIControlStateNormal];
                    }
                    else {
                        [self.titleBtn setTitle:@"待发货" forState:UIControlStateNormal];
                        [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0x07A9FA] forState:UIControlStateNormal];
                        [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_payment"] forState:UIControlStateNormal];
                    }
                }
            }
                break;
            case kHXSOrderStautsConfirmed:
                [self.titleBtn setTitle:@"配货中" forState:UIControlStateNormal];
                [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0x07A9FA] forState:UIControlStateNormal];
                [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_payment"] forState:UIControlStateNormal];
                break;
            case kHXSOrderStautsSent:
                [self.titleBtn setTitle:@"待收货" forState:UIControlStateNormal];
                [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
                [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_complete"] forState:UIControlStateNormal];
                break;
            case kHXSOrderStautsDone:
                if (kHXSOrderTypeOneDream == orderInfo.type) {
                    [self.titleBtn setTitle:@"已开奖" forState:UIControlStateNormal];
                } else {
                    [self.titleBtn setTitle:@"已完成" forState:UIControlStateNormal];
                }
                
                [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
                [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_complete"] forState:UIControlStateNormal];
                break;
            case kHXSOrderStautsCaneled:
                if (orderInfo.refund_status_msg.length > 0) {
                    [self.titleBtn setTitle:[NSString stringWithFormat:@"已取消(%@)", orderInfo.refund_status_msg] forState:UIControlStateNormal];
                }
                else {
                    [self.titleBtn setTitle:@"已取消" forState:UIControlStateNormal];
                }
                
                [self.titleBtn setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
                [self.titleBtn setImage:[UIImage imageNamed:@"ic_orderstatus_cancel"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
    

    self.orderAmountLabel.text = [NSString stringWithFormat:@"订单金额：￥%0.2f", [orderInfo.food_amount doubleValue]];
    
    if (0.00 < [orderInfo.discount doubleValue])
    {
        self.couponLabel.text      = [NSString stringWithFormat:@"优惠：￥%0.2f", [orderInfo.discount doubleValue]];
    } else {
        self.couponLabel.text      = [NSString stringWithFormat:@"优惠：无"];
    }
}

@end
