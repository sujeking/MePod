//
//  DeliveryModel.m
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDeliveryModel.h"
#import "HXSDeliveryEntity.h"

@implementation HXSDeliveryModel

+ (void)getDeliveriesWithShopId:(NSNumber *)shopId complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *deliveries))block
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:shopId forKey:@"shop_id"];
    
    [HXStoreWebService getRequest:HXS_PRINT_DELIVERIES parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            DLog(@"--------云印店获取配送信息：%@",data);
            
            NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:5];
            if(DIC_HAS_ARRAY(data, @"deliveries")) {
                NSArray *arr = [data objectForKey:@"deliveries"];
                
                result = [HXSDeliveryEntity arrayOfModelsFromDictionaries:arr error:nil];
            }
            block(status,msg,result);
        } else {
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,nil);
    }];
}

@end
