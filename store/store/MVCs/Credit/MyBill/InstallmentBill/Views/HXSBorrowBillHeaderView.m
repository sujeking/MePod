//
//  HXSBorrowBillHeaderView.m
//  store
//
//  Created by hudezhi on 15/11/12.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowBillHeaderView.h"

@interface HXSBorrowBillHeaderView () {
    CAGradientLayer *_backGroundLayer;
    UILabel *_tipLabel;
    UILabel *_priceLabel;
}

- (void)setup;

@end


@implementation HXSBorrowBillHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    _backGroundLayer = [[CAGradientLayer alloc] init];
    _backGroundLayer.startPoint = CGPointMake(0.5, 0.0);
    _backGroundLayer.endPoint = CGPointMake(0.5, 1.0);
    _backGroundLayer.colors =  @[(id)[UIColor colorWithRGBHex:0x08A9FA].CGColor, (id)[UIColor colorWithRGBHex:0x08A9FA].CGColor, (id)[UIColor colorWithRGBHex:0x0082F3].CGColor];
    _backGroundLayer.locations = @[@0.0, @0.337, @1.0];
    [self.layer addSublayer:_backGroundLayer];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.text = @"近期应还款总额（元）";
    _tipLabel.font = [UIFont boldSystemFontOfSize:13.0];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tipLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor whiteColor];
    _priceLabel.font = [UIFont systemFontOfSize:45.0];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backGroundLayer.frame = self.bounds;
    _priceLabel.frame = CGRectMake(0, self.height - 25 - 40, self.width, 40);
    _tipLabel.frame = CGRectMake(0, _priceLabel.y - 35, self.width, 20);
}

#pragma mark - getter/setter

- (void)setPrice:(CGFloat)price
{
    _priceLabel.text = [NSString stringWithFormat:@"%0.2f", price];
}

@end
