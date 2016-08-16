//
//  HXSOrderDetailInfoView.m
//  store
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderDetailInfoView.h"
#import "HXSDigitalMobileConfirmOrderViewController.h"
#import "HXSUserAccount.h"
#import "HXSConfirmOrderEntity.h"
@implementation HXSOrderDetailInfoView

- (void)awakeFromNib
{
    self.goodsName.textContainer.maximumNumberOfLines = 2;
    self.goodsName.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)initOrderDetailInfo:(HXSConfirmOrderEntity *)orderDetail
{
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:orderDetail.goodsImageUrl] placeholderImage:[UIImage imageNamed:@"img_kp_3c"]];
    self.remark.text = @"";
    self.coupon.text = @"";
    self.downPayment.text = @"";
    self.monthPayments.text = @"";
    self.installmentTime.text = @"";
    self.installmentPayment.text = @"";
    
    self.goodsName.text = orderDetail.goodsName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%0.2f",orderDetail.goodsPrice.floatValue];
    self.goodsNumber.text = [NSString stringWithFormat:@"×%@",orderDetail.goodsNum];
    self.totalPrice.text = [NSString stringWithFormat:@"￥%0.2f",orderDetail.total.floatValue];
    self.goodsProperty.text = [NSString stringWithFormat:@"%@",orderDetail.goodsProperty];
    self.goodsService.text = [NSString stringWithFormat:@"%@",orderDetail.goodsService];
    self.carriage.text = [NSString stringWithFormat:@"￥%0.2f",orderDetail.carriage.floatValue];
    
}

- (IBAction)addRemark:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addRemarkAction)]) {
        [self.delegate performSelector:@selector(addRemarkAction) withObject:nil];
    }
}

- (IBAction)showCoupon:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(showCouponAction)]) {
        [self.delegate performSelector:@selector(showCouponAction) withObject:nil];
    }
}

- (IBAction)addMoreInfoForInstallment:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addMoreInfoForInstallmentAction)]) {
        [self.delegate performSelector:@selector(addMoreInfoForInstallmentAction) withObject:nil];
    }
}

- (IBAction)changeInstallment:(UISwitch *)sender
{
    if ([self.delegate respondsToSelector:@selector(changeInstallmentAction:)]) {
        [self.delegate performSelector:@selector(changeInstallmentAction:) withObject:sender];
    }
}

- (IBAction)selectInstallmentDetail:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectInstallmentDetailAction)]) {
        [self.delegate performSelector:@selector(selectInstallmentDetailAction) withObject:nil];
    }
}

- (IBAction)showInstallmentTip:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(showInstallmentTip)]) {
        [self.delegate performSelector:@selector(showInstallmentTip) withObject:nil];
    }
}

@end
