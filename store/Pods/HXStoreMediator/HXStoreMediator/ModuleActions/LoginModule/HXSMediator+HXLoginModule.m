//
//  HXSMediator+HXLoginModule.m
//  Pods
//
//  Created by ArthurWang on 16/6/28.
//
//

#import "HXSMediator+HXLoginModule.h"

static NSString *kHXSMediatorTargetLogin    = @"login";

static NSString *kHXSMediatorActionLoginNav = @"loginNav";

@implementation HXSMediator (HXLoginModule)

- (UINavigationController *)HXSMediator_loginNavigationController
{
    UINavigationController *nav = [self performTarget:kHXSMediatorTargetLogin
                                               action:kHXSMediatorActionLoginNav
                                               params:nil];
    
    return nav;
}

@end
