//
//  HXSMediator+HXSElemeModule.m
//  store
//
//  Created by ArthurWang on 16/4/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator+HXSElemeModule.h"

static NSString *kHXSMediatorTargetEleme = @"eleme";
static NSString *kHXSMediatorActionHome  = @"home";

@implementation HXSMediator (HXSElemeModule)

- (UIViewController *)HXSMediator_elemeViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetEleme
                                                    action:kHXSMediatorActionHome
                                                    params:nil];
    
    return viewController;
}

@end
