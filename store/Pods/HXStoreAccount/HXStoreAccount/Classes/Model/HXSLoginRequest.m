//
//  HXSLoginRequest.m
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSLoginRequest.h"

#import "NSMutableDictionary+Safety.h"
#import "NSString+Addition.h"
#import "HXSUserAccount.h"
#import "HXStoreWebService.h"
#import "HXSUserBasicInfo.h"

@implementation HXSLoginRequest

- (void)loginWith:(NSString *)username
         password:(NSString *)password
    completeBlock:(void (^)(HXSErrorCode, NSString *, NSNumber *, HXSUserBasicInfo *))block
{
    if (username == nil || password == nil)
    {
        block(kHXSParamError, @"用户名和密码不能为空", nil, nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObjectExceptNil:username forKey:@"username"];
    [dic setObjectExceptNil:[NSString md5:password] forKey:@"password"];
    [dic setObjectExceptNil:[HXSUserAccount currentAccount].strToken forKey:@"token"];
    [dic setObjectExceptNil:@"59" forKey:@"src"];
    
    [HXStoreWebService postRequest:HXS_USER_LOGIN
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == 0) {
                            NSNumber * userId = [data objectForKey:@"uid"];
                            HXSUserBasicInfo * info = [[HXSUserBasicInfo alloc] initWithServerDic:data];
                                block(kHXSNoError, msg, userId, info);
                        }else {
                                block(status, msg, nil, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                            block(status, msg, nil, nil);
                    }];
}

- (void)loginWithPhone:(NSString *)phone
            verifycode:(NSString *)verifycode
         completeBlock:(void (^)(HXSErrorCode, NSString *, NSNumber *, HXSUserBasicInfo *))block
{
    if (phone == nil || verifycode == nil || phone.length == 0 || verifycode.length == 0)
    {
        block(kHXSParamError, @"用户名和验证码不能为空", nil, nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObjectExceptNil:phone forKey:@"username"];
    [dic setObjectExceptNil:verifycode forKey:@"verification_code"];
    [dic setObjectExceptNil:[HXSUserAccount currentAccount].strToken forKey:@"token"];
    [dic setObjectExceptNil:@"59" forKey:@"src"];
    
    [self post:HXS_USER_LOGIN dic:dic completeBlock:block];
}

- (void)loginWithThirdAccount:(NSString *)accountID
                 accountToken:(NSString *)accountToken
                  accountType:(HXSAccountType)accountType
                completeBlock:(void (^)(HXSErrorCode, NSString *, NSNumber *, HXSUserBasicInfo *))block
{
    if (accountToken == nil || accountID == nil)
    {
        block(kHXSParamError, @"数据错误", nil, nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObjectExceptNil:[HXSUserAccount currentAccount].strToken forKey:@"token"];
    if (accountType == kHXSSinaWeiboAccount)
    {
        [dic setObjectExceptNil:@"weibo" forKey:@"src"];
        [dic setObjectExceptNil:accountID forKey:@"weibo_id"];
        [dic setObjectExceptNil:accountToken forKey:@"access_token"];
    }
    else if (accountType == kHXSQQAccount)
    {
        [dic setObjectExceptNil:@"qq" forKey:@"src"];
        [dic setObjectExceptNil:accountID forKey:@"qq_openid"];
        [dic setObjectExceptNil:accountToken forKey:@"access_token"];
    }
    else if (accountType == kHXSWeixinAccount)
    {
        [dic setObjectExceptNil:@"wechat" forKey:@"src"];
        [dic setObjectExceptNil:accountID forKey:@"wechat_openid"];
        [dic setObjectExceptNil:accountToken forKey:@"access_token"];
    }else if (accountType == kHXSRenrenAccount)
    {
        [dic setObjectExceptNil:@"renren" forKey:@"src"];
        [dic setObjectExceptNil:accountID forKey:@"renren_id"];
        [dic setObjectExceptNil:accountToken forKey:@"access_token"];
    }
    
    [self post:HXS_USER_LOGIN dic:dic completeBlock:block];
}

- (void)post:(NSString *)strURL dic:(NSDictionary *)dic completeBlock:(void (^)(HXSErrorCode, NSString *, NSNumber *, HXSUserBasicInfo *))block
{
    
    [HXStoreWebService postRequest:strURL
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == 0) {
                            NSNumber * userId = [data objectForKey:@"uid"];
                            HXSUserBasicInfo * info = [[HXSUserBasicInfo alloc] initWithServerDic:data];
                            block(kHXSNoError, msg, userId, info);
                        }else {
                            block(status, msg, nil, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil, nil);
                    }];
}

@end
