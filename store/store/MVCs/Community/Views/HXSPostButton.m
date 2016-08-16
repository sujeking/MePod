//
//  HXSPostButton.m
//  store
//
//  Created by  黎明 on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPostButton.h"

//按钮宽、高
CGFloat const BtnWith = 55;
CGFloat const BtnHeight = 55;

CGFloat const RightMargin = 20;
CGFloat const ShowBottomMargin = 70;
CGFloat const HiddenButtomMargin = 150;


@implementation HXSPostButton

- (instancetype)init
{
    if (self = [super init]) {
        [self setButtonFrameAndStyle];
    }
    return self;
}

- (void)setButtonFrameAndStyle
{
    self.frame = CGRectMake(0, 0, BtnWith, BtnHeight);
    self.backgroundColor = [UIColor colorWithRed:1.000 green:0.757 blue:0.027 alpha:1.000];
    [self setImage:[UIImage imageNamed:@"ic_release"] forState:UIControlStateNormal];
    self.layer.cornerRadius = BtnWith / 2;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.3;
    
    [self addTarget:self action:@selector(onclickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onclickAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(postButtonClickAction)]) {
        [self.delegate performSelector:@selector(postButtonClickAction)];
    }
}



@end
