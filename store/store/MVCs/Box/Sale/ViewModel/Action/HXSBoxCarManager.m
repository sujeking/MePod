//
//  HXSBoxCarManager.m
//  store
//
//  Created by  黎明 on 16/6/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxCarManager.h"
#import "HXSBoxOrderModel.h"


@interface HXSBoxCarManager()

@property (nonatomic, strong) NSMutableArray *boxItems;

@end

@implementation HXSBoxCarManager

+ (HXSBoxCarManager *)sharedManager
{
    static HXSBoxCarManager *boxCarManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
    {
        boxCarManagerInstance = [[self alloc] init];
    });
    return boxCarManagerInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.boxItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)emptyCart
{
    for (HXSBoxOrderItemModel *item in self.boxItems)
    {
        item.quantityNum = @(0);
    }
    
    [self.boxItems removeAllObjects];
}


- (void)updateCartWithItem:(HXSBoxOrderItemModel *)goodItem
{
    for (HXSBoxOrderItemModel *itemModel in self.boxItems)
    {
        if ([goodItem.productIdStr isEqual:itemModel.productIdStr])
        {
            // 如果商品一样 则修改数量
            if ([goodItem.quantityNum integerValue] == 0)
            { //如果设置数量为0,则从购物车清除
                itemModel.quantityNum = goodItem.quantityNum;
                [self.boxItems removeObject:itemModel];
            }
            else
            { // 否则直接修改数量
                itemModel.quantityNum = goodItem.quantityNum;
            }
            double price = [itemModel.priceDoubleNum doubleValue];
            double totalPrice = [itemModel.quantityNum integerValue] * price;
            itemModel.amountDoubleNum = [NSNumber numberWithDouble:totalPrice];
            
            return;
        }
    }
    double price = [goodItem.priceDoubleNum doubleValue];
    double totalPrice = [goodItem.quantityNum integerValue] * price;
    goodItem.amountDoubleNum = [NSNumber numberWithDouble:totalPrice];
    // 否则 购物车增加该商品
    [self.boxItems addObject:goodItem];
}


- (NSMutableArray *)getBoxAllItems;
{
    return self.boxItems;
}

- (NSNumber *)totalPrice
{
    CGFloat price = 0.0;
    for (HXSBoxOrderItemModel *model in self.boxItems)
    {
        price += [model.quantityNum floatValue] * [model.priceDoubleNum floatValue];
    }
    return [NSNumber numberWithFloat:price];
}

- (BOOL)isEmpty
{
    return ([self.boxItems count] == 0);
}


- (HXSBoxOrderItemModel *)getCartItemWithStoreGoodItem:(HXSBoxOrderItemModel *)storeGoodsItem
{
    for (HXSBoxOrderItemModel *itemEntity in self.boxItems)
    {
        
        return itemEntity;
    }
    return nil;
}

- (NSNumber *)totalCount
{
    NSInteger countNum = 0;
    for (HXSBoxOrderItemModel *boxItemModel in self.boxItems)
    {
        countNum += boxItemModel.quantityNum.integerValue;
    }
    return @(countNum);
}
@end
