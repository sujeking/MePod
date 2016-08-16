//
//  HXSConfirmOrderModel.m
//  store
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSConfirmOrderModel.h"

@implementation HXSConfirmOrderModel

- (void)checkGoodsStockWithGoodsId:(NSNumber *)goodsId andAddressCode:(NSString *)addressCode Complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *stockInfo))block
{
    NSDictionary *paramDic = @{@"sku_id":goodsId,@"address":addressCode};
    
    [HXStoreWebService getRequest:HXS_TIP_ITEM_STOCK
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       block(status, msg, data);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)creaeOrderWithOrderInfo:(HXSConfirmOrderEntity *)confirmOrderEntity Complete:(void (^)(HXSErrorCode code, NSString *message, HXSOrderInfo *orderInfo))block
{
    NSMutableDictionary *paramDic = [confirmOrderEntity getDictionary];
    
    
    [HXStoreWebService postRequest:HXS_TIP_ORDER_CREATE
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if (kHXSNoError != status) {
            block(status, msg, nil);
            
            return ;
        }
        
        HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] initWithDictionary:data];
        
        block(status, msg, orderInfo);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status, msg, nil);
    }];
}
@end
