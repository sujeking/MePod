//
//  HXSPrintSettingViewModel.h
//  store
//
//  Created by J006 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSPrintTotalSettingEntity.h"

@interface HXSPrintSettingViewModel : NSObject

/**
 *  获取文档打印样式、缩印样式设置
 *
 *  @param shopID
 *  @param block
 *  @param failureBlock
 */
- (void)fetchPrintSettingWithShopId:(NSNumber *)shopID
                           Complete:(void (^)(HXSErrorCode status, NSString *message, HXSPrintTotalSettingEntity *entity))block
                            failure:(void(^)(NSString *errorMessage))failureBlock;

/**
 *  获取照片打印样式、缩印样式设置
 *
 *  @param shopID
 *  @param block
 *  @param failureBlock
 */
- (void)fetchPhotoPrintSettingWithShopId:(NSNumber *)shopID
                                Complete:(void (^)(HXSErrorCode status, NSString *message, HXSPrintTotalSettingEntity *entity))block;

@end

