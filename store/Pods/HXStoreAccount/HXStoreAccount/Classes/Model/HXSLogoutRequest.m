//
//  HXSLogoutRequest.m
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSLogoutRequest.h"

#import "HXSDeviceUpdateRequest.h"
#import "HXStoreWebService.h"

@implementation HXSLogoutRequest

- (void)startRequest:(NSNumber *)userID token:(NSString *)token;
{
    if (userID == nil || token == nil)
        return;
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:userID forKey:@"uid"];
    [dic setObject:token forKey:@"token"];
    
    [HXStoreWebService postRequest:HXS_USER_LOGOUT
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       [[HXSDeviceUpdateRequest currentRequest] startUpdate];
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       // Do nothing
                   }];
}

@end