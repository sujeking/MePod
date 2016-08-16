//
//  HXSSubscribeHeaderFooterView.m
//  59dorm
//
//  Created by J006 on 16/7/8.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeHeaderFooterView.h"

@interface HXSSubscribeHeaderFooterView()

@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat  height;
@property (nonatomic, assign) CGFloat  fontSize;
@property (nonatomic, strong) UIColor  *textColor;
@property (nonatomic, strong) UILabel  *contentLabel;

@end

@implementation HXSSubscribeHeaderFooterView

#pragma mark create

+ (instancetype)createSubscribeHeaderFooterViewWithContent:(NSString *)content
                                                 andHeight:(CGFloat)height
                                               andFontSize:(CGFloat)fontSize
                                              andTextColor:(UIColor*)textColor;
{
    HXSSubscribeHeaderFooterView *headerFooterView = [[HXSSubscribeHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    
    headerFooterView.backgroundColor = [UIColor clearColor];
    headerFooterView.content         = content;
    headerFooterView.height          = height;
    headerFooterView.fontSize        = fontSize;
    headerFooterView.textColor       = textColor;
    
    [headerFooterView initTheSubViews];
    
    return headerFooterView;
}


#pragma mark - init

/**
 *  初始化子控件
 */
- (void)initTheSubViews
{
    [self addSubview:self.contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - getter

- (UILabel *)contentLabel
{
    if(!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:_fontSize]];
        [_contentLabel setText:_content];
        [_contentLabel setTextColor:_textColor];
    }
    
    return _contentLabel;
}

@end
