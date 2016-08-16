//
//  HXSDigitalMobileSpecificationModel.h
//  store
//
//  Created by ArthurWang on 16/3/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSDigitalMobileSpecificationEntity.h"

@interface HXSDigitalMobileSpecificationModel : NSObject

- (void)fetchItemParamWithItemID:(NSNumber *)itemIDIntNum
                        complete:(void (^)(HXSErrorCode status, NSString *message, HXSDigitalMobileSpecificationEntity *entity))block;

@end
