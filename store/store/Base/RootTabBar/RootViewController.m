//
//  RootViewController.m
//  store
//
//  Created by chsasaw on 14-10-14.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "RootViewController.h"
#import "HXSPersonalViewController.h"
#import "HXSLoginViewController.h"
#import "HXSCart.h"
#import "HXSSite.h"
#import "HXSLoginViewController.h"
#import "HXSShopViewController.h"
#import "HXSegmentControl.h"
#import "HXSMediator+HXLoginModule.h"
#import "HXSBase.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    int i = 1;
    for (UIViewController* vc in self.viewControllers) {
        
        vc.title = [NSString stringWithFormat:@"kkkk%d",i];
        UITabBarItem *item = vc.tabBarItem;
        UIImage* normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d_normal", i]];
        UIImage* selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d_selected", i]];
        
        item.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        NSShadow * shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor clearColor];
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: HXS_MAIN_COLOR,
                                       NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                       NSShadowAttributeName:shadow}
                            forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL,
                                       NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                       NSShadowAttributeName:shadow}
                            forState:UIControlStateNormal];
        
        ++i;
    }
    
    // 修改Tabbar上方分割线的颜色
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   RGB(225, 226, 227).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.selectedViewController beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.selectedViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.selectedViewController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.selectedViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Override Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger controllerIdx = [self.viewControllers indexOfObject:viewController];
    NSArray *tabTitle = @[@"首页", @"花不完", @"社区", @"我的"];
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_MAIN_TAB parameter:@{@"navigation": tabTitle[controllerIdx]}];
    
    if (controllerIdx == kHXSTabBarWallet) {
        [self setSelectedIndex:kHXSTabBarWallet];
    }
    
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.selectedIndex == [tabBar.items indexOfObject:item]) {
        HXSBaseNavigationController * nav = (HXSBaseNavigationController *)self.selectedViewController;
        HXSBaseViewController * viewController = (HXSBaseViewController *)nav.viewControllers[0];
        if([viewController respondsToSelector:@selector(tokenRefreshed)]) {
            [viewController tokenRefreshed];
        }
    }
}

#pragma mark - public method

- (BOOL)checkIsLoggedin
{
    if([HXSUserAccount currentAccount].isLogin) {
        return YES;
    }else {
        BEGIN_MAIN_THREAD
        UINavigationController *nav = [[HXSMediator sharedInstance] HXSMediator_loginNavigationController];
        [self presentViewController:nav animated:YES completion:nil];
        END_MAIN_THREAD
        
        return NO;
    }
}

- (UINavigationController *)currentNavigationController
{
    HXSBaseNavigationController *nav = self.viewControllers[self.selectedIndex];
    
    return nav;
}

@end
