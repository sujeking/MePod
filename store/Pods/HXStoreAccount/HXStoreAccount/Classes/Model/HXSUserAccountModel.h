//
//  HXSUserAccountModel.h
//  store
//
//  Created by ArthurWang on 15/11/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebServiceErrorCode.h"

@class HXSUserCreditcardInfoEntity;

#define KEY_USER_INFO_KNIGHT           @"knight"
#define KEY_USER_INFO_BASIC            @"basic_info"
#define KEY_USER_INFO_FINANCE          @"finanace_info"
#define KEY_USER_INFO_MY_BOX           @"my_box"

@interface HXSUserAccountModel : NSObject

// 获取账户信息
+ (void)getUserWholeInfo:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;

/**
 *  获取信用钱包信息
 *
 *  @param block 结果
 */
+ (void)getCreditCardInfo:(void (^)(HXSErrorCode code, NSString *message, HXSUserCreditcardInfoEntity *creditcardInfoEntity))block;

/**
 *  用户签到
 *
 *  @param block
 */
+ (void)userSignIn:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;

@end
