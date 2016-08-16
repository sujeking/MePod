//
//  HXSEmptyTableBackgroundView.m
//  store
//
//  Created by hudezhi on 15/8/19.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSEmptyTableBackgroundView.h"

@interface HXSEmptyTableBackgroundView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation HXSEmptyTableBackgroundView

+ (instancetype)view
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (void)setTopPadding:(CGFloat)topPadding spacing:(CGFloat)spacing
{
    _topConstraint.constant = topPadding;
    _spacingConstraint.constant = spacing;
}

@end
