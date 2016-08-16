//
//  DeliveryModel.h
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDeliveryModel : NSObject

// 获取配置信息
+(void)getDeliveriesWithShopId:(NSNumber *)shopId
                      complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *deliveries))block;

@end
