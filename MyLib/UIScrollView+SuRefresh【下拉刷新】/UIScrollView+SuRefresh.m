//
//  UIScrollView+SuRefresh.m
//  masony
//
//  Created by  黎明 on 16/5/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIScrollView+SuRefresh.h"

@implementation UIScrollView (SuRefresh)

- (void)setTopShowView:(CustomView *)topShowView
{
    objc_setAssociatedObject(self, @"topShowView", topShowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CustomView *)topShowView
{
    return objc_getAssociatedObject(self, @"topShowView");
}


#pragma mark - 

- (void)addPullRefreshBlock:(void (^)())callback
{
    if(self.topShowView) {
        [self.topShowView removeFromSuperview];
    }
    self.topShowView = [[CustomView alloc]initWithFrame:CGRectMake(0, -85, SCREEN_WIDTH, 85)];
    self.topShowView.refreshingCallback = callback;
    self.topShowView.topRefreshStatus = REFRESH_STATUS_NORMAL;
    self.topShowView.parentScrollView =self;
    [self addSubview:self.topShowView];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        NSValue * point = (NSValue *)[change objectForKey:@"new"];
        CGPoint p = [point CGPointValue];
        [self.topShowView adjustStatusByTop:p.y];
    }
}

- (void)beginRefresh
{
    self.topShowView.topRefreshStatus = REFRESH_STATUS_REFRESHING;
}

- (void)endRefresh
{
    self.topShowView.topRefreshStatus = REFRESH_STATUS_NORMAL;
}
@end
