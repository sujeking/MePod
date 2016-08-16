//
//  HXSSubscribeSelectCell.m
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeSelectCell.h"

@implementation HXSSubscribeSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - create

+ (instancetype)createSubscribeSelectCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSSubscribeSelectCell class])
                                         owner:nil options:nil].firstObject;
}

@end
