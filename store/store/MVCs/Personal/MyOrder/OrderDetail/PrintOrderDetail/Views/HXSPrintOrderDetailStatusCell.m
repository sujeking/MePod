//
//  HXSPrintOrderDetailStatusCell.m
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintOrderDetailStatusCell.h"
#import "HXSPrintOrderInfo.h"

@interface HXSPrintOrderDetailStatusCell ()

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView; // 订单转态（图）
@property (weak, nonatomic) IBOutlet UILabel *statusLabel; // 订单状态
@property (weak, nonatomic) IBOutlet UILabel *amountLabel; // 订单金额
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;// 优惠

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;  // 收货地址
@property (weak, nonatomic) IBOutlet UILabel *deliveryInfoLabel; // 配送信息
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;// 手机
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;// 备注

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryInfoLabelHeight;

@end

@implementation HXSPrintOrderDetailStatusCell

- (void)awakeFromNib {
    _telephoneButton.layer.masksToBounds = YES;
    _telephoneButton.layer.borderWidth = 1.0;
    _telephoneButton.layer.cornerRadius = 3.0;
    _telephoneButton.layer.borderColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setPrintOrder:(HXSPrintOrderInfo *)printOrder{
    _printOrder = printOrder;
    
    [self orderStatus];
    self.amountLabel.text = [NSString stringWithFormat:@"订单金额：￥%.2f",printOrder.docAmountDoubleNum.doubleValue];
    
    NSString *discountStr = (0.00 < [printOrder.couponDiscountDoubleNum doubleValue]) ? [NSString stringWithFormat:@"￥%0.2f", [printOrder.couponDiscountDoubleNum doubleValue]] : @"无";
    self.discountLabel.text = [NSString stringWithFormat:@"优惠：%@", discountStr];
    
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",printOrder.addressStr?printOrder.addressStr:@""];
    
    self.deliveryInfoLabel.text = printOrder.deliveryDescStr?printOrder.deliveryDescStr:@"";
    
    if(printOrder.deliveryDescStr){
        NSDictionary * attributes = @{NSFontAttributeName : self.deliveryInfoLabel.font};
        
        CGSize contentSize = [self.deliveryInfoLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 127, MAXFLOAT)
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:attributes
                                                     context:nil].size;
        if(ceilf(contentSize.height) > 17){
            self.deliveryInfoLabelHeight.constant = ceilf(contentSize.height);
        }
    }
    
    self.telephoneLabel.text =  [NSString stringWithFormat:@"手机：%@",printOrder.phoneStr];
    
    NSString *remarkStr;
    if(printOrder.remarkStr == nil || printOrder.remarkStr.length <= 0)
        remarkStr = @"无";
    else
        remarkStr = printOrder.remarkStr;
    self.remarkLabel.text = [NSString stringWithFormat:@"%@", remarkStr];
}

// 根据转态设置statusImageView和statusLabel
-(void)orderStatus{
    switch (_printOrder.statusIntNum.intValue) {
        case HXSPrintOrderStatusNotPay:
            self.statusLabel.text = @"未支付";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            _statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_unpayment"];
            break;
        case HXSPrintOrderStatusConfirmed:
            self.statusLabel.text = @"未打印";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            _statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_payment"];
            break;
        case HXSPrintOrderStatusDistribution:
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            _statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_payment"];
            break;
        case HXSPrintOrderStatusCompleted:
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            _statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_complete"];
            break;
        case HXSPrintOrderStatusCanceled:
            if (_printOrder.refundStatusMsgStr.length > 0) {
                self.statusLabel.text = [NSString stringWithFormat:@"已取消(%@)", _printOrder.refundStatusMsgStr];
            }
            else {
                self.statusLabel.text = @"已取消";
            }
            
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            _statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_cancel"];
            break;
        case HXSPrintOrderStatusPrinted:
            self.statusLabel.text = @"已打印";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            _statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_complete"];
            break;
            
        default:
            break;
    }
}

- (void)setBoxOrder:(HXSBoxOrderModel *)boxOrder{
    _boxOrder = boxOrder;
    
    [self boxOrderStatus];
    self.amountLabel.text = [NSString stringWithFormat:@"订单金额：￥%.2f",boxOrder.orderAmountDoubleNum.doubleValue];
    
    NSString *discountStr = (0.00 < [boxOrder.couponAmountDoubleNum doubleValue]) ? [NSString stringWithFormat:@"￥%0.2f", [boxOrder.couponAmountDoubleNum doubleValue]] : @"无";
    self.discountLabel.text = [NSString stringWithFormat:@"优惠：%@", discountStr];
    
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",boxOrder.buyerAddressStr?boxOrder.buyerAddressStr:@""];
    
    self.deliveryInfoLabel.text = @"无";
    
    self.telephoneLabel.text =  [NSString stringWithFormat:@"手机：%@",boxOrder.buyerPhoneStr];
    
    self.remarkLabel.text = @"无";
}

- (void)boxOrderStatus{
    switch (_boxOrder.orderStatusNum.intValue) {
        case kHXSBoxOrderStayusNotPay:
            self.statusLabel.text = @"未支付";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            _statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_unpayment"];
            break;
        case kHXSBoxOrderStayusFinished:
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            _statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_payment"];
            break;
        case kHXSBoxOrderStayusCancled:
            if (_boxOrder.refundStatusMsg.length > 0) {
                self.statusLabel.text = [NSString stringWithFormat:@"已取消(%@)", _printOrder.refundStatusMsgStr];
            }
            else {
                self.statusLabel.text = @"已取消";
            }
            
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            _statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_cancel"];
            break;
        default:
            self.statusLabel.text = @"未知状态";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            _statusImageView.image = nil;
            break;
    }
}

@end
