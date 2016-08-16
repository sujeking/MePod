//
//  HXSSubscribeInputTableViewCell.m
//  59dorm
//
//  Created by J006 on 16/7/8.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeInputTableViewCell.h"

@implementation HXSSubscribeInputTableViewCell

+ (instancetype)createSubscribeInputTableViewCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSSubscribeInputTableViewCell class])
                                         owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
