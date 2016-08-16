//
//  HXSOrderItemCell.h
//  store
//
//  Created by ranliang on 15/5/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXSOrderItem;
@class HXSBoxOrderItemEntity;
@class HXSStoreCartItemEntity;
@class HXSBoxOrderItemModel;

@interface HXSOrderItemCell : UITableViewCell

- (void)configWithOrderItem:(HXSOrderItem *)item;
/**
 *  配置 满就送item
 *
 *  @param item
 */
- (void)configWithOrderRewardItem:(HXSOrderItem *)item;

@property (nonatomic, strong) HXSBoxOrderItemModel *boxItem;
@property (nonatomic, strong) HXSStoreCartItemEntity *storeItem; // 云超市

@end
