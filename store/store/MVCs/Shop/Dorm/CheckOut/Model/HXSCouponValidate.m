//
//  HXSCouponValidate.m
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSCouponValidate.h"


@implementation HXSCouponValidate

- (void)validateWithToken:(NSString *)token
               couponCode:(NSString *)couponCode
                     type:(HXSCouponScope)type
                 complete:(void (^)(HXSErrorCode code, NSString * message, HXSCoupon * coupon))block
{
    if (token == nil)
    {
        block(kHXSParamError, @"参数错误", nil);
        
        return;
    }
    
    if (couponCode == nil)
    {
        block(kHXSParamError, @"券号不能为空", nil);
        
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:couponCode forKey:@"code"];
    [dic setObject:@(type) forKey:@"scope"];

    [HXStoreWebService postRequest:HXS_COUPON_VALIDATE
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            HXSCoupon * coupon = [[HXSCoupon alloc] initWithDictionary:data];
                            block(kHXSNoError, msg, coupon);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

- (void)fetchExpectTimeList:(NSNumber *)shopIDIntNum
                   compelte:(void (^)(HXSErrorCode code, NSString *message, NSArray *expectTimeArr))block
{
    NSDictionary *paramsDic = @{@"shop_id": shopIDIntNum};
    
    [HXStoreWebService getRequest:HXS_SHOP_EXPECT_TIME_LIST
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return;
                       }
                       NSMutableArray *timesMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       if (DIC_HAS_ARRAY(data, @"times")) {
                           NSArray *timesArr = [data objectForKey:@"times"];
                           
                           timesMArr = [HXSExpectTimeEntity arrayOfModelsFromDictionaries:timesArr error:nil];
                       }
                       
                       block(status, msg, timesMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

@end