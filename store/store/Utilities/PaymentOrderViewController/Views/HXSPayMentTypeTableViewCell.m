//
//  HXSPayMentTypeTableViewCell.m
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPayMentTypeTableViewCell.h"

#import <SDWebImage/SDImageCache.h>

@implementation HXSPayMentTypeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.subTitleLabel.textColor = [UIColor colorWithR:153 G:153 B:153 A:1];
    self.accessView.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setActionSheetEntity:(HXSActionSheetEntity *)actionSheetEntity
{
    self.titleLabel.text = actionSheetEntity.nameStr;
    self.subTitleLabel.text = actionSheetEntity.descriptionStr;
    [self.markImageView sd_setImageWithURL:[NSURL URLWithString:actionSheetEntity.iconURLStr]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        self.checkImageView.image = [UIImage imageNamed:@"btn_choose_blue"];
    }
    else
    {
        self.checkImageView.image = [UIImage imageNamed:@"btn_choose_normal"];
    }
}

/**
 *  更具需要支付的金额计算59钱包是否够支付
 *
 *  @param payAmount 商品总价
 */
- (void)getStoreCreditPayInfoWithPayAmount:(NSNumber *)payAmount {
    
    HXSUserCreditcardInfoEntity *creditcardInfoEntity = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    switch ([creditcardInfoEntity.accountStatusIntNum integerValue]) {
        case kHXSCreditAccountStatusNotOpen: // (0，未开通；1，已开通)
        case kHXSCreditAccountStatusChecking:
        case kHXSCreditAccountStatusCheckFailed:
        {
            self.accessView.hidden = NO;
            self.checkImageView.hidden = YES;
            
            return;
        }
            break;
            
        case kHXSCreditAccountStatusNormalFreeze:
        case kHXSCreditAccountStatusAbnormalFreeze:
        {
            self.accessView.hidden = YES;
            self.checkImageView.hidden = YES;
            self.subTitleLabel.text = @"已冻结";
            self.subTitleLabel.textColor = [UIColor colorWithR:245 G:70 B:66 A:1];
            
            return;
        }
            break;
        case kHXSCreditAccountStatusOpened:
        {
            self.accessView.hidden = YES;
            self.checkImageView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    float available = creditcardInfoEntity.availableConsumeDoubleNum.floatValue;
    self.subTitleLabel.text = [NSString stringWithFormat:@"剩余消费额度￥%0.2f",available];
    if (payAmount.floatValue > available) {
        self.accessView.hidden = YES;
        self.checkImageView.hidden = YES;
        self.subTitleLabel.text = @"额度不足";
        self.subTitleLabel.textColor = [UIColor colorWithR:245 G:70 B:66 A:1];
    }
}

@end
