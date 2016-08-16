//
//  HXSCategoryRequest.h
//  store
//
//  Created by  黎明 on 16/3/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCategoryModel.h"

@class HXSCategoryModel;
@interface HXSCategoryRequest : NSObject

/**
 *  店铺分类列表
 *
 *  @param shopId   店铺id
 *  @param shopType //0夜猫店 1饮品店 2打印店
 *  @param block
 */
+ (void)getCategoryListWith:(NSNumber *)shopId
                   shopType:(NSNumber *)shopType
                   complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *slideArr))block;



@end
