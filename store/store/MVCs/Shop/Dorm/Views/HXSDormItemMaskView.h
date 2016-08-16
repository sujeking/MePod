//
//  HXSDormItemMaskView.h
//  store
//
//  Created by ranliang on 15/4/30.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSDormItemView.h"

@class HXSDormItem;
@class HXSShopEntity;
@class HXSBoxOrderItemModel;

@interface HXSDormItemMaskDatasource : NSObject

@property (nonatomic, strong) UIImage            *image;
@property (nonatomic, assign) CGRect             initialImageFrame;

@property (nonatomic, strong) HXSDormItem        *item;
@property (nonatomic, strong) HXSShopEntity      *shopEntity;
@property (nonatomic, strong) HXSBoxOrderItemModel *boxItemModel;


+ (HXSDormItemMaskDatasource *)initMaskDataSourceWithCurrentImageView:(UIImageView *)imageView
                                                            shopModel:(id)shopModel
                                                            itemModel:(id)itemModel;

@end


/**
 此类是一个覆盖全屏的商品详情展示View，需要add到UIWindow或者最外层的视图控制器的view上(比如self.navigationController.view)，以获得全屏效果
 */
@interface HXSDormItemMaskView : UIView

/**
 *  初始化方法
 *
 *  @param image 用来做动画的Image
 *  @param frame 用来做动画的Image在动画开始之前相对于整个屏幕的frame
 *  @param item  显示的item
 */
- (instancetype)initWithDataSource:(HXSDormItemMaskDatasource *)dataSource
                     delegate:(id<HXSFoodieItemPopViewDelegate>)delegate;

/**
 *  调用这个方法让视图以动画的方式呈现
 */
- (void)show;

@end
