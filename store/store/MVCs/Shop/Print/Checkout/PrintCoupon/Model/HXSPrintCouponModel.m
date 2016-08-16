//
//  HXSPrintCouponModel.m
//  store
//
//  Created by 格格 on 16/5/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintCouponModel.h"
#import "HXSCoupon.h"

@implementation HXSPrintCouponModel

+ (void)getPrintCouponpicListWithType:(NSNumber *)type
                               amount:(NSNumber *)amount
                                isAll:(BOOL)isAll
                             complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *printCoupons))block{
    
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    [prama setObject:type forKey:@"type"];
    [prama setObject:amount forKey:@"amount"];
    
    [HXStoreWebService getRequest:HXS_PRINT_COUPONPIC_LIST parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        if(kHXSNoError == status){
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"coupons"];
            if(arr){
                for(NSDictionary *dic in arr){
                    HXSCoupon *temp = [HXSCoupon objectFromJSONObject:dic];
                    [resultArray addObject:temp];
                }
            }
            block(status,msg,resultArray);
        } else {
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];

}

@end
