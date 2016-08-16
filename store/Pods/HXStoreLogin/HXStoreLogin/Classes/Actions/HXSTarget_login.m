//
//  HXSTarget_login.m
//  Pods
//
//  Created by ArthurWang on 16/6/28.
//
//

#import "HXSTarget_login.h"

@implementation HXSTarget_login

/** 登录导航栏 */
- (UINavigationController *)Action_loginNav:(NSDictionary *)paramsDic
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePathStr = [bundle pathForResource:@"HXStoreLogin" ofType:@"bundle"];
    if (0 < [bundlePathStr length]) {
        bundle = [NSBundle bundleWithPath:bundlePathStr];
    }
    
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Login" bundle:bundle] instantiateViewControllerWithIdentifier:@"HXSLoginViewControllerNavigation"];
    
    return nav;
}

@end
