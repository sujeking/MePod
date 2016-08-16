//
//  HXSTaskOrderTimeCell.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskTotalNumCell.h"

@interface HXSTaskTotalNumCell()

@property (nonatomic, weak) IBOutlet UILabel *numLabel;

@end

@implementation HXSTaskTotalNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTaskOrderDetial:(HXSTaskOrderDetial *)taskOrderDetial{
    _taskOrderDetial = taskOrderDetial;
    _numLabel.text = [NSString stringWithFormat:@"%d",taskOrderDetial.itemIntNum.intValue];
}

@end
