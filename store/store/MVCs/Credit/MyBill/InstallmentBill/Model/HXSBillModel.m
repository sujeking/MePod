//
//  HXSBillModel.m
//  store
//
//  Created by hudezhi on 15/8/17.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBillModel.h"
#import "HXSBillBorrowCashRecordItem.h"
#import "HXSBillRepaymentSchedule.h"
#import "HXSBillPayHistoryItem.h"
#import "HXSBillPayItem.h"

@implementation HXSBillModel

+ (void)getBillAccountInfo:(void (^)(HXSErrorCode code, NSString *message, HXSAccountBillCategoryInfo *billInfo))block
{
    NSString *deviceToken = [HXSUserAccount currentAccount].strToken;
    NSDictionary *paramDic = @{SYNC_USER_TOKEN:deviceToken};
    
    [HXStoreWebService getRequest:HXS_ACCOUNT_BILL_INFO
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           HXSAccountBillCategoryInfo *categoryInfo = [[HXSAccountBillCategoryInfo alloc] initWithDictionary:data];
                           block(status, msg, categoryInfo);
                           
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

+ (void)getBorrowCashRecord:(void (^)(HXSErrorCode code, NSString *message, NSArray *list))block
{
    NSDictionary *paramDic = @{};
    
    [HXStoreWebService getRequest:HXS_BILL_BORROW_CASH_RECORD
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           NSArray *list = data[@"records"];
                           
                           if(list.count > 0) {
                               NSMutableArray *result = [NSMutableArray array];
                               for(NSDictionary *dic in list) {
                                   HXSBillBorrowCashRecordItem *item = [[HXSBillBorrowCashRecordItem alloc] initWithDictionary:dic];
                                   [result addObject:item];
                               }
                               
                               block(status, msg, result);
                           }
                           else {
                               block(status, msg, nil);
                           }
                           
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

// 获取近期应还款
+ (void)getRepaymentRecord:(void (^)(HXSErrorCode code, NSString *message, HXSBillRepaymentInfo *info))block
{
    NSDictionary *paramDic = @{};
    
    [HXStoreWebService getRequest:HXS_BILL_REPAYMENT_RECORD
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           HXSBillRepaymentInfo *info = [[HXSBillRepaymentInfo alloc] initWithDictionary:data];
                           block(status, msg, info);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

+ (void)getRepaymentSchedule:(NSNumber *)installmentId installmentType:(NSNumber *)type completion: (void (^)(HXSErrorCode code, NSString *message, HXSBillRepaymentSchedule *billRepaymentScheduleEntity))block
{
    
    NSDictionary *paramDic = @{
                                @"bill_id":[NSString stringWithFormat:@"%d",installmentId.intValue],
                                @"installment_type":[NSString stringWithFormat:@"%d",type.intValue],
                               @"installment_id":installmentId,
                               @"installment_type":type
                               };
    
    [HXStoreWebService getRequest:HXS_BILL_REPAYMENT_SCHEDULE
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           HXSBillRepaymentSchedule *billRepaymentScheduleEntity = [[HXSBillRepaymentSchedule alloc] initWithDictionary:data];
                           
                           block(status, msg, billRepaymentScheduleEntity);
                       }
                       else {
                           block(status, msg, nil);    
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

+ (void)getBillPayList:(NSInteger)state completion: (void (^)(HXSErrorCode code, NSString *message, NSArray *list))completion
{
    NSString *deviceToken = [HXSUserAccount currentAccount].strToken;
    
    NSDictionary *paramDic = @{SYNC_USER_TOKEN:deviceToken,
                               @"bill_status":@(state),
                               };
    
    [HXStoreWebService getRequest:HXS_BILL_PAY_LIST
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           NSArray *list = data[@"list"];
                           
                           NSMutableArray *result = [NSMutableArray array];
                           if(list.count > 0) {
                               for(NSDictionary *dic in list) {
                                   HXSBillPayItem *item = [[HXSBillPayItem alloc] initWithDictionary:dic];
                                   [result addObject:item];
                               }
                           }
                           completion(status, msg, result);
                           
                       } else {
                           completion(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       completion(status, msg, nil);
                   }];
}

+ (void)getBillPayHistory:(void (^)(HXSErrorCode code, NSString *message, NSArray *list))completion
{
    NSString *deviceToken = [HXSUserAccount currentAccount].strToken;
    
    NSDictionary *paramDic = @{SYNC_USER_TOKEN:deviceToken};
    
    [HXStoreWebService getRequest:HXS_BILL_PAY_HISTORY
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           NSArray *list = data[@"list"];
                           
                           if(list.count > 0) {
                               NSMutableArray *result = [NSMutableArray array];
                               for(NSDictionary *dic in list) {
                                   HXSBillPayHistoryItem *item = [[HXSBillPayHistoryItem alloc] initWithDictionary:dic];
                                   [result addObject:item];
                               }
                               
                               completion(status, msg, result);
                           }
                           else {
                               completion(status, msg, nil);
                           }
                       } else {
                           completion(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       completion(status, msg, nil);
                   }];
}

+ (void)getBillPayHistoryDetail:(NSString *)billTime completion: (void (^)(HXSErrorCode code, NSString *message, NSArray *list))completion
{
    NSString *deviceToken = [HXSUserAccount currentAccount].strToken;
    
    NSDictionary *paramDic = @{SYNC_USER_TOKEN:deviceToken,
                               @"bill_time":billTime,
                               };
    
    [HXStoreWebService getRequest:HXS_BILL_PAY_HISTORY_DETAIL
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           HXSBillPayItem *item = [[HXSBillPayItem alloc] initWithDictionary:data];
                           completion(status, msg, @[item]);
                       } else {
                           completion(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       completion(status, msg, nil);
                   }];
}

@end
