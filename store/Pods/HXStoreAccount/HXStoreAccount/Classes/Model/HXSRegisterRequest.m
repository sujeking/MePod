//
//  HXSRegisterRequest.m
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSRegisterRequest.h"

#import "NSMutableDictionary+Safety.h"
#import "NSString+Addition.h"
#import "HXStoreWebService.h"
#import "HXSUserAccount.h"
#import "HXSUserBasicInfo.h"

@implementation HXSRegisterRequest

- (void)registerWith:(NSString *)userName
            password:(NSString *)password
               email:(NSString *)email
       completeBlock:(void (^)(HXSErrorCode, NSString *, NSNumber *, HXSUserBasicInfo *))block
{
    if (userName == nil || password == nil)
    {
        block(kHXSParamError, @"用户名和密码不能为空", nil, nil);
        return;
    }
    
    if (email == nil) {
        block(kHXSParamError, @"邮箱不能为空", nil, nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObjectExceptNil:userName forKey:@"username"];
    [dic setObjectExceptNil:[NSString md5:password] forKey:@"password"];
    [dic setObjectExceptNil:email forKey:@"email"];
    [dic setObjectExceptNil:[HXSUserAccount currentAccount].strToken forKey:@"token"];
    
    [HXStoreWebService postRequest:HXS_USER_REGISTER
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == 0) {
                            NSNumber * userId = [NSNumber numberWithInteger:[[data objectForKey:@"uid"] integerValue]];
                            HXSUserBasicInfo * info = [[HXSUserBasicInfo alloc] initWithServerDic:data];
                            block(kHXSNoError, msg, userId, info);
                        
                        }else {
                            block(status, msg, nil, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil, nil);
                    }];
}

- (void)registerWithPhone:(NSString *)userPhone
                 password:(NSString *)password
                     code:(NSString *)code
           invitationcode:(NSString *)invitation_code
            completeBlock:(void (^)(HXSErrorCode, NSString *, NSNumber *, HXSUserBasicInfo *))block
{
    
    if (userPhone == nil || password == nil || userPhone.length == 0 || password.length == 0)
    {
        block(kHXSParamError, @"手机号和密码不能为空", nil, nil);
        return;
    }
    
    if (code == nil || code.length == 0) {
        block(kHXSParamError, @"验证码不能为空", nil, nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObjectExceptNil:userPhone forKey:@"phone"];
    [dic setObjectExceptNil:[NSString md5:password] forKey:@"password"];
    [dic setObjectExceptNil:code forKey:@"verification_code"];
    [dic setObjectExceptNil:[HXSUserAccount currentAccount].strToken forKey:@"token"];
    if(invitation_code && invitation_code.length > 0) {
        [dic setObjectExceptNil:invitation_code forKey:@"invitation_code"];
    }
    
    [HXStoreWebService postRequest:HXS_USER_REGISTER
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == 0) {
                            NSNumber * userId = [NSNumber numberWithInteger:[[data objectForKey:@"uid"] integerValue]];
                            HXSUserBasicInfo * info = [[HXSUserBasicInfo alloc] initWithServerDic:data];
                            block(kHXSNoError, msg, userId, info);
                        }else {
                            block(status, msg, nil, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil, nil);
                    }];

}


// 用户注册
- (void)registerWithPassword:(NSString *)passwordStr
                  completion:(void (^)(HXSErrorCode, NSString *, NSNumber *, HXSUserBasicInfo *))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSString md5:passwordStr], @"password",
                               nil];
    
    [HXStoreWebService postRequest:HXS_ACCOUNT_USER_PHONE_REGISTER
                 parameters:paramsDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == 0) {
                            NSNumber * userId = [NSNumber numberWithInteger:[[data objectForKey:@"uid"] integerValue]];
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
