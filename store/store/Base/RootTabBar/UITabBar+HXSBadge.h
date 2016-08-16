//
//  UITabBar+HXSBadge.h
//  store
//
//  Created by  黎明 on 16/8/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/************************************************************
 *  UITabBar 上的小红点
 *
 *  使用:在ViewController中 
 *
 *  [self.tabBarController.tabBar showBadgeOnItemIndex:self.tabBarController.selectedIndex];
 *
 *  [self.tabBarController.tabBar hiddenBadageOnItemIndex:self.tabBarController.selectedIndex];
 ***********************************************************/
#import <UIKit/UIKit.h>

@interface UITabBar (HXSBadge)

- (void)showBadgeOnItemIndex:(NSInteger)index;

- (void)hiddenBadageOnItemIndex:(NSInteger)index;
@end
