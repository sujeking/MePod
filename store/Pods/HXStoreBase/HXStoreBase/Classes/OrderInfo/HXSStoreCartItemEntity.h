//
//  HXSStoreCartItemEntity.h
//  store
//
//  Created by BeyondChao on 16/4/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  购物车里面商品模型

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

@protocol HXSStoreCartItemEntity
@end

@interface HXSStoreCartItemEntity : HXBaseJSONModel

/** itemID */
@property (nonatomic, strong) NSNumber *itemIdNum;
/** 商品名称 */
@property (nonatomic, strong) NSString *nameStr;
/** 价格 */
@property (nonatomic, strong) NSNumber *priceNum;
/** 原价 */
@property (nonatomic, strong) NSNumber *originPriceNum;
/** 数量 */
@property (nonatomic, strong) NSNumber *quantityNum;
/** 图片地址 */
@property (nonatomic, copy) NSString *imageUrlStr;
/** 合计 */
@property (nonatomic, strong) NSNumber *amountNum; // (quantityNum * priceNun)

@property (nonatomic, strong) NSString *errorInfoStr;

@end
