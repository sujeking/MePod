//
//  UIRenderingButton.h
//  dorm
//
//  Created by hudezhi on 15/7/1.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Used to rendering border, corner in xib/storyboard
 */

IB_DESIGNABLE
@interface UIRenderingButton : UIButton

@property(nonatomic) IBInspectable UIColor *borderColor;
@property(nonatomic) IBInspectable UIColor *highlightedBorderColor;
@property(nonatomic) IBInspectable CGFloat  borderWidth;
@property(nonatomic) IBInspectable CGFloat  cornerRadius;
@property(nonatomic) IBInspectable UIColor *highlightedbackGroundColor;
@property(nonatomic) IBInspectable UIColor *highlightedTitleColor;

@end