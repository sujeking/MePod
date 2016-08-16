//
//  HXSBillModel.h
//  store
//
//  Created by hudezhi on 15/8/17.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSAccountBillCategoryInfo.h"
#import "HXSBillRepaymentInfo.h"

@class HXSBillBorrowCashRecordItem;
@class HXSBillRepaymentSchedule;

@interface HXSBillModel : NSObject

// 获取用户账单分类信息
+ (void)getBillAccountInfo:(void (^)(HXSErrorCode code, NSString *message, HXSAccountBillCategoryInfo *billInfo))block;

// 获取取现记录列表
+ (void)getBorrowCashRecord:(void (^)(HXSErrorCode code, NSString *message, NSArray *list))block;

// 获取近期应还款
+ (void)getRepaymentRecord:(void (^)(HXSErrorCode code, NSString *message, HXSBillRepaymentInfo *info))block;

// 获取还款计划列表
+ (void)getRepaymentSchedule:(NSNumber *)installmentId
             installmentType:(NSNumber *)type
                  completion: (void (^)(HXSErrorCode code, NSString *message, HXSBillRepaymentSchedule *billRepaymentScheduleEntity))block;

// 获取花的账单 state: 0 - 未出账单, 1 - 待还款账单
+ (void)getBillPayList:(NSInteger)state
            completion: (void (^)(HXSErrorCode code, NSString *message, NSArray *list))completion;

// 历史账单列表
+ (void)getBillPayHistory:(void (^)(HXSErrorCode code, NSString *message, NSArray *list))completion;

+ (void)getBillPayHistoryDetail:(NSString *)billTime
                     completion: (void (^)(HXSErrorCode code, NSString *message, NSArray *list))completion;

@end
