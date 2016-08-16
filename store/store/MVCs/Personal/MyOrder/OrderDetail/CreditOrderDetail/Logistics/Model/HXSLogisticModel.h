//
//  HXSLogisticModel.h
//  store
//
//  Created by 沈露萍 on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSLogisticEntity.h"

@interface HXSLogisticModel : NSObject

//物流信息
- (void)getLogisticWithOrderSn:(NSString *)oderSn
               MessageComplete:(void (^)(HXSErrorCode code, NSString *message, HXSLogisticEntity *logisticEntity))block;

@end
