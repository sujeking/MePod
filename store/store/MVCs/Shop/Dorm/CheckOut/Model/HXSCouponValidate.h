//
//  HXSCouponValidate.h
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSCoupon.h"
#import "HXSExpectTimeEntity.h"

@interface HXSCouponValidate : NSObject

- (void)validateWithToken:(NSString *)token
               couponCode:(NSString *)couponCode
                     type:(HXSCouponScope)type
                 complete:(void (^)(HXSErrorCode code, NSString * message, HXSCoupon * coupon))block;

/**
 *  获取店铺可配送时间列表
 *
 *  @param shopIDIntNum 店铺shopid
 *  @param block        返回结果
 */
- (void)fetchExpectTimeList:(NSNumber *)shopIDIntNum
                   compelte:(void (^)(HXSErrorCode code, NSString *message, NSArray *expectTimeArr))block;

@end