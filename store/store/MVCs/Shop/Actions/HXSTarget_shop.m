//
//  HXSTarget_shop.m
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_shop.h"

// Controllers
/** 跳转店铺列表页 */
#import "HXSShopListViewController.h"
/** 跳转店铺详情页 */
#import "HXSDormMainViewController.h"
#import "HXSPrintMainViewController.h"

@implementation HXSTarget_shop

/** 跳转店铺列表页 */
// hxstore://shop/list?shop_type=xx&shop_type_name=xxxx
- (UIViewController *)Action_list:(NSDictionary *)paramsDic
{
    NSString *typeStr    = [paramsDic objectForKey:@"shop_type"];
    NSNumber *typeIntNum = [NSNumber numberWithInteger:[typeStr integerValue]];
    NSString *nameStr    = [paramsDic objectForKey:@"shop_type_name"];
    
    HXSShopListViewController *shopListVC = [HXSShopListViewController createDromVCWithType:typeIntNum name:[nameStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return shopListVC;
}

/** 跳转店铺详情页 */
// hxstore://shop/detail?shop_id=xxx&shop_type=xx
- (UIViewController *)Action_detail:(NSDictionary *)paramsDic
{
    NSString *typeStr      = [paramsDic objectForKey:@"shop_type"];
    NSNumber *typeIntNum   = [NSNumber numberWithInteger:[typeStr integerValue]];

    NSString *shopIDStr    = [paramsDic objectForKey:@"shop_id"];
    NSNumber *shopIDIntNum = [NSNumber numberWithInteger:[shopIDStr integerValue]];
    
    UIViewController *viewController;
    
    switch ([typeIntNum integerValue]) {
        case kHXSShopTypeDorm:
        {
            viewController = [HXSDormMainViewController createDromVCWithShopId:shopIDIntNum];
        }
            break;
            
        case kHXSShopTypeDrink:
        {
            // Do nothing
        }
            break;
            
        case kHXSShopTypePrint:
        {
            viewController = [HXSPrintMainViewController createPrintVCWithShopId:shopIDIntNum];
        }
            break;
            
        case kHXSShopTypeStore:
        {
            // Do nothing
        }
            break;
            
        default:
            break;
    }
    
    return viewController;
}

@end
