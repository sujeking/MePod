//
//  HXSBannerTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/1/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBannerTableViewCell.h"

@implementation HXSBannerTableViewCell

- (void)awakeFromNib
{
    self.bannerImageView.layer.masksToBounds = YES;
    self.bannerImageView.layer.cornerRadius = 3.0;
    self.bannerImageView.layer.borderWidth = 0.5;
    self.bannerImageView.layer.borderColor = [UIColor colorWithRGBHex:0xE1E2E3].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
