//
//  HXSFloatingCartEntity.m
//  store
//
//  Created by ArthurWang on 15/11/26.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSFloatingCartEntity.h"

#import "HXSDormCartItem.h"
#import "HXSStoreCartItemEntity.h"
#import "HXSBoxOrderModel.h"

@implementation HXSFloatingCartEntity

#pragma mark - Public Methods

- (instancetype)initWithCartItem:(HXSDormCartItem *)cartItem
{
    self = [super init];
    if (self) {
        self.amountNum        = cartItem.amount;
        self.dormentryIDNum   = cartItem.dormentryId;
        self.errorInfoStr     = cartItem.error_info;
        self.imageBigStr      = cartItem.imageBig;
        self.imageMediumStr   = cartItem.imageMedium;
        self.imageSmallStr    = cartItem.imageSmall;
        self.itemIDNum        = cartItem.itemId;
        self.nameStr          = cartItem.name;
        self.ownerUserIDNum   = cartItem.ownerUserId;
        self.priceNum         = cartItem.price;
        self.quantityNum      = cartItem.quantity;
        self.ridNum           = cartItem.rid;
        self.sessionNumberNum = cartItem.sessionNumber;
        self.orderNum         = cartItem.order;
    }
    return self;
}

- (instancetype)initWithStoreCartItem:(HXSStoreCartItemEntity *)storeCartItem {
    if (self = [super init]) {
        self.amountNum        = storeCartItem.amountNum;
        self.imageMediumStr   = storeCartItem.imageUrlStr;
        self.itemIDNum        = storeCartItem.itemIdNum;
        self.nameStr          = storeCartItem.nameStr;
        self.priceNum         = storeCartItem.priceNum;
        self.quantityNum      = storeCartItem.quantityNum;
    }
    return self;
}

- (instancetype)initWithBoxItem:(HXSBoxOrderItemModel *)boxItemModel
{
    if (self = [super init])
    {
        self.amountNum        = boxItemModel.amountDoubleNum;
        self.imageMediumStr   = boxItemModel.imageMediumStr;
        self.itemIDNum        = boxItemModel.itemIdNum;
        self.nameStr          = boxItemModel.nameStr;
        self.priceNum         = boxItemModel.priceDoubleNum;
        self.quantityNum      = boxItemModel.quantityNum;
        self.productIDStr     = boxItemModel.productIdStr;
        self.stockNum         = boxItemModel.stockNum;
    }
    
    return self;
}


@end
