//
//  HXSCouponListRequest.m
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSCouponListRequest.h"
#import "HXSCoupon.h"

@implementation HXSCouponListRequest

- (void)getCouponsWithToken:(NSString *)token
                  available:(BOOL)available
                      scope:(HXSCouponScope)couponScope
                   complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    if (token == nil)
    {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:[NSNumber numberWithBool:available] forKey:@"available"];
    if (kHXSCouponScopeNone != couponScope) {
        [dic setObject:[NSNumber numberWithInt:couponScope] forKey:@"scope"];
    }

    [HXStoreWebService getRequest:HXS_COUPON_LIST
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           DLog(@"----------------- 优惠券数据:%@", data);
                           NSMutableArray * coupons = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"coupons")) {
                               for(NSDictionary * dic in [data objectForKey:@"coupons"]) {
                                   HXSCoupon * coupon = [[HXSCoupon alloc] initWithDictionary:dic];
                                   if(coupon != nil) {
                                       [coupons addObject:coupon];
                                   }
                               }
                           }
                            block(kHXSNoError, msg, coupons);
                       }else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
    
}

@end