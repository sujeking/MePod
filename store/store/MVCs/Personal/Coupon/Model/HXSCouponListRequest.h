//
//  HXSCouponListRequest.h
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCouponListRequest : NSObject

- (void)getCouponsWithToken:(NSString *)token
                  available:(BOOL)available
                      scope:(HXSCouponScope)couponScope
                   complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * coupons))block;

@end
