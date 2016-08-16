//
//  HXSQRModel.m
//  store
//
//  Created by 格格 on 16/5/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSQRModel.h"


@implementation HXSQRModel

+ (void)knightDelverlyOrderCodeWithDeliveryOrderId:(NSString *)delivery_order_id
                                           orderId:(NSString *)order_id
                                            shopId:(NSNumber *)shop_id
                                          complete:(void(^)(HXSErrorCode code, NSString * message, HXSQRCodeEntity * codeEntity))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:delivery_order_id forKey:@"delivery_order_id"];
    [dic setObject:order_id forKey:@"order_id"];
    [dic setObject:shop_id forKey:@"shop_id"];
    
    [HXStoreWebService getRequest:HXS_KNIGHT_DELIVERY_ORDER_CODE
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            HXSQRCodeEntity *temp = [HXSQRCodeEntity objectFromJSONObject:data];
            block(status,msg,temp);
        }else{
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

@end
