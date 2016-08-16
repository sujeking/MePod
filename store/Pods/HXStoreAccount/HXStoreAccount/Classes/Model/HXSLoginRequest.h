//
//  HXSLoginRequest.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebServiceErrorCode.h"
#import "HXMacrosEnum.h"

@class HXSUserBasicInfo;

@interface HXSLoginRequest : NSObject

- (void)loginWith:(NSString *)username
         password:(NSString *)password
    completeBlock:(void (^)(HXSErrorCode errorcode, NSString * msg, NSNumber * userID, HXSUserBasicInfo * basicInfo))block;

- (void)loginWithPhone:(NSString *)phone
            verifycode:(NSString *)verifycode
         completeBlock:(void (^)(HXSErrorCode errorcode, NSString * msg, NSNumber * userID, HXSUserBasicInfo * basicInfo))block;

// 使用第三方帐号登陆
- (void)loginWithThirdAccount:(NSString *)accountID
                 accountToken:(NSString *)accountToken
                  accountType:(HXSAccountType)accountType
                completeBlock:(void (^)(HXSErrorCode errorcode, NSString * msg, NSNumber * userID, HXSUserBasicInfo * basicInfo))block;

@end