//
//  HXSRegisterRequest.h
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebServiceErrorCode.h"

@class HXSUserBasicInfo;

@interface HXSRegisterRequest : NSObject

- (void)registerWith:(NSString *)userName
            password:(NSString *)password
               email:(NSString *)email
       completeBlock:(void (^)(HXSErrorCode errorcode, NSString *msg, NSNumber *userID, HXSUserBasicInfo *info))block;

- (void)registerWithPhone:(NSString *)userPhone
                 password:(NSString *)password
                     code:(NSString *)code
           invitationcode:(NSString *)invitation_code
            completeBlock:(void (^)(HXSErrorCode errorcode, NSString * msg, NSNumber * userID, HXSUserBasicInfo * info))block;

// 用户注册
- (void)registerWithPassword:(NSString *)passwordStr
                  completion:(void (^)(HXSErrorCode errorcode, NSString * msg, NSNumber * userID, HXSUserBasicInfo * info))block;

@end