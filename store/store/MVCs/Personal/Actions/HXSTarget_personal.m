//
//  HXSTarget_personal.m
//  store
//
//  Created by ArthurWang on 16/6/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_personal.h"

// Controllers
#import "HXSMyOrdersViewController.h"
#import "HXSCouponViewController.h"
#import "HXSForgetPasswdVerifyController.h"
#import "HXSAddressBookViewController.h"

#import "AppDelegate.h"

@implementation HXSTarget_personal

/** 跳转订单列表页面 */
- (UIViewController *)Action_orderList:(NSDictionary *)paramsDic
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HXSMyOrdersViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"HXSMyOrdersViewController"];
    
    return controller;
}

/** 跳转优惠券页面 */
- (UIViewController *)Action_coupon:(NSDictionary *)paramsDic
{
    HXSCouponViewController * couponViewController = [HXSCouponViewController controllerFromXib];
    couponViewController.isFromPersonalCenter = YES;
    couponViewController.couponScope = kHXSCouponScopeNone;
    
    return couponViewController;
}

/** 跳转忘记密码页面 */
- (UIViewController *)Action_forgotPassword:(NSDictionary *)paramsDic
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo"
                                                         bundle:[NSBundle mainBundle]];
    HXSForgetPasswdVerifyController *passwdVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSForgetPasswdVerifyController"];
    
    return passwdVC;
}

/** 跳转地址薄页面 */
// messageBody=xxxx
- (UIViewController *)Action_addressBook:(NSDictionary *)paramsDic
{
    NSString *messageBodyStr = [paramsDic objectForKey:@"messageBody"];
    
    HXSAddressBookViewController *controller = [[HXSAddressBookViewController alloc] initWithNibName:@"HXSAddressBookViewController" bundle:nil];
    controller.messageBody = messageBodyStr;
    
    return controller;
}

/** 是否登录 */
- (NSNumber *)Action_isLoggedin:(NSDictionary *)paramsDic
{
    BOOL result = [[AppDelegate sharedDelegate].rootViewController checkIsLoggedin];
    
    return [NSNumber numberWithBool:result];
}

/** 选中TabBar */
// index=xxxx
- (NSNumber *)Action_tabSelectedIndex:(NSDictionary *)paramsDic
{
    NSNumber *indexIntNum = [paramsDic objectForKey:@"index"];
    
    RootViewController *rootVC = [AppDelegate sharedDelegate].rootViewController;
    [rootVC setSelectedIndex:[indexIntNum integerValue]];
    
    return [NSNumber numberWithBool:YES];
}

@end
