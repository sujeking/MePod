//
//  HXSMediator+HXCreditModule.m
//  Pods
//
//  Created by ArthurWang on 16/6/23.
//
//

#import "HXSMediator+HXCreditModule.h"

static NSString *kHXSMediatorTargetCredit       = @"credit";

static NSString *kHXSMediatorActionCreditWallet = @"creditWallet";

@implementation HXSMediator (HXCreditModule)

- (UIViewController *)HXSMediator_creditWalletViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCredit
                                                    action:kHXSMediatorActionCreditWallet
                                                    params:nil];
    
    return viewController;
}

@end
