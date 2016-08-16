//
//  HXSDigitalMobileCommentModel.h
//  store
//
//  Created by ArthurWang on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSDigitalMobileDetailEntity.h"

@interface HXSDigitalMobileCommentModel : NSObject

/**
 *  分期购商品评价列表
 *
 *  @param itemIDIntNum     组合商品id
 *  @param pageIntNum       分页页数
 *  @param numPerPageIntNum 每页个数
 *  @param block            返回结果
 */
- (void)fetchCommtentListWithItemID:(NSNumber *)itemIDIntNum
                               page:(NSNumber *)pageIntNum
                         numPerPage:(NSNumber *)numPerPageIntNum
                          completed:(void (^)(HXSErrorCode status, NSString *message, NSArray *commentsArr))block;

@end
