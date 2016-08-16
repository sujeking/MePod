//
//  HXSPayPasswordUpdateModel.m
//  store
//
//  Created by hudezhi on 15/8/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPayPasswordUpdateModel.h"

@implementation HXSPayPasswordUpdateModel

- (void)updatePayPassWord:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block
{
    NSString *deviceToken = [HXSUserAccount currentAccount].strToken;
    
    NSDictionary *paramDic ;
    
    if([_oldPasswd trim].length > 0) {
        paramDic = @{SYNC_USER_TOKEN:deviceToken,
                     @"old_password":[NSString md5:_oldPasswd],
                     @"new_password":[NSString md5:_passwd]};
    }
    else {
        paramDic = @{SYNC_USER_TOKEN:deviceToken,
                     @"old_password":@"",
                     @"new_password":[NSString md5:_passwd]};
    }
    
    [HXStoreWebService getRequest:HXS_ACCOUNT_PAY_PASSWORD_UPDATE
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (status == kHXSNoError) {
                            block(status, msg, data);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}


// 免密支付修改
+ (void)updateExemptionStatus:(NSNumber *)status password:(NSString *)passwordStr completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *data))block
{
    NSString *passwordMD5Str = nil;
    if ((nil != passwordStr)
        && (0 < [passwordStr length]) ) {
        passwordMD5Str = [NSString md5:passwordStr];
    } else {
        passwordMD5Str = @"";
    }
    
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               status, @"status",
                               passwordMD5Str, @"pay_password", nil];
    
    [HXStoreWebService getRequest:HXS_EXEMPTION_STATUS_UPDATE
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status) {
                                  block(status, msg, data);
                              } else {
                                  block(status, msg, nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

@end
