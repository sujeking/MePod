//
//  HXSCreditViewModel.h
//  store
//
//  Created by ArthurWang on 16/7/22.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSCreditCardLoanInfoModel.h"

@interface HXSCreditViewModel : NSObject

/**
 *  金额分期明细
 *
 *  @param block 返回结果
 */
- (void)fetchLoanInfo:(void (^)(HXSErrorCode status, NSString *message, NSArray *itemsArr))block;

@end
