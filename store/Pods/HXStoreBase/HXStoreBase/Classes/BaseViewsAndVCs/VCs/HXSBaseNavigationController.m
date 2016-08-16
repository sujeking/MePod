//
//  HXSBaseNavigationController.m
//  store
//
//  Created by chsasaw on 14-10-15.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSBaseNavigationController.h"

#import "HXMacrosUtils.h"

@interface HXSBaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation HXSBaseNavigationController

#pragma mark - Controller Lifecycel

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate = self;
        self.interactivePopGestureRecognizer.delegate = self;
    }
    
    self.view.backgroundColor = HXS_VIEWCONTROLLER_BG_COLOR;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = (navigationController.viewControllers.count >= 2);
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] &&
        gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    }
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    viewController.hidesBottomBarWhenPushed = YES;
    
    if (![viewController isKindOfClass:NSClassFromString(@"HXSMessageCenterViewController")])
    {
        [super pushViewController:viewController animated:animated];
        
        return;
    }
    
    // HXSMessageCenterViewController don't new a instance any more
    BOOL hasExistedVC = NO;
    UIViewController *existedVC = nil;
    
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:[viewController class]]) {
            hasExistedVC = YES;
            existedVC = vc;
            
            break;
        }
    }
    
    if (hasExistedVC) {
        [self popToViewController:existedVC animated:YES];
    } else {
        [super pushViewController:viewController animated:animated];
    }
    
}


#pragma mark - UIViewController Overwirte Methods

-(BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)prefersStatusBarHidden
{
    return [self.topViewController prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return [self.topViewController disablesAutomaticKeyboardDismissal];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma  mark - Private Methods




@end
