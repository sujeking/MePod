//
//  HXSFloatingCartEntity.h
//  store
//
//  Created by ArthurWang on 15/11/26.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXSDormCartItem, HXSStoreCartItemEntity, HXSBoxOrderItemModel;

@interface HXSFloatingCartEntity : NSObject

@property (nonatomic, strong) NSNumber *amountNum;
@property (nonatomic, strong) NSNumber *dormentryIDNum;
@property (nonatomic, strong) NSString *errorInfoStr;
@property (nonatomic, strong) NSString *imageBigStr;
@property (nonatomic, strong) NSString *imageMediumStr;
@property (nonatomic, strong) NSString *imageSmallStr;
@property (nonatomic, strong) NSNumber *itemIDNum;
@property (nonatomic, strong) NSString *productIDStr;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSNumber *ownerUserIDNum;
@property (nonatomic, strong) NSNumber *priceNum;
@property (nonatomic, strong) NSNumber *quantityNum;
@property (nonatomic, strong) NSNumber *ridNum;
@property (nonatomic, strong) NSNumber *sessionNumberNum;
@property (nonatomic, strong) NSNumber *orderNum;
@property (nonatomic, strong) NSNumber *stockNum;//库存

- (instancetype)initWithCartItem:(HXSDormCartItem *)cartItem;

- (instancetype)initWithStoreCartItem:(HXSStoreCartItemEntity *)storeCartItem;

- (instancetype)initWithBoxItem:(HXSBoxOrderItemModel *)boxItemModel;

@end
