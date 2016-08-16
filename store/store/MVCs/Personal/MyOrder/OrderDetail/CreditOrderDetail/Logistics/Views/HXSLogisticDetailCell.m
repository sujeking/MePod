//
//  HXSLogisticDetailCell.m
//  store
//
//  Created by 沈露萍 on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSLogisticDetailCell.h"

@implementation HXSLogisticDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    self.dotImageView.layer.cornerRadius = 10;
    self.dotImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
