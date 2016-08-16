//
//  HXSCommissionModel.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCommissionEntity.h"

@interface HXSCommissionModel : NSObject

/**
 *  获取骑士佣金的明细表
 *
 *  @param page
 *  @param size
 *  @param block
 *
 *  @return
 */
+ (void)getKnightCommissionRewardsWithPage:(NSNumber *)page
                                           Size:(NSNumber *)size
                                       complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * commissions,NSNumber *allCommission))block;

@end
