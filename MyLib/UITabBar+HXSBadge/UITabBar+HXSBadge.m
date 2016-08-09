//
//  UITabBar+HXSBadge.m
//  store
//
//  Created by  黎明 on 16/8/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "UITabBar+HXSBadge.h"

@implementation UITabBar (HXSBadge)

- (void)showBadgeOnItemIndex:(NSInteger)index
{
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = 59;
    badgeView.layer.backgroundColor = [[UIColor redColor] CGColor];
    badgeView.layer.cornerRadius = 3;
    badgeView.layer.masksToBounds = YES;
    
    CGRect tabFrame = self.frame;
    float percentX = (index +0.6) / self.items.count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 6, 6);
    [self addSubview:badgeView];
}

- (void)hiddenBadageOnItemIndex:(NSInteger)index
{
    for (UIView *view in self.subviews)
    {
        if (view.tag == 59)
        {
            [UIView animateWithDuration:.5 animations:^{
                
                view.alpha = 0;
            } completion:^(BOOL finished) {
                
                [view removeFromSuperview];
            }];
        }
    }
}

@end
