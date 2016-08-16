//
//  HXSCreditOrderModel.h
//  store
//
//  Created by ArthurWang on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSCreditOrderEntity.h"

@interface HXSCreditOrderModel : NSObject

/**
 *  订单列表
 *
 *  @param pageIntNum       【可选】页数，默认1
 *  @param numPerPageIntNum 【可选】每页多少个，默认比如20，服务端决定
 *  @param typeIntNum       【可选】10：分期购订单 11：充值订单 99：全部订单
 *  @param block             返回的数据
 */
- (void)fetchCreditcardOrderListWithPage:(NSNumber *)pageIntNum
                              numPerPage:(NSNumber *)numPerPageIntNum
                                    type:(NSNumber *)typeIntNum
                                complete:(void (^)(HXSErrorCode status, NSString *message, HXSCreditOrderEntity *orderEntity))block;

@end
