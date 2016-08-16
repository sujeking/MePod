//
//  HXSBankModel.h
//  store
//
//  Created by 格格 on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSBankEntity.h"

@interface HXSBankModel : NSObject

/**
 *  获取银行列表
 *
 *  @param block
 */
+ (void)getBankList:(void(^)(HXSErrorCode code, NSString * message,NSArray *bankList))block;

@end
