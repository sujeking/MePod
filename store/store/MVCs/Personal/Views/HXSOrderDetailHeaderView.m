//
//  HXSOrderDetailHeaderView.m
//  store
//
//  Created by ranliang on 15/5/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSOrderDetailHeaderView.h"
#import "HXSPersonal.h"
#import "HXSActionSheet.h"

@interface HXSOrderDetailHeaderView ()<UIActionSheetDelegate> {
    HXSOrderInfo *_orderInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *orderStatusIcon;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property (weak, nonatomic) IBOutlet UIButton *callButton;

@end

@implementation HXSOrderDetailHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _callButton.layer.masksToBounds = YES;
    _callButton.layer.borderWidth = 1.0;
    _callButton.layer.cornerRadius = 3.0;
    _callButton.layer.borderColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
}

- (void)configWithOrderInfo:(HXSOrderInfo *)orderInfo
{
    _orderInfo = orderInfo;
    
    //配置其它label的内容
    self.orderAmountLabel.text = [NSString stringWithFormat:@"订单金额：￥%.2f",     [orderInfo.food_amount floatValue]];
    
    NSString *discountStr = (0.00 < [orderInfo.discount floatValue]) ? [NSString stringWithFormat:@"￥%0.2f", [orderInfo.discount floatValue]] : @"无";
    self.discountLabel.text = [NSString stringWithFormat:@"优惠：%@", discountStr];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", orderInfo.address1, orderInfo.address2, orderInfo.dormitory];
    
    self.noteLabel.text = [NSString stringWithFormat:@"%@", orderInfo.remark];
    if (self.noteLabel.text.length == 0) {
        self.noteLabel.text = @"无";
    }
    
    self.cellNumberLabel.text = [NSString stringWithFormat:@"手机：%@", orderInfo.phone];
    
    _callButton.hidden = (orderInfo.dorm_contact.length < 1);
    
    switch (_orderInfo.status) {
        case kHXSOrderStautsCommitted:
        {
            if(_orderInfo.paytype != 0 && _orderInfo.paystatus == 0) {
                self.orderStatusLabel.text = @"未支付";
                self.orderStatusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
                _orderStatusIcon.image = [UIImage imageNamed:@"ic_orderstatus_unpayment"];
            }
            else {
                self.orderStatusLabel.text = @"已下单";
                self.orderStatusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
                _orderStatusIcon.image = [UIImage imageNamed:@"ic_orderstatus_payment"];
            }
        }
            break;
        case kHXSOrderStautsConfirmed:
            self.orderStatusLabel.text = @"配货中";
            self.orderStatusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            _orderStatusIcon.image = [UIImage imageNamed:@"ic_orderstatus_payment"];
            break;
        case kHXSOrderStautsSent:
        case kHXSOrderStautsDone:
            self.orderStatusLabel.text = @"已完成";
            self.orderStatusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            _orderStatusIcon.image = [UIImage imageNamed:@"ic_orderstatus_complete"];
            break;
        case kHXSOrderStautsCaneled:
            if (_orderInfo.refund_status_msg.length > 0) {
                self.orderStatusLabel.text = [NSString stringWithFormat:@"已取消(%@)", _orderInfo.refund_status_msg];
            }
            else {
                self.orderStatusLabel.text = @"已取消";
            }
            
            self.orderStatusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            _orderStatusIcon.image = [UIImage imageNamed:@"ic_orderstatus_cancel"];
            break;
            
        default:
            break;
    }
}

- (IBAction)callBtnPressed:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventCallShopManager parameter:nil];
    
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = _orderInfo.dorm_contact;
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity
                                                 handler:^(HXSAction *action) {
                                                     NSString *phoneNumber = [@"tel://" stringByAppendingString: _orderInfo.dorm_contact];
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                 }];
    
    [sheet addAction:callAction];
    [sheet show];
}

+ (CGFloat)heightForOrder:(HXSOrderInfo *)orderInfo {
    NSString * remark = orderInfo.remark;
    if(!remark) {
        remark = @"";
    }
    
    CGSize size = [remark boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 85, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    return 150 + size.height;
}

@end
