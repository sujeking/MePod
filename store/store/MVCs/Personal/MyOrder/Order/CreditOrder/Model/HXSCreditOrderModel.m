//
//  HXSCreditOrderModel.m
//  store
//
//  Created by ArthurWang on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditOrderModel.h"

@implementation HXSCreditOrderModel

- (void)fetchCreditcardOrderListWithPage:(NSNumber *)pageIntNum
                              numPerPage:(NSNumber *)numPerPageIntNum
                                    type:(NSNumber *)typeIntNum
                                complete:(void (^)(HXSErrorCode status, NSString *message, HXSCreditOrderEntity *orderEntity))block
{
    NSDictionary *paramsDic = @{
                                @"page":            pageIntNum,
                                @"num_per_page":    numPerPageIntNum,
                                @"type":            typeIntNum,
                                };
    
    [HXStoreWebService getRequest:HXS_CHARGE_CENTER_ORDER_LIST
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSCreditOrderEntity *orderEntity = [[HXSCreditOrderEntity alloc] initWithDictionary:data];
                       
                       block(status, msg, orderEntity);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

@end
