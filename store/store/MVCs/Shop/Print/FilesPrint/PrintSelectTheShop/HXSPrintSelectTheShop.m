//
//  HXSPrintSelectTheShop.m
//  store
//
//  Created by J006 on 16/5/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintSelectTheShop.h"
#import "HXSLocationManager.h"
#import "HXSShopListViewController.h"

@interface HXSPrintSelectTheShop()

@end

@implementation HXSPrintSelectTheShop

- (void)selectTheShopEntityAndWithVC:(UIViewController *)viewController
                       andPrintBlock:(void (^)(HXSShopEntity *entity))printReturnBlock;
{
    [[HXSLocationManager manager]resetPosition:PositionBuilding andViewController:viewController completion:^{
        NSNumber *type = [NSNumber numberWithInteger:kHXSShopTypePrint];
        HXSShopListViewController *shopListVC = [HXSShopListViewController createDromVCWithType:type
                                                                                           name:@"云印店"
                                                                                  andPrintBlock:^(HXSShopEntity *entity)
        {
            if(entity) {
                printReturnBlock(entity);
            } else {
                printReturnBlock(nil);
            }
        }];
        HXSBaseNavigationController *nav = [[HXSBaseNavigationController alloc] initWithRootViewController:shopListVC];
        [viewController presentViewController:nav animated:YES completion:nil];
    }];
}

@end
