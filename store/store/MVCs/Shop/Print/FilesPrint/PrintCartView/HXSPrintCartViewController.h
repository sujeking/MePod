//
//  HXSPrintCartViewController.h
//  store
//  文档打印购物车生成界面
//  Created by J006 on 16/3/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSShopEntity.h"
#import "HXSMyPrintOrderItem.h"

@interface HXSPrintCartViewController : HXSBaseViewController

- (void)initPrintCartViewWithShopEntity:(HXSShopEntity *)shopEntity
                       andWithCartArray:(NSMutableArray<HXSMyPrintOrderItem *> *)cartArray;


@end
