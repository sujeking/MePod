//
//  HXSMyPayBillInstallMentModel.h
//  store
//
//  Created by J006 on 16/3/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSMyPayBillInstallMentSelectEntity.h"
#import "HXSMyPayBillInstallMentEntity.h"

@interface HXSMyPayBillInstallMentModel : NSObject

+ (instancetype)sharedManager;

/**
 *  消费账单分期选择,下拉选择合适的月份返回的分期数和月供
 *
 *  @param installmentAmount 分期金额
 *  @param block
 *  @param failureBlock
 */
- (void)myPayBillInstallMentSelectWithInstallmentAmount:(NSNumber *)installmentAmount
                                               Complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *entityArray))block
                                   failure:(void(^)(NSString *errorMessage))failureBlock;
/**
 *  消费类账单分期确认
 *
 *  @param installmentAmount 分期金额
 *  @param installmentNumber 分期数
 *  @param billID            账单id
 *  @param block
 *  @param failureBlock
 */
- (void)confirmMyPayBillInstallmentWithInstallmentAmount:(NSNumber *)installmentAmount
                                andWithInstallmentNumber:(NSNumber *)installmentNumber
                                              withBillID:(NSNumber *)billID
                                                Complete:(void (^)(HXSErrorCode status, NSString *message, HXSMyPayBillInstallMentEntity *entity))block
                                    failure:(void(^)(NSString *errorMessage))failureBlock;

@end
