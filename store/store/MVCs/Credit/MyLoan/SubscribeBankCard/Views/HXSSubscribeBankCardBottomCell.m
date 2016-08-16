//
//  HXSSubscribeBankCardBottomCell.m
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeBankCardBottomCell.h"

@implementation HXSSubscribeBankCardBottomCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.agreementBtn setImage:[UIImage imageNamed:@"btn_choose_empty"] forState:UIControlStateNormal];
    [self.agreementBtn setImage:[UIImage imageNamed:@"btn_choose_blue"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
