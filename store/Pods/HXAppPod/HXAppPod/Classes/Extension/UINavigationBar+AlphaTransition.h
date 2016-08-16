//
//  UINavigationBar+AlphaTransition.h
//  store
//
//  Created by hudezhi on 15/11/18.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationBar (AlphaTransition)

- (void)at_setBackgroundColor:(UIColor *)backgroundColor;
- (void)at_setElementsAlpha:(CGFloat)alpha;
- (void)at_reset;
- (void)at_setTitleAlpha:(CGFloat)alpha;

@end
