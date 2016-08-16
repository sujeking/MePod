//
//  HXSMediator+HXSCreditCardModule.m
//  store
//
//  Created by ArthurWang on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator+HXSCreditCardModule.h"

static NSString *kHXSMediatorTargetCreditCard = @"creditcard";
static NSString *kHXSMediatorActionTip        = @"tip";

@implementation HXSMediator (HXSCreditCardModule)

- (UIViewController *)HXSMediator_creditCardViewControllerWithParams:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCreditCard
                                                    action:kHXSMediatorActionTip
                                                    params:params];
    
    return viewController;
}

@end
