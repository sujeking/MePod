//
//  HXSModifyBoxInfoCell.m
//  store
//
//  Created by 格格 on 16/7/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSModifyBoxInfoCell.h"

@implementation HXSModifyBoxInfoCell

+ (instancetype)modifyBoxInfoCell{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSModifyBoxInfoCell class])
                                                owner:nil options:nil].firstObject;

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
