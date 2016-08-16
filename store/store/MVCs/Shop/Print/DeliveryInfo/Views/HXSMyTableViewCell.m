//
//  MyTableViewCell.m
//  LookingForCoal
//
//  Created by zhaomeiwang on 15/9/25.
//  Copyright © 2015年 JieMaoTong. All rights reserved.
//

#import "HXSMyTableViewCell.h"

@implementation HXSMyTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setTextLabelRect:(CGRect)textLabelRect
{
    _textLabelRect = textLabelRect;
    [self setNeedsDisplay];

}

- (void)setDetialTextLabelRect:(CGRect)detialTextLabelRect
{
    _detialTextLabelRect = detialTextLabelRect;
    [self setNeedsDisplay];
}

- (void)setImageViewRect:(CGRect)imageViewRect
{
    _imageViewRect = imageViewRect;
    [self setNeedsDisplay];
}

- (void)setAccessoryViewRect:(CGRect)accessoryViewRect
{
    _accessoryViewRect = accessoryViewRect;
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_textLabelRect.size.width != 0)
        self.textLabel.frame = _textLabelRect;
    if(_detialTextLabelRect.size.width != 0)
        self.detailTextLabel.frame = _detialTextLabelRect;
    if(_imageViewRect.size.width != 0)
        self.imageView.frame = _imageViewRect;
    if(_accessoryViewRect.size.width != 0)
        self.accessoryView.frame = _accessoryViewRect;
}

@end
