//
//  HXSMediator+HXSBoxModule.m
//  store
//
//  Created by ArthurWang on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator+HXSBoxModule.h"

static NSString *kHXSMediatorTargetBox   = @"box";
static NSString *kHXSMediatorActionMybox = @"mybox";

@implementation HXSMediator (HXSBoxModule)

- (UIViewController *)HXSMediator_myBoxViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetBox
                                                    action:kHXSMediatorActionMybox
                                                    params:nil];
    
    return viewController;
}

@end
