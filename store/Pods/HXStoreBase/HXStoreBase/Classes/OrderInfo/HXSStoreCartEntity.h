//
//  HXSStoreCartEntity.h
//  store
//
//  Created by BeyondChao on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

#import "HXSStoreCartItemEntity.h"

@interface HXSStoreCartEntity : HXBaseJSONModel
/** 配送费 */
@property (nonatomic, strong) NSNumber *deliveryAmountNum;
/** 商品价格 */
@property (nonatomic, strong) NSNumber *itemAmountNum; // //用户参加活动或者使用优惠券之后的价格
/** 商品总数 */
@property (nonatomic, strong) NSNumber *itemTotalNum;
/** 商品列表 */
@property (nonatomic, strong) NSArray<HXSStoreCartItemEntity> *itemsArray; // 放了 HXSStoreCartItemEntity 模型的 数组

+ (instancetype)cartEntityWithDictionary:(NSDictionary *)cartDict;

@end
