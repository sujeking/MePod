//
//  HXSEmergencyInputCell.m
//  59dorm
//
//  Created by J006 on 16/7/13.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSEmergencyInputCell.h"

@implementation HXSEmergencyInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)createEmergencyInputCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSEmergencyInputCell class])
                                         owner:nil options:nil].firstObject;
}

@end
