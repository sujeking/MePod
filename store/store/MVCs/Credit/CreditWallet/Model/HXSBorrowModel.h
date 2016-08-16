//
//  HXSBorrowModel.h
//  store
//
//  Created by hudezhi on 15/8/17.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSBorrowMonthlyMortgageInfo.h"
#import "HXSBorrowSubmitInfo.h"
#import "HXSContactInfoEntity.h"

@interface HXSBorrowModel : NSObject

/*
 * 信用购账户信息
 */
+ (void)getCreditAccountInfo:(void (^)(HXSErrorCode code, NSString *message, HXSUserCreditcardInfoEntity *payInfo))block;

/*
 * 信用钱包用途列表
 */
+ (void)getBorrowPurpose:(void (^)(HXSErrorCode code, NSString *message, NSArray *payInfo))block;

/*
 * 分期方式的月供信息
 */
+ (void)getInstallmentMonthlyInfoWithLoanAmount:(double)loanAmountNum
                                       complete:(void (^)(HXSErrorCode code, NSString *message, HXSBorrowMonthlyMortgageInfo *payInfo))block;

/*
 * 取现申请提交
 */
+ (void)applyEncashmentWithPassword:(NSString *)passwordStr
                           complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;

/*
 * 通话记录和通讯录授权
 */
+ (void)submitCreditcardContactsList:(NSDictionary *)contactList
                            complete:(void (^) (HXSErrorCode code, NSString *message, NSDictionary *dict))block;

/*
 * 添加紧急联系人信息
 */
+ (void)submitContactInfo:(HXSContactInfoEntity *)contactInfoEntity
                 complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *contactInfo))block;
@end
