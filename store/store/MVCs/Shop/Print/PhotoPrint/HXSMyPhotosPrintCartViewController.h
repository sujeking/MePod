//
//  HXSMyPhotosPrintCartViewController.h
//  store
//
//  Created by J006 on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSMyPrintOrderItem.h"

@interface HXSMyPhotosPrintCartViewController : HXSBaseViewController

/**
 *  初始化
 *
 *  @param printOrderItemArray 相册选取图片
 *  @param shopEntity 店铺
 */
+ (instancetype)createMyPhotosPrintCartViewControllerWithPrintOrderItemArray:(NSMutableArray<HXSMyPrintOrderItem *> *)printOrderItemArray
                                                               andShopEntity:(HXSShopEntity *)shopEntity;


@end
