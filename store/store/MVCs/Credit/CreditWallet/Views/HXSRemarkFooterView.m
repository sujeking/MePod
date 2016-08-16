//
//  HXSRemarkFooterView.m
//  store
//
//  Created by hudezhi on 15/11/12.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSRemarkFooterView.h"

@interface HXSRemarkFooterView () {
    UILabel *_titleLabel;
    UILabel *_textLabel;
}

- (void)setup;

@end

@implementation HXSRemarkFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"备注:";
    _titleLabel.font = [UIFont systemFontOfSize:13.0];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor colorWithRGBHex:0x999999];
    [self addSubview:_titleLabel];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.numberOfLines = 0;
    [self addSubview:_textLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(15, 22, self.width - 30, 17);
    
    if (_attributeText.length < 1) {
        _textLabel.frame = CGRectMake(15, _titleLabel.bottom + 5, self.width - 30, 0);
    }
    else {
        CGSize size = [_attributeText boundingRectWithSize:CGSizeMake(self.width - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        _textLabel.frame = CGRectMake(15, _titleLabel.bottom + 5, self.width - 30, size.height);
    }
}

- (void)setAttributeText:(NSAttributedString *)attributeText
{
    _attributeText = attributeText;
    
    _textLabel.attributedText = attributeText;
    [self setNeedsLayout];
}


@end
