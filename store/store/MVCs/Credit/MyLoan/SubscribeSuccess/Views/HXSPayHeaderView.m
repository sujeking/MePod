//
//  HXSPayHeaderView.m
//  store
//
//  Created by hudezhi on 15/7/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPayHeaderView.h"

@implementation HXSPayHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont systemFontOfSize:14.0];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
    self.textLabel.numberOfLines = 0;
    
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(17, 0, self.width - 34, self.height);
}


@end
