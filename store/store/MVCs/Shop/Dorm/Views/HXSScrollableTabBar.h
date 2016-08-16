//
//  HXSScrollableTabBar.h
//  store
//
//  Created by Chensi on 6/2/15.
//  Copyright (c) 2015 59store. All rights reserved.
//

#import <UIKit/UIKit.h>

// KEYs
static NSString * const kScrollBarTitle              = @"title";

@protocol HXSScrollableTabBarDelegate;

@interface HXSScrollableTabBar : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id<HXSScrollableTabBarDelegate> scrollableTabBarDelegate;

- (void)removeAllTabs;
- (void)setItems:(NSArray *)items animated:(BOOL)animated width:(CGFloat)maxWidth;

- (NSInteger)selectedIndex;
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

@end

@protocol HXSScrollableTabBarDelegate <NSObject>
- (void)scrollableTabBar:(HXSScrollableTabBar *)tabBar didSelectItemWithIndex:(int)index;
@end
