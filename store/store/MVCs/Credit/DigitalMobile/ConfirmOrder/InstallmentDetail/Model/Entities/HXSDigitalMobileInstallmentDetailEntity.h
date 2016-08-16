//
//  HXSDigitalMobileInstallmentDetailEntity.h
//  store
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSDownpaymentEntity.h"
#import "HXSInstallmentEntity.h"

@interface HXSDigitalMobileInstallmentDetailEntity : NSObject

/** 分期额度 */
@property (nonatomic, strong) NSNumber *installmentLimit;
/** 本次购物 */
@property (nonatomic, strong) NSNumber *spend;
/** 首付比例 */
@property (nonatomic, strong) HXSDownpaymentEntity *downpayment;
/** 分期信息 */
@property (nonatomic, strong) HXSInstallmentItemEntity *installment;

- (NSNumber *)getDownPayment;

@end
