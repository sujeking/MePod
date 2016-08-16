//
//  HXSBoxCarManager.h
//  store
//
//  Created by  黎明 on 16/6/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HXSBoxOrderItemModel;
/**
 *  零食盒购物车管理 增加、减少
 */
@interface HXSBoxCarManager : NSObject

+ (HXSBoxCarManager *)sharedManager;

/**
 *  清空购物车
 */
- (void)emptyCart;

/**
 *  更新购物车(增/删)
 *
 *  @param goodItem 对应商品
 */
- (void)updateCartWithItem:(HXSBoxOrderItemModel *)goodItem;

/**
 *  获取购物车中所有物品
 */
- (NSMutableArray *)getBoxAllItems;

/**
 *  获取总金额
 */
- (NSNumber *)totalPrice;

/**
 *  判断是否为空
 *
 */
- (BOOL)isEmpty ;

/**
 *  通过storeGoodsItem的模型获取购物车存放的HXSStoreCartItemEntity
 *
 */
- (HXSBoxOrderItemModel *)getCartItemWithStoreGoodItem:(HXSBoxOrderItemModel *)storeGoodsItem;

/**
 *  获取商品总数
 *
 */
- (NSNumber *)totalCount;

@end
