//
//  HXSInstallmentDetailModel.m
//  store
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSInstallmentDetailModel.h"

@implementation HXSInstallmentDetailModel

- (void)fetchDownpaymentListWithPrice:(NSNumber *)price Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *downpaymentEntityList))block
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:price forKey:@"price"];
    
    [HXStoreWebService getRequest:HXS_TIP_ORDER_GET_DOWNPAYMENT_LIST
                 parameters:data
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (kHXSNoError != status) {
                            block(status, msg, nil);
                            
                            return ;
                        }
                        
                        NSArray *list = data[@"downpayments"];
                        
                        NSMutableArray *result = [NSMutableArray array];
                        for(NSDictionary *dic in list) {
                            HXSDownpaymentEntity *item = [[HXSDownpaymentEntity alloc] initWithDictionary:dic];
                            [result addObject:item];
                        }
                        
                        block(status, msg, result);
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

- (void)fetchInstallmentInfoWithPrice:(NSNumber *)price percent:(NSNumber *)percent complete:(void (^)(HXSErrorCode code, NSString *message, HXSInstallmentEntity *installmentEntity))block
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:price forKey:@"price"];
    [dic setObject:percent forKey:@"percent"];
    
    [HXStoreWebService getRequest:HXS_TIP_ORDER_GET_INSTALLMENT_LIST
                 parameters:dic
                  progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (kHXSNoError != status) {
                            block(status, msg, nil);
                            
                            return ;
                        }
                        
                        HXSInstallmentEntity *installmentEntity = [[HXSInstallmentEntity alloc] initWithDictionary:data];
                        
                        block(status, msg, installmentEntity);
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}
@end
