//
//  HXSCreditCardLoanInfoModel.h
//  store
//
//  Created by ArthurWang on 16/7/22.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCreditCardLoanInfoModel : HXBaseJSONModel

/** 取现金额 */
@property (nonatomic, strong) NSNumber *intallmentAllDoubleNum;
/** 分期数 */
@property (nonatomic, strong) NSNumber *intallmentNumberIntNum;
/** 月供 */
@property (nonatomic, strong) NSNumber *intallmentAmountDoubleNum;
/** 手续费 */
@property (nonatomic, strong) NSNumber *intallmentFeeDoubleNum;
/** 原手续费 */
@property (nonatomic, strong) NSNumber *intallmentOriginalFeeDoubleNum;
/** 服务费 */
@property (nonatomic, strong) NSNumber *intallmentServiceFeeDoubleNum;

+ (NSArray *)createCreditCardLoanInfoEntityArrWithArr:(NSArray *)arr;

@end
