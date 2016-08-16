//
//  HXSTaskDetialModel.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskDetialModel.h"


@implementation HXSTaskDetialModel

+ (void) getTaskOrderDerialWithDeliveryOrderId:(NSString *)delivery_order_id
                                      complete:(void(^)(HXSErrorCode code, NSString * message, HXSTaskOrderDetial * orderDetial))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:delivery_order_id forKey:@"delivery_order_id"];
    
    [HXStoreWebService getRequest:HXS_KNIGHT_DELIVERY_OEDER_DETIAL
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        if(kHXSNoError == status){
            HXSTaskOrderDetial *temp = [HXSTaskOrderDetial objectFromJSONObject:data];
            block(status,msg,temp);
        }else{
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,nil);
        
    }];
}

+ (void)cancleKnightDeliveryOrderWithDeliveryorderId:(NSString *)delivery_order_id
                                            complete:(void(^)(HXSErrorCode code, NSString * message,NSDictionary * dic))block{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:delivery_order_id forKey:@"delivery_order_id"];
    
    [HXStoreWebService postRequest:HXS_KNIGHT_DELIVERY_ORDER_CANCLE
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)finishKnightDeliveryOrderWithDeliveryOrderId:(NSString *)delivery_order_id
                                            complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary * dic))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:delivery_order_id forKey:@"delivery_order_id"];
    
    [HXStoreWebService postRequest:HXS_KNIGHT_DELIVERY_ORDER_COMPLETE
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

@end
