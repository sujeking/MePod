//
//  HXSMessageTableViewCell.m
//  store
//
//  Created by ArthurWang on 15/7/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSMessageTableViewCell.h"

@implementation HXSMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code

    _messageContentLabel.preferredMaxLayoutWidth = self.contentView.width;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor colorWithRGBHex:0xF3FCFF];
    
    self.selectedBackgroundView = selectedBackgroundView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectedBackgroundView.frame = CGRectMake(0, 0.0, self.width, self.height - 0.5);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _messageTitileLabel.text = @"";
    _messageTimeLabel.text = @"";
    _messageContentLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithRGBHex:0xF3FCFF];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
