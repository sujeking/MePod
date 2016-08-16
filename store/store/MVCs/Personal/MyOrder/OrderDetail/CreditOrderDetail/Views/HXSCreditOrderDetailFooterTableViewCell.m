//
//  HXSCreditOrderDetailFooterTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditOrderDetailFooterTableViewCell.h"


#define PADDING_TOP_AND_BOTTOM   30
#define HEIGHT_EACH_LINE         18

@interface HXSCreditOrderDetailFooterTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HXSCreditOrderDetailFooterTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Public Methods

+ (CGFloat)heightOfFooterViewForOrder:(HXSOrderInfo *)orderInfo
{
    NSInteger lines = 0; // 行数请参考 "59app3.3_IOS效果图"
    
    // 订单状态
    switch (orderInfo.status) {
        case kHXSOrderStautsCommitted:
        {
            lines = 2; // "未支付"

        }
            break;
        case kHXSOrderStautsConfirmed:
        {
            // Do nothing
        }
            break;
            
        case kHXSOrderStautsSent: // "配货中"
        {
            if (kHXSOrderInfoInstallmentNO == [orderInfo.installmentIntNum integerValue]) {
                lines = 4;
            } else {
                lines = 5;
            }
        }
            break;
            
        case kHXSOrderStautsWaiting: // "待发货"
        {
            if (kHXSOrderInfoInstallmentNO == [orderInfo.installmentIntNum integerValue]) {
                lines = 4;
            } else {
                lines = 5;
            }
        }
            break;
            
        case kHXSOrderStautsDone: // "已完成"
        {
            if (kHXSOrderInfoInstallmentNO == [orderInfo.installmentIntNum integerValue]) {
                if (kHXSOrderCommentStatusDonot == [orderInfo.commentStatusIntNum integerValue]) {
                    lines = 5;
                } else {
                    lines = 6;
                }
            } else {
                if (kHXSOrderCommentStatusDonot == [orderInfo.commentStatusIntNum integerValue]) {
                    lines = 6;
                } else {
                    lines = 7;
                }
            }
        }
            break;
        case kHXSOrderStautsCaneled: // "已取消"
        {
            if (0 >= [orderInfo.payTimeStr length]) { // 未付款
                lines = 3;
            } else {
                if (kHXSOrderInfoInstallmentNO == [orderInfo.installmentIntNum integerValue]) {
                    lines = 5;
                } else {
                    lines = 6;
                }
            }
        }
            
            break;
            
        default:
            break;
    }
    
    return (lines * HEIGHT_EACH_LINE) + PADDING_TOP_AND_BOTTOM;
}

