//
//  HXSPersonalInfoDomel.h
//  store
//
//  Created by ArthurWang on 15/8/7.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreLogin.h"

typedef NS_ENUM(NSUInteger, HXSVerifyCodeType ) {
    HXSVerifyAppRegister = 0,
    HXSVerifyAppLogin,
    HXSVerifyPhoneBind,
    HXSVerifyForgetPayPasswd,
};

@interface HXSPersonalInfoModel : NSObject

#pragma mark - Public Methods

- (void)updateNickName:(NSString *)nickNameStr
              complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *nickNameDic))block;

- (void)updateLoginPassword:(NSString *)oldPasswordStr
                     passwd:(NSString *)passwdStr
              comfirePasswd:(NSString *)comfirePasswdStr
                  complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *passwordDic))block;

- (void)updateHeadPortrait:(UIImage *)image
                  complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *passwordDic))block;

// 获取验证码
+ (void)sendAuthCodeWithPhone:(NSString *)phoneStr
                   verifyType:(HXSVerifyCodeType) type
                     complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *authInfo))block;
// 手机短信登录
+ (void)verifAuthCodeWithPhone:(NSString *)phoneStr
                          code:(NSString *)codeStr
                    verifyType:(HXSVerifyCodeType)type
                      complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *authInfo))block;

// 忘记支付密码时验证手机号
+ (void)verifyTelephoneForForgetPayPasswd:(NSString *)telephone
                               verifyCode:(NSString *)verifyCode
                               completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;

// 忘记支付密码时重置支付密码
+ (void)resetPayPassWord:(NSString *)passwd
              completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;

// 更换绑定手机时，验证旧手机
+ (void)verifyOldBindTelephone:(NSString *)telephone
                    verifyCode:(NSString *)verifyCode
                    completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;

+ (void)modifyBindTelephone:(NSString *)telephone
                 verifyCode:(NSString *)verifyCode
                 completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;


@end
