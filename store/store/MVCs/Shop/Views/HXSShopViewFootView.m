//
//  HXSShopViewFootView.m
//  store
//
//  Created by 格格 on 16/4/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopViewFootView.h"

@implementation HXSShopViewFootView

+ (id)footerView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.openShopButton.layer.cornerRadius = 4;
    self.openShopButton.layer.masksToBounds = YES;
    self.openShopButton.layer.borderWidth = 0.5f;
    self.openShopButton.layer.borderColor = [[UIColor colorWithWhite:0.600 alpha:1.000] CGColor];
}

@end
