//
//  HXSMediator+HXPersonalModule.m
//  Pods
//
//  Created by ArthurWang on 16/6/23.
//
//

#import "HXSMediator+HXPersonalModule.h"

static NSString *kHXSMediatorTargetPersonal  = @"personal";

static NSString *kHXSMediatorActionOrderList        = @"orderList";
static NSString *kHXSMediatorActionCoupon           = @"coupon";
static NSString *kHXSMediatorActionForgotPassword   = @"forgotPassword";
static NSString *kHXSMediatorActionAddressBook      = @"addressBook";
static NSString *kHXSMediatorActionIsLoggedin       = @"isLoggedin";
static NSString *kHXSMediatorActionTabSelectedIndex = @"tabSelectedIndex";

@implementation HXSMediator (HXPersonalModule)

- (UIViewController *)HXSMediator_orderListViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetPersonal
                                                    action:kHXSMediatorActionOrderList
                                                    params:nil];
    
    return viewController;
}

- (UIViewController *)HXSMediator_couponViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetPersonal
                                                    action:kHXSMediatorActionCoupon
                                                    params:nil];
    
    return viewController;
}

- (UIViewController *)HXSMediator_forgotPasswordViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetPersonal
                                                    action:kHXSMediatorActionForgotPassword
                                                    params:nil];
    
    return viewController;
}

- (UIViewController *)HXSMediator_addressBookViewController:(NSDictionary *)paramsDic
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetPersonal
                                                    action:kHXSMediatorActionAddressBook
                                                    params:paramsDic];
    
    return viewController;
}

- (NSNumber *)HXSMediator_isLoggedin
{
    NSNumber *resultBoolNum = [self performTarget:kHXSMediatorTargetPersonal
                                           action:kHXSMediatorActionIsLoggedin
                                           params:nil];
    
    return resultBoolNum;
}

- (NSNumber *)HXSMediator_selectedTabIndex:(NSDictionary *)paramsDic
{
    NSNumber *resultBoolNum = [self performTarget:kHXSMediatorTargetPersonal
                                           action:kHXSMediatorActionTabSelectedIndex
                                           params:paramsDic];
    
    return resultBoolNum;
}

@end
