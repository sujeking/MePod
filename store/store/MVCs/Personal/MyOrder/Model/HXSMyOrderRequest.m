//
//  HXSMyOrderRequest.m
//  store
//
//  Created by chsasaw on 14/12/8.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSMyOrderRequest.h"

@implementation HXSMyOrderRequest

- (void)getMyOrderListWithToken:(NSString *)token
                           page:(int)page type:(int)type
                       complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    if (token == nil)
    {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dic setObject:@"10" forKey:@"num_per_page"];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    [HXStoreWebService getRequest:HXS_USER_ORDERS
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray * orders = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"orders")) {
                               for(NSDictionary * dic in [data objectForKey:@"orders"]) {
                                   if((NSNull *)dic == [NSNull null]) {
                                       continue;
                                   }
                                   HXSOrderInfo * order = [[HXSOrderInfo alloc] initWithDictionary:dic];
                                   if(order) {
                                       [orders addObject:order];
                                   }
                               }
                           }
                           block(kHXSNoError, msg, orders);
                       }else {
                            block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
    
}



@end
