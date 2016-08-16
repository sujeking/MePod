//
//  HXSUpgradeModel.h
//  store
//
//  Created by ArthurWang on 16/2/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSUpgradeAuthStatusEntity.h"

@interface HXSUpgradeModel : NSObject

/**
 *  提升信用额度授权状态
 *
 *  @param block 返回的结果
 */
- (void)fetchCreditCardAuthStatus:(void (^)(HXSErrorCode status, NSString *message, HXSUpgradeAuthStatusEntity *entity))block;

/**
 *  提升信用额度
 *
 *  @param block 返回的结果
 */
- (void)upgradeCreditCard:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *info))block;

@end