- (void)setupFooterCellWithOrderInfo:(HXSOrderInfo *)orderInfo
{
    NSMutableString *contentMStr = [[NSMutableString alloc] initWithCapacity:5];
    
    // line 1
    [contentMStr appendFormat:@"订单号：%@", orderInfo.order_sn];
    
    // line 2
    NSTimeInterval timeInterval = [orderInfo.add_time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateStr = [HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"];
    [contentMStr appendFormat:@"\n下单时间：%@", dateStr];
    
    // 订单状态
    switch (orderInfo.status) {
        case kHXSOrderStautsCommitted:
        {
            // "未支付"
            
            // Just display two lines.
        }
            break;
        case kHXSOrderStautsConfirmed:
            // Do nothing
            break;
        case kHXSOrderStautsSent: // "配货中"
        {
            // line 3
            [contentMStr appendFormat:@"\n付款时间：%@", orderInfo.payTimeStr];
            
            if (kHXSOrderInfoInstallmentNO == [orderInfo.installmentIntNum integerValue]) {
                //line 4
                [contentMStr appendFormat:@"\n支付方式：%@", [orderInfo getPayType]];
            } else {
                // line 4
                [contentMStr appendFormat:@"\n首付：%@", [NSString payTypeStringWithPayType:[orderInfo.downPaymentTypeIntNum integerValue]]];
                
                // line 5
                [contentMStr appendFormat:@"\n分期：%@", [NSString payTypeStringWithPayType:[orderInfo.installmentTypeIntNum integerValue]]];
            }
        }
            break;
            
        case kHXSOrderStautsWaiting: // "待发货"
        {
            // line 3
            [contentMStr appendFormat:@"\n付款时间：%@", orderInfo.payTimeStr];
            
            if (kHXSOrderInfoInstallmentNO == [orderInfo.installmentIntNum integerValue]) {
                // line 4
                [contentMStr appendFormat:@"\n支付方式：%@", [orderInfo getPayType]];
                
            } else {
                // line 4
                [contentMStr appendFormat:@"\n首付：%@", [NSString payTypeStringWithPayType:[orderInfo.downPaymentTypeIntNum integerValue]]];
                
                // line 5
                [contentMStr appendFormat:@"\n分期：%@", [NSString payTypeStringWithPayType:[orderInfo.installmentTypeIntNum integerValue]]];
            }
        }
            break;
            
        case kHXSOrderStautsDone: // "已完成"
            if (kHXSOrderInfoInstallmentNO == [orderInfo.installmentIntNum integerValue]) {
                // line 3
                [contentMStr appendFormat:@"\n付款时间：%@", orderInfo.payTimeStr];
                
                //line 4
                [contentMStr appendFormat:@"\n支付方式：%@", [orderInfo getPayType]];
                
                // line 5
                NSTimeInterval timeInterval = [orderInfo.confirm_time doubleValue];
                NSString *dateStr = nil;
                if (0 >= timeInterval) {
                    dateStr = @"无";
                } else {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                    dateStr = [HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"];
                }
                
                if (kHXSOrderCommentStatusDone == [orderInfo.commentStatusIntNum integerValue]) {
                    
                    [contentMStr appendFormat:@"\n确认收货时间：%@", dateStr];
                    // line 6
                    [contentMStr appendFormat:@"\n评价时间：%@", orderInfo.commentTimeStr];
                } else {
                    [contentMStr appendFormat:@"\n确认收货时间：%@", dateStr];
                }
            } else {
                // line 3
                [contentMStr appendFormat:@"\n付款时间：%@", orderInfo.payTimeStr];
                
                // line 4
                [contentMStr appendFormat:@"\n首付：%@", [NSString payTypeStringWithPayType:[orderInfo.downPaymentTypeIntNum integerValue]]];
                
                // line 5
                [contentMStr appendFormat:@"\n分期：%@", [NSString payTypeStringWithPayType:[orderInfo.installmentTypeIntNum integerValue]]];
                
                // line 6
                NSTimeInterval timeInterval = [orderInfo.confirm_time doubleValue];
                NSString *dateStr = nil;
                if (0 >= timeInterval) {
                    dateStr = @"无";
                } else {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                    dateStr = [HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"];
                }
                
                if (kHXSOrderCommentStatusDone == [orderInfo.commentStatusIntNum integerValue]) {
                    [contentMStr appendFormat:@"\n确认收货时间：%@", dateStr];
                    
                    // line 7
                    [contentMStr appendFormat:@"\n评价时间：%@", orderInfo.commentTimeStr];
                } else {
                    [contentMStr appendFormat:@"\n确认收货时间：%@", dateStr];
                }
            }
            break;
        case kHXSOrderStautsCaneled: // "已取消"
            if (0 >= [orderInfo.payTimeStr length]) { // 未付款
                // line 3
                [contentMStr appendFormat:@"\n取消时间：%@", orderInfo.cacelTimeStr];
            } else {
                // line 3
                [contentMStr appendFormat:@"\n付款时间：%@", orderInfo.payTimeStr];
                
                if (kHXSOrderInfoInstallmentNO == [orderInfo.installmentIntNum integerValue]) {
                    // line 4
                    [contentMStr appendFormat:@"\n支付方式：%@", [orderInfo getPayType]];
                    
                    // line 5
                    [contentMStr appendFormat:@"\n取消时间：%@", orderInfo.cacelTimeStr];
                } else {
                    // line 4
                    [contentMStr appendFormat:@"\n首付：%@", [NSString payTypeStringWithPayType:[orderInfo.downPaymentTypeIntNum integerValue]]];
                    
                    // line 5
                    [contentMStr appendFormat:@"\n分期：%@", [NSString payTypeStringWithPayType:[orderInfo.installmentTypeIntNum integerValue]]];
                    
                    // line 6
                    [contentMStr appendFormat:@"\n取消时间：%@", orderInfo.cacelTimeStr];
                }
            }
            
            break;
            
        default:
            break;
    }
    
    // 内容
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:contentMStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    [mutableAttributedString addAttribute:NSParagraphStyleAttributeName
                                    value:paragraphStyle
                                    range:NSMakeRange(0, [contentMStr length])];
    
    self.contentLabel.attributedText = mutableAttributedString;
}

@end
