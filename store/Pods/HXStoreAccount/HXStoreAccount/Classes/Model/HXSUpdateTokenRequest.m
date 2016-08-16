//
//  HXSUpdateTokenRequest.m
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSUpdateTokenRequest.h"

#import "HXStoreWebServiceURL.h"
#import "HXStoreWebService.h"

@implementation HXSUpdateTokenRequest

static HXSUpdateTokenRequest * _instance = nil;

+ (HXSUpdateTokenRequest *) currentRequest
{
    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[HXSUpdateTokenRequest alloc] init];
        }
    }
    
    return _instance;
}

- (void)startUpdateTokenWithDeviceId:(NSString *)deviceId
                              siteId:(NSNumber *)siteId
                              userId:(NSNumber *)userId
                            complete:(void (^)(HXSErrorCode, NSString *, NSString *))block
{
    if (deviceId == nil)
    {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:deviceId forKey:SYNC_DEVICE_ID];
    if (siteId != nil) {
        [dic setObject:siteId forKey:SYNC_SITE_ID];
    }
    if (userId != nil) {
        [dic setObject:userId forKey:@"uid"];
    }
    
    [HXStoreWebService getRequest:HXS_TOKEN_UPDATE
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                            block(status, msg, [data objectForKey:SYNC_USER_TOKEN]);
                       }else {
                            block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
    
}

@end
