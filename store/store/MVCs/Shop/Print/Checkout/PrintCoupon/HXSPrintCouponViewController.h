//
//  HXSPrintCouponViewController.h
//  store
//
//  Created by 格格 on 16/5/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

#import "HXSCouponViewCell.h"
#import "HXSCoupon.h"

@protocol HXSPrintCouponViewControllerDelegate <NSObject>

- (void)didSelectCoupon:(HXSCoupon *)coupon;

@end

@interface HXSPrintCouponViewController : HXSBaseViewController

@property (nonatomic, assign) BOOL isFromPersonalCenter;

@property (nonatomic, weak) id<HXSPrintCouponViewControllerDelegate> delegate;

@property (nonatomic, assign) HXSCouponScope couponScope;

- (void)setOrderAmount:(NSNumber *)amount docType:(NSNumber *)type isAll:(BOOL)isAll;
@end
