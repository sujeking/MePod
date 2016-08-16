//
//  HXSShopButton.m
//  store
//
//  Created by  黎明 on 16/7/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopButton.h"

@implementation HXSShopButton

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setupStyle];
    }
    return self;
}

- (void)setupStyle
{
    self.frame =CGRectMake(0, 0, 44, 21);
    [self setTitle:@"开店" forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self setTitleColor:[UIColor colorWithWhite:0.400 alpha:1.000] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:0.800 alpha:1.000] forState:UIControlStateHighlighted];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
}

@end
