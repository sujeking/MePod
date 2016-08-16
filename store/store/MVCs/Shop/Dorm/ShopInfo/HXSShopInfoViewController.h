//
//  HXSShopInfoViewController.h
//  store
//
//  Created by ArthurWang on 16/1/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSShopEntity;

@interface HXSShopInfoViewController : HXSBaseViewController

@property (nonatomic, strong) HXSShopEntity *shopEntity;
@property (nonatomic, strong) void (^(dismissShopInfoView))(void);

- (void)dismissView;

@end
