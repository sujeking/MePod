//
//  HXSMediator+HXWebviewModule.m
//  Pods
//
//  Created by ArthurWang on 16/6/23.
//
//

#import "HXSMediator+HXWebviewModule.h"

static NSString *kHXSMediatorTargetWeb                   = @"web";

static NSString *kHXSMediatorActionPushWebViewController = @"PushWebViewController";

@implementation HXSMediator (HXWebviewModule)

- (UIViewController *)HXSMediator_webviewViewController:(NSDictionary *)paramsDic
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetWeb
                                                    action:kHXSMediatorActionPushWebViewController
                                                    params:paramsDic];
    
    return viewController;
}

@end
