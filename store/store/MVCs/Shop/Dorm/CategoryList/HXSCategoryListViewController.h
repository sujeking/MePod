//
//  HXSCategoryListViewController.h
//  store
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
@class HXSCategoryModel;
@interface HXSCategoryListViewController : HXSBaseViewController

/**
 *  页面消失回调
 */
@property (nonatomic, copy) void (^dismissBlock)(NSInteger index,HXSCategoryModel *Model);

/**不选择分类 隐藏列表操作*/
@property (nonatomic, copy) void (^unSelectBlock)();
@property (nonatomic, strong) NSArray *categoryItems;

/**
 *  隐藏
 */
- (void)dismissView:(NSInteger)selectIndex;

@end
