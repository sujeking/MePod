//
//  MBProgressHUD+HXS.h
//  59dorm
//
//  Created by ArthurWang on 15/9/7.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (HXS)

+ (instancetype)showDrawInViewWithoutIndicator:(UIView *)view
                                           status:(NSString *)text
                                       afterDelay:(NSTimeInterval)delay;

+ (instancetype)showInViewWithoutIndicator:(UIView *)view
                                       status:(NSString *)text
                                   afterDelay:(NSTimeInterval)delay;

+ (instancetype)showInView:(UIView *)view;

+ (instancetype)showInView:(UIView *)view
                       status:(NSString *)text;

+ (instancetype)showInViewWithoutIndicator:(UIView *)view
                                       status:(NSString *)text
                                   afterDelay:(NSTimeInterval)delay
                         andWithCompleteBlock:(void (^)())block;

+ (instancetype)showInView:(UIView *)view
                   customView:(UIView *)customView
                       status:(NSString *)text
                   afterDelay:(NSTimeInterval)delay;

+ (instancetype)showInView:(UIView *)view
                   customView:(UIView *)customView
                       status:(NSString *)text
                   afterDelay:(NSTimeInterval)delay
                completeBlock:(void (^)())block;

@end
