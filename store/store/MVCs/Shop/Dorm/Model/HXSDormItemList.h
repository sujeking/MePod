//
//  HXSDormItemList.h
//  store
//
//  Created by chsasaw on 15/2/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSItemListBase.h"

@class HXSDormCategory;

@interface HXSDormItemList : HXSItemListBase

@property (nonatomic, strong) NSMutableArray * itemCategoryList;
/**商品数据*/
@property (nonatomic, strong) NSMutableArray * itemList;

/**
 *  根据shop id 获取全部商品列表
 *
 *  @param shopIDNum shopID
 */
- (void)updateAllEntryInfo:(NSNumber *)shopIDNum;


/**
 *  根据分类id 查询分类商品
 *
 *  @param categoryId   分类id
 *  @param shopId       店铺id
 *  @param page         起始页
 *  @param num_per_page 每页数量
 */
- (void)fetchCategoryitemsWith:(NSNumber *)categoryId
                        shopId:(NSNumber *)shopId
                  categoryType:(NSNumber *)type
                      starPage:(NSNumber *)page
                    isLoadMore:(BOOL)loadMore
                    numPerPage:(NSNumber *)num_per_page;


- (int)visibleToAct:(int)visibleIndex;
- (int)actToVisible:(int)actIndex;

@end