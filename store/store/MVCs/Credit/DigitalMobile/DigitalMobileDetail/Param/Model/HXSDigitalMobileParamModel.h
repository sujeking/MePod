//
//  HXSDigitalMobileParamModel.h
//  store
//
//  Created by ArthurWang on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSDigitalMobileParamEntity.h"

@interface HXSDigitalMobileParamModel : NSObject

/**
 *  子商品选购
 *
 *  @param itemIDIntNum 组合商品id
 *  @param block        返回的数据
 */
- (void)fetchItemAllSKUWithItemID:(NSNumber *)itemIDIntNum
                         complete:(void (^)(HXSErrorCode status, NSString *message, HXSDigitalMobileParamEntity *paramEntity))block;

@end
