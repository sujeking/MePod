//
//  HXSSubscribeVaildNumCell.m
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeVaildNumCell.h"

#import "UIImage+Extension.h"

@interface HXSSubscribeVaildNumCell()

@end

@implementation HXSSubscribeVaildNumCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark - create

+ (instancetype)createSubscribeVaildNumCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSSubscribeVaildNumCell class])
                                         owner:nil options:nil].firstObject;
}


@end
