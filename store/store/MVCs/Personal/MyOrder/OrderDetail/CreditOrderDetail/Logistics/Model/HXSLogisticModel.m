//
//  HXSLogisticModel.m
//  store
//
//  Created by 沈露萍 on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSLogisticModel.h"
#import "HXSLogisticEntity.h"

@implementation HXSLogisticModel

- (void)getLogisticWithOrderSn:(NSString *)oderSn
               MessageComplete:(void (^)(HXSErrorCode code, NSString *message, HXSLogisticEntity *logisticEntity))block
{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:oderSn, @"order_sn", nil];
    
    [HXStoreWebService getRequest:HXS_TIP_TRACK_GETTRACK
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSLogisticEntity *logisticEntity = [[HXSLogisticEntity alloc] initWithDict:data];
                       
                       block(status, msg, logisticEntity);
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}
@end
