//
//  HXSMediator+HXSShopActions.h
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator.h"

@interface HXSMediator (HXSShopActions)

- (UIViewController *)HXSMediator_shopListViewControllerWithParams:(NSDictionary *)params;

- (UIViewController *)HXSMediator_shopDetialViewControllerWithParams:(NSDictionary *)params;

@end
