//
//  HXSBuildingTableViewCell.m
//  store
//
//  Created by ArthurWang on 15/9/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBuildingTableViewCell.h"

#import "UIColor+Extensions.h"
#import "UIView+Extension.h"

@interface HXSBuildingTableViewCell () {
    UIView *_leftBarView;
}

- (void)setup;

@end

@implementation HXSBuildingTableViewCell

- (void)awakeFromNib
{
}

- (void)prepareForReuse
{
    [super layoutSubviews];
    
    _leftBarView.hidden = YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    if (_leftBarView == nil) {
        _leftBarView = [[UIView alloc] init];
        _leftBarView.backgroundColor = [UIColor colorWithRGBHex:0x0FA9F9];
        [self.contentView addSubview:_leftBarView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _leftBarView.frame = CGRectMake(0.0, 0, 1.5, self.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setShouldHighlighted:(BOOL)shouldHighlighted
{
    _leftBarView.hidden = !shouldHighlighted;
}

@end
