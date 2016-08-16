//
//  HXSaaaa.m
//  store
//
//  Created by  黎明 on 16/6/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSnacksCarView.h"
#import "HXSBoxOrderModel.h"
#import "HXSBoxCarManager.h"


static NSString * const RMB = @"￥";

@implementation HXSnacksCarView
- (void)awakeFromNib
{
    [self initSubViews];
}

- (void)initSubViews
{
    self.amountLabel.layer.cornerRadius = CGRectGetWidth(self.amountLabel.bounds)/2;
    self.amountLabel.layer.masksToBounds = YES;

    self.checkButton.backgroundColor = [UIColor colorWithRed:0.976 green:0.647 blue:0.008 alpha:1.000];
    [self.carButton addTarget:self action:@selector(carButtonClickAction)
             forControlEvents:UIControlEventTouchUpInside];
}


- (void)setBoxCarManager:(HXSBoxCarManager *)boxCarManager
{
    _amountLabel.text = boxCarManager.totalCount.stringValue;
    _fullPriceLabel.text = [NSString stringWithFormat:@"%@%.2f",RMB,boxCarManager.totalPrice.floatValue];
}

/**
 *  购物车点击
 */
- (void)carButtonClickAction
{
    if(self.carButtonClickBlock)
    {
        self.carButtonClickBlock();
    }
}

/**
 *  结算按钮点击
 */
- (IBAction)checkButtonClickAction:(id)sender
{
    if(self.checkButtonClickBlock)
    {
        self.checkButtonClickBlock();
    }
}

@end
