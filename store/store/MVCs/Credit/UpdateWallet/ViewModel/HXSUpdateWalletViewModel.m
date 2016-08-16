//
//  HXSUpdateWalletViewModel.m
//  store
//
//  Created by  黎明 on 16/8/1.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUpdateWalletViewModel.h"


#define CREDITCARD_AUTHORIZE_NEXT   @"creditcard/authorize/next"

@implementation HXSUpdateWalletViewModel

+ (void)authorizeNextComplete:(void (^)(HXSErrorCode status, NSString *message))block
                           failure:(void(^)(NSString *errorMessage))failureBlock;
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@(1) forKey:@"type"];
    
    [HXStoreWebService postRequest:nil parameters:nil progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
    
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
    }];
}

@end
