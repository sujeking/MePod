//
//  HXSAmountTableViewCell.m
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAmountTableViewCell.h"

@implementation HXSAmountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setAmountNum:(NSNumber *)amountNum
{
    if (amountNum)
    {
        self.amountLabel.text = [@"¥" stringByAppendingFormat:@"%0.2f", amountNum.floatValue];
    }
    else
    {
        self.amountLabel.text = nil;
    }
}

@end
