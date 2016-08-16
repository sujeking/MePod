//
//  HXSInstallmentDetailModel.h
//  store
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSDownpaymentEntity.h"
#import "HXSInstallmentEntity.h"
@interface HXSInstallmentDetailModel : NSObject

/*
 * 获取首付比例列表
 */
- (void)fetchDownpaymentListWithPrice:(NSNumber *)price
                             Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *downpaymentEntityList))block;

/*
 * 获取分期列表
 */
- (void)fetchInstallmentInfoWithPrice:(NSNumber *)price
                              percent:(NSNumber *)percent
                             complete:(void (^)(HXSErrorCode code, NSString *message, HXSInstallmentEntity *installmentEntity))block;
@end
