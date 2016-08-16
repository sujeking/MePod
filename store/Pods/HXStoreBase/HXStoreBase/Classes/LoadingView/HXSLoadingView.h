//
//  HXSLoadingView.h
//  store
//
//  Created by ArthurWang on 15/8/10.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HXSLoadingView : UIView

+ (void)showLoadingInView:(UIView *)view;

+ (void)showLoadFailInView:(UIView *)view block:(void (^)(void))block;


+ (void)closeInView:(UIView *)view;

+ (void)closeInView:(UIView *)view after:(NSTimeInterval)time;

+ (BOOL)isShowingLoadingViewInView:(UIView *)view;

@end
