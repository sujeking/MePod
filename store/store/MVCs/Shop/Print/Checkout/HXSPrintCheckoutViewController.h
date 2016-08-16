//
//  HXSPrintCheckoutViewController.h
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSShopEntity.h"

@class HXSPrintCartEntity;

@interface HXSPrintCheckoutViewController : HXSBaseViewController

@property (nonatomic, copy) void (^clearPrintStoreCart)();

- (void)initPrintCheckoutViewControllerWithEntity:(HXSPrintCartEntity *)entity
                                andWithShopEntity:(HXSShopEntity *)shopEntity;

@end
