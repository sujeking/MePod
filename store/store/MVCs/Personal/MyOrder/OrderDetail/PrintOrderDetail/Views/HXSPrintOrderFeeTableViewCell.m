//
//  HXSPrintOrderFeeTableViewCell.m
//  store
//
//  Created by 格格 on 16/4/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintOrderFeeTableViewCell.h"

@implementation HXSPrintOrderFeeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - Public Methods

// dic key:keyLabel  value:valueLabel
- (void)setupPrintOrderFeeCellWith:(NSDictionary *)dic
{
    self.keyLabel.text = [dic objectForKey:@"key"];
    self.valueLabel.text = [dic objectForKey:@"value"];
}

@end
