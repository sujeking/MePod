//
//  HXSBoxBalanceView.m
//  store
//
//  Created by  黎明 on 16/6/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxBalanceView.h"
#import "HXSBoxCarManager.h"
@interface HXSBoxBalanceView()

@property (weak, nonatomic) IBOutlet UIButton *balanceButton;
@property (weak, nonatomic) IBOutlet UILabel  *balancePriceLabel;

@end

@implementation HXSBoxBalanceView

- (void)awakeFromNib
{
    self.balanceButton.backgroundColor = [UIColor colorWithRed:0.976 green:0.647 blue:0.008 alpha:1.000];
    HXSBoxCarManager *boxCarManager = [HXSBoxCarManager sharedManager];
    self.balancePriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[boxCarManager.totalPrice floatValue]];
}

//立即支付按钮点击
- (IBAction)balanceButtonClickAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(createOrderAction)])
    {
        [self.delegate performSelector:@selector(createOrderAction) withObject:nil];
    }
}

@end
