//
//  HXSUpgradeModel.m
//  store
//
//  Created by ArthurWang on 16/2/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUpgradeModel.h"

@implementation HXSUpgradeModel

- (void)fetchCreditCardAuthStatus:(void (^)(HXSErrorCode status, NSString *message, HXSUpgradeAuthStatusEntity *entity))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] init];
    
    [HXStoreWebService getRequest:HXS_CREDIT_CARD_AUTH_STATUS
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           return ;
                       }
                       
                       HXSUpgradeAuthStatusEntity *entity = [HXSUpgradeAuthStatusEntity createEntityWithDictionary:data];
                       
                       block(status, msg, entity);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)upgradeCreditCard:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *info))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] init];
    
    [HXStoreWebService postRequest:HXS_CREDIT_CARD_ASCENSION_LINE
                 parameters:paramsDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, data);
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, data);
                    }];
}

@end
