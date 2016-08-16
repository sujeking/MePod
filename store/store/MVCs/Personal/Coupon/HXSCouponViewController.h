//
//  HXSCouponViewController.h
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSCoupon.h"

@protocol HXSCouponViewControllerDelegate <NSObject>

- (void)didSelectCoupon:(HXSCoupon *)coupon;

@end

@interface HXSCouponViewController : HXSBaseViewController

@property (nonatomic, assign) BOOL isFromPersonalCenter;

@property (nonatomic, weak) id<HXSCouponViewControllerDelegate> delegate;

@property (nonatomic, assign) HXSCouponScope couponScope;

@end
