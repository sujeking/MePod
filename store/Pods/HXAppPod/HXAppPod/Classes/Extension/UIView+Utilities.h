//
//  UIView+Utilities.h
//  store
//
//  Created by hudezhi on 15/11/5.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utilities)

- (void)shake;

+ (void)printView:(UIView*)view prefix: (NSString*)prefix;

+ (instancetype)viewFromNib;

@end
