//
//  HXSelectionControl.h
//  Test
//
//  Created by hudezhi on 15/7/18.
//  Copyright (c) 2015年 59store. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSelectionControlStyle : NSObject

@property(nonatomic) UIFont     *titleFont;         // default: HelveticaNeue-Medium 15
@property(nonatomic) UIColor    *titleColor;        // default: darkTextColor
@property(nonatomic) UIColor    *selectedColor;     // default: 0xFD5A00

+ (HXSelectionControlStyle*)defaultStyle;

@end


/*
 *
*/
@interface HXSelectionControl : UIControl

@property(nonatomic) HXSelectionControlStyle *style;    // default style, change if needed

@property(nonatomic) NSInteger selectedIdx;
@property(nonatomic) NSArray   *titles;
@property(nonatomic) BOOL showBottomSepratorLine;

@end
