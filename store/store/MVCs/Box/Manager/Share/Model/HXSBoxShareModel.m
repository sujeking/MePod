//
//  HXSBoxShareModel.m
//  store
//
//  Created by 格格 on 16/6/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxShareModel.h"

@implementation HXSBoxShareModel

+ (void)shareBoxWithName:(NSString *)name phone:(NSString *)phone complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *data))block{
    
    NSDictionary *prama = @{
                            @"mobile":phone,
                            @"username":name
                            };
    [HXStoreWebService postRequest:HXS_BOX_SHARE parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,data);
        
    }];
}

@end
