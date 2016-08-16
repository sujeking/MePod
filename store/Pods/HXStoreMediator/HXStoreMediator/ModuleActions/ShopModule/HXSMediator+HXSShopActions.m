//
//  HXSMediator+HXSShopActions.m
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator+HXSShopActions.h"

static NSString *kHXSMediatorTargetShop = @"shop";

static NSString *kHXSMediatorActionList                  = @"list";
static NSString *kHXSMediatorActionDetail                = @"detail";
static NSString *kHXSMediatorActionPushWebViewController = @"PushWebViewController";

@implementation HXSMediator (HXSShopActions)

- (UIViewController *)HXSMediator_shopListViewControllerWithParams:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetShop
                                                    action:kHXSMediatorActionList
                                                    params:params];
    
    return viewController;
}

- (UIViewController *)HXSMediator_shopDetialViewControllerWithParams:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetShop
                                                    action:kHXSMediatorActionDetail
                                                    params:params];
    
    return viewController;
}

@end
