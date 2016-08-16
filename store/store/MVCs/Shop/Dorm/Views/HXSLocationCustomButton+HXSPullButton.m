//
//  HXSLocationCustomButton+HXSPullButton.m
//  store
//
//  Created by  黎明 on 16/8/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSLocationCustomButton+HXSPullButton.h"

@implementation HXSLocationCustomButton (HXSPullButton)

- (UIEdgeInsets)imageEdgeInsets
{
    return UIEdgeInsetsMake(0, CGRectGetMaxX(self.titleLabel.bounds) + 10, 0, 0);;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat iconWidthAndHeight = CGRectGetHeight(self.bounds) / 2;
    CGFloat margin = 5.0f;

    return CGRectMake(0, CGRectGetMinY(contentRect),
                      width - margin - iconWidthAndHeight,
                      CGRectGetHeight(contentRect));
}

@end
