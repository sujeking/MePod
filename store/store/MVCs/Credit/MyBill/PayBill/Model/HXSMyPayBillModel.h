//
//  HXSMyPayBillModel.h
//  store
//
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSMyPayBillListEntity.h"
#import "HXSMyPayBillDetailEntity.h"

@interface HXSMyPayBillModel : NSObject

+ (instancetype)sharedManager;

/**
 *  获取消费类账单列表
 *  @param block
 */
- (void)fetchMyPayBillListComplete:(void (^)(HXSErrorCode status, NSString *message, NSArray *billsArr))block
                           failure:(void(^)(NSString *errorMessage))failureBlock;
/**
 *  查看指定月份账单
 *  @param billTime
 *  @param block             
 */
- (void)fetchMyPayBillDetailWithBillID:(NSNumber *)billID
                                complete:(void (^)(HXSErrorCode status, NSString *message, HXSMyPayBillEntity *detailEntity))block
                               failure:(void(^)(NSString *errorMessage))failureBlock;

@end
