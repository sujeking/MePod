//
//  UIScrollView+SuRefresh.h
//  masony
//
//  Created by  黎明 on 16/5/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "CustomView.h"
@interface UIScrollView (SuRefresh)

@property (nonatomic, strong) CustomView *topShowView;

- (void)addPullRefreshBlock:(void (^)())callback;
- (void)beginRefresh;
- (void)endRefresh;
@end
