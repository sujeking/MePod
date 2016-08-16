//
//  HXSCreditOrderDetailHeaderTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditOrderDetailHeaderTableViewCell.h"

#define PADDING_TO_LEFT      45
#define PADDING_TO_RIGHT     5
#define AMOUNT_LABEL_TOP_MIN 10
#define AMOUNT_LABEL_TOP_MAX 37
#define HEIGHT_NORMAL_CELL   204
#define HEIGHT_NORMAL_LABEL  17

@interface HXSCreditOrderDetailHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountLabelTopConstraint;


@end

@implementation HXSCreditOrderDetailHeaderTableViewCell

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

- (void)setupCreditOrderHeaderViewWithOrderInfo:(HXSOrderInfo *)orderInfo
{
    // 订单状态
    switch (orderInfo.status) {
        case kHXSOrderStautsCommitted:
        {
            self.statusLabel.text = @"未支付";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            self.statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_unpayment"];
        }
            break;
            
        case kHXSOrderStautsConfirmed:
            // Do Nothing
            break;
            
        case kHXSOrderStautsSent:
        {
            self.statusLabel.text = @"配货中";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            self.statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_payment"];
        }
            break;
            
        case kHXSOrderStautsWaiting:
        {
            self.statusLabel.text = @"待发货";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            self.statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_payment"];
        }
            break;
            
        case kHXSOrderStautsDone:
        {
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            self.statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_complete"];
        }
            break;
            
        case kHXSOrderStautsCaneled:
        {
            if (orderInfo.refund_status_msg.length > 0) {
                self.statusLabel.text = [NSString stringWithFormat:@"已取消(%@)", orderInfo.refund_status_msg];
            }
            else {
                self.statusLabel.text = @"已取消";
            }
            
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            self.statusImageView.image = [UIImage imageNamed:@"ic_orderstatus_cancel"];
        }
            break;
            
        default:
            break;
    }
    
    // 未支付订单
    if (kHXSOrderStautsCommitted == orderInfo.status) {
        [self.promptLabel setHidden:NO];
        
        self.amountLabelTopConstraint.constant = AMOUNT_LABEL_TOP_MAX;
    } else {
        [self.promptLabel setHidden:YES];
        
        self.amountLabelTopConstraint.constant = AMOUNT_LABEL_TOP_MIN;
    }
    
    // 订单金额
    self.amountLabel.text = [NSString stringWithFormat:@"订单金额(含运费)：￥%.2f", [orderInfo.food_amount floatValue]];
    
    // 收货人
    self.receiverLabel.text = [NSString stringWithFormat:@"收货人：%@", orderInfo.consigneeNameStr];
    
    // 手机
    self.telephoneLabel.text = [NSString stringWithFormat:@"手机：%@", orderInfo.phone];
    
    // 收货地址
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@", orderInfo.consigneeAddressStr];
    
    // 备注
    self.remarkLabel.text = [NSString stringWithFormat:@"备注：%@", orderInfo.remark];
    if (self.remarkLabel.text.length == 0) {
        self.remarkLabel.text = @"备注：无";
    }
}

+ (CGFloat)heightOfHeaderViewForOrder:(HXSOrderInfo *)orderInfo
{
    BOOL isPayed = YES;
    if (kHXSOrderStautsCommitted == orderInfo.status) {
        isPayed = NO;
    }
    
    // 收货地址
    NSString *addressStr = [NSString stringWithFormat:@"收货地址：%@", orderInfo.consigneeAddressStr];
    NSInteger padding = PADDING_TO_LEFT + PADDING_TO_RIGHT;
    CGFloat addressLabelHeight = [addressStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - padding, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                               context:nil].size.height;
    
    CGFloat addressLabelAddedHeight = MAX(HEIGHT_NORMAL_LABEL, ceil(addressLabelHeight)) - HEIGHT_NORMAL_LABEL;
    
    // 备注
    NSString *remarkStr = [NSString stringWithFormat:@"备注：%@", (0 <[orderInfo.remark length]) ? orderInfo.remark : @"无"];
    CGFloat remarkLabelHeight = [remarkStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - padding, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                          context:nil].size.height;
    
    CGFloat remarkLabelAddedHeight = MAX(HEIGHT_NORMAL_LABEL, ceil(remarkLabelHeight)) - HEIGHT_NORMAL_LABEL;
    
    
    NSInteger heightOfCell = HEIGHT_NORMAL_CELL + addressLabelAddedHeight + remarkLabelAddedHeight;
    
    if (isPayed) {
        heightOfCell -= AMOUNT_LABEL_TOP_MAX - AMOUNT_LABEL_TOP_MIN;
    }
    
    return heightOfCell;
}


@end
