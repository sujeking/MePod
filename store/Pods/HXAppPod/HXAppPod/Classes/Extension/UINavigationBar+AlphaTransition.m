//
//  UINavigationBar+AlphaTransition.m
//  store
//
//  Created by hudezhi on 15/11/18.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "UINavigationBar+AlphaTransition.h"
#import <objc/runtime.h>

#import "HXMacrosUtils.h"
#import "Color+Image.h"

@implementation UINavigationBar (AlphaTransition)

static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)at_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.translucent = YES;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
    
    //[UIView printView:self prefix:@"-------"];
}

- (void)at_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
}

- (void)at_setTitleAlpha:(CGFloat)alpha
{    
    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [[UIColor whiteColor] colorWithAlphaComponent:alpha],
                                                                     NSForegroundColorAttributeName,
                                                                     [UIFont systemFontOfSize:17],
                                                                     NSFontAttributeName,
                                                                     nil]];
}

- (void)at_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [[UIImage alloc] init];
    self.translucent = YES;
    
    [self setBackgroundImage:[UIImage imageWithColor:HXS_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    [self setBarStyle:UIBarStyleDefault];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setBarTintColor:HXS_MAIN_COLOR];
    
    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [[UIColor whiteColor] colorWithAlphaComponent:1.0],
                                  NSForegroundColorAttributeName,
                                  [UIFont systemFontOfSize:17],
                                  NSFontAttributeName,
                                  nil]];
    
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
