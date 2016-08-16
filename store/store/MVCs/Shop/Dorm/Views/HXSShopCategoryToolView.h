//
//  HXSShopCategoryToolView.h
//  store
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSShopEntity,HXSCategoryModel;
@interface HXSShopCategoryToolView : UIView

@property (nonatomic, copy) void (^selectCategoryType)(HXSCategoryModel *);

/**
 *  根据店铺获取分类菜单
 *
 *  @param shopModel
 */
- (void)getCategoryItemsWith:(HXSShopEntity *)shopModel
                    complete:(void (^)(HXSCategoryModel *))completeBlock;

- (void)dismissView;
@end