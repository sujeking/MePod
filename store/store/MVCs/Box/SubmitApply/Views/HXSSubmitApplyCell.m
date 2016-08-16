//
//  HXSSubmitApplyCell.m
//  store
//
//  Created by 格格 on 16/6/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSSubmitApplyCell.h"

@implementation HXSSubmitApplyCell

+ (instancetype)submitApplyCell{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSSubmitApplyCell class])
                                                                         owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
