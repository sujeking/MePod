//
//  HXSAgreementModel.m
//  store
//
//  Created by apple on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAgreementModel.h"

@implementation HXSAgreementModel

- (void)validatePayPWD:(NSString *)pwd Complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *result))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] initWithObjectsAndKeys: pwd, @"pay_password", nil];
    
    [HXStoreWebService getRequest:HXS_ACCOUNT_VERIFY_PAY_PWD
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if (kHXSNoError != status) {
            block(status, msg, nil);
            
            return ;
        }
        
        block(status, msg, data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status, msg, nil);
    }];
}

@end
