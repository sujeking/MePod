//
//  HXSDormItemsRequest.h
//  store
//
//  Created by chsasaw on 15/2/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDormItemsRequest : NSObject

- (void)getDormItemListWithToken:(NSString *)token
                          shopId:(NSNumber *)shopIDIntNum
                        complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * items))block;

/**
 *  夜猫店商品列表(包括分类)
 *
 *  @param categoryId   分类id
 *  @param page         分页 起始页为1
 *  @param num_per_page 每页的个数
 *  @param block
 */
- (void)fetchGoodsCategoryListWith:(NSNumber *)categoryId
                            shopId:(NSNumber *)shopId
                      categoryType:(NSNumber *)type
                          starPage:(NSNumber *)page
                        numPerPage:(NSNumber *)num_per_page
                          complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *slideArr))block;

- (void)cancel;

@end
