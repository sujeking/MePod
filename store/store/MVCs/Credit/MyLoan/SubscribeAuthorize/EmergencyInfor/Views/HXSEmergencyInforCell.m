//
//  HXSEmergencyInforCell.m
//  59dorm
//
//  Created by J006 on 16/7/13.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSEmergencyInforCell.h"

@implementation HXSEmergencyInforCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)createEmergencyInforCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSEmergencyInforCell class])
                                         owner:nil options:nil].firstObject;
}

@end
