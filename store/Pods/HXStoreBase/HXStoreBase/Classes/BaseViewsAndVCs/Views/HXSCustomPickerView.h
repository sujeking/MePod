//
//  HXSCustomPickerView.h
//  store
//
//  Created by chsasaw on 14/11/20.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HXSCustomPickerViewBlock)(int index, BOOL finished);

@interface HXSCustomPickerView : UIView

+ (void)showWithStringArray:(NSArray *)array defaultValue:(NSString *)defaultValue toolBarColor:(UIColor *)color completeBlock:(HXSCustomPickerViewBlock)block;

@end