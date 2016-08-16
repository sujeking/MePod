//
//  HXSUserAccount.h
//  store
//
//  Created by chsasaw on 14/10/26.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXSUserInfo, HXSUserBasicInfo;

@interface HXSUserAccount : NSObject

@property (copy, nonatomic) NSString * strToken;
@property (copy, nonatomic) NSNumber * userID;

+ (HXSUserAccount *) currentAccount;

- (void)updateToken;

- (void)registerWithName:(NSString *)userName
                 password:(NSString *)password
                    email:(NSString *)email;
- (void)registerWithPhone:(NSString *)userPhone
                 password:(NSString *)password
                    verifycode:(NSString *)verifycode
            invitationcode:(NSString *)invitationcode;
// 用户注册
- (void)registerWithPassword:(NSString *)passwordStr;

- (void)login:(NSString *)username password:(NSString *)password;
- (void)loginWithPhone:(NSString *)phone verifycode:(NSString *)verifycode;
- (void)loginWithThirdAccount:(NSString *)userID token:(NSString *)token;

- (void)logout;

- (BOOL)isLogin;

- (void) loadUserInfo:(HXSUserBasicInfo *)basicInfo;

// 我的用户信息
@property (strong, nonatomic) HXSUserInfo * userInfo;

- (NSString *)homeDirectory;

@end
