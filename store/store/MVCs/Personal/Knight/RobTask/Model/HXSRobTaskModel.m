//
//  HXSRobTaskModel.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSRobTaskModel.h"

@implementation HXSRobTaskModel

+ (void)getKnightDeliveryOrderListWithStatus:(NSNumber *)status
                                        page:(NSNumber *)page
                                        size:(NSNumber *)size
                                    complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * orders))block{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:status forKey:@"status"];
    [dic setObject:page forKey:@"page"];
    [dic setObject:size forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_KNIGHT_DELIVERY_OEDER_LIST
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            
            NSMutableArray *resultArr = [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"orders"];
            if(arr){
                for(NSDictionary *dic in arr){
                    HXSTaskOrder *temp = [HXSTaskOrder objectFromJSONObject:dic];
                    [resultArr addObject:temp];
                }
            }
            block(status,msg,resultArr);
        
        }else{
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)getKnightDeliveryListHadledWithPage:(NSNumber *)page
                                       size:(NSNumber *)size
                                   complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * orders))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:page forKey:@"page"];
    [dic setObject:size forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_KNIGHT_DELIVERY_OEDER_LIST_FINISH
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            
            NSMutableArray *resaultArr = [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"view"];
            if(arr){
                for(NSDictionary *dic in arr){
                    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                    
                    NSNumber *timeNum = [dic objectForKey:@"date"];
                    [tempDic setObject:timeNum forKey:@"date"];
                    
                    NSMutableArray *tempArr = [NSMutableArray array];
                    NSArray *items = [dic objectForKey:@"orders"];
                    if(items){
                        for(NSDictionary *itemDic in items){
                            HXSTaskOrder *tempTask = [HXSTaskOrder objectFromJSONObject:itemDic];
                            [tempArr addObject:tempTask];
                        }
                    }
                    [tempDic setObject:tempArr forKey:@"orders"];
                    [resaultArr addObject:tempDic];
                }
            }
            
            block(status,msg,resaultArr);
        
        }else{
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}


+ (void)robTaskWithOrderSn:(NSString *)order_sn
                  complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary * dic))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:order_sn forKey:@"order_sn"];
    
    [HXStoreWebService postRequest:HXS_KNIGHT_DELIVERY_ORDER_GAIN
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
         block(status,msg,data);
    }];
}

@end
