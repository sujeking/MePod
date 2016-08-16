//
//  HXSDigitalMobileScrollableTabBar.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

// KEYs

static NSString * const kScrollBarTitle              = @"title";
static NSString * const kScrollBarImageUrlSelected   = @"imageURLSelected";
static NSString * const kScrollBarImageUrlUnselected = @"imageURLUnselected";
static NSString * const kScrollBarCount              = @"count";

@class HXSDigitalMobileScrollableTabBar;

@protocol HXSDigitalMobileScrollableTabBarDelegate <NSObject>

- (void)scrollableTabBar:(HXSDigitalMobileScrollableTabBar *)tabBar didSelectItemWithIndex:(int)index;

@end

@interface HXSDigitalMobileScrollableTabBar : UIView

@property (nonatomic, assign) id<HXSDigitalMobileScrollableTabBarDelegate> scrollableTabBarDelegate;

- (void)removeAllTabs;
- (void)setItems:(NSArray *)items animated:(BOOL)animated width:(CGFloat)maxWidth;
- (void)setItems:(NSArray *)items animated:(BOOL)animated width:(CGFloat)maxWidth number:(NSInteger)number; // number default is 4

- (NSInteger)selectedIndex;
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

@end
