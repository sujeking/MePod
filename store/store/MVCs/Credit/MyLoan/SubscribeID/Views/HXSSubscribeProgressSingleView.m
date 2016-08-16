//
//  HXSSubscribeProgressSingleView.m
//  59dorm
//
//  Created by J006 on 16/7/11.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

static CGFloat const bigImageWidthHeight = 35;
static CGFloat const smallImageWidthHeight = 24;

#define LINE_WIDTH (SCREEN_WIDTH * 60) / 750

#import "HXSSubscribeProgressSingleView.h"

@interface HXSSubscribeProgressSingleView()

@property (nonatomic, strong) NSString                                  *contentStr;
@property (nonatomic, strong) NSString                                  *enableImageNameStr;
@property (nonatomic, strong) NSString                                  *disableImageNameStr;
@property (nonatomic, strong) NSString                                  *currentImageNameStr;

@property (nonatomic, assign) HXSSubscribeProgressSingleViewQueueType   queueType;
@property (nonatomic, assign) HXSSubscribeProgressSingleViewCurrentType currentType;
@property (nonatomic, assign) CGFloat                                   height;
@property (nonatomic, assign) CGFloat                                   width;

@property (nonatomic, strong) UIImageView                               *imageView;
@property (nonatomic, strong) UILabel                                   *contentLabel;
@property (nonatomic, strong) UIView                                    *rightLineView;
@property (nonatomic, strong) UIView                                    *leftLineView;

@end

#pragma mark create

@implementation HXSSubscribeProgressSingleView

+ (instancetype)createSubscribeProgressSingleViewWithContent:(NSString *)content
                                          andEnableImageName:(NSString *)enableImageName
                                         andDisableImageName:(NSString *)disableImageName
                                         andCurrentImageName:(NSString *)currentImageName
                                                     andType:(HXSSubscribeProgressSingleViewQueueType)queueType
                                              andCurrentStep:(HXSSubscribeProgressSingleViewCurrentType)currentType
                                                    andWidth:(CGFloat)width
                                                   andHeight:(CGFloat)height
{
    HXSSubscribeProgressSingleView *view = [[HXSSubscribeProgressSingleView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    view.contentStr             = content;
    view.enableImageNameStr     = enableImageName;
    view.disableImageNameStr    = disableImageName;
    view.currentImageNameStr    = currentImageName;
    
    view.queueType              = queueType;
    view.currentType            = currentType;
    view.height                 = height;
    view.width                  = width;
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    [view initTheSubViews];
    
    return view;
}

- (void)drawRect:(CGRect)rect
{
}


#pragma mark init

/**
 *  初始化子控件
 */
- (void)initTheSubViews
{
    [self initTheImageView];
    
    [self initTheLineView];
}

- (void)initTheImageView
{
    [self addSubview:self.imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        if(_currentType == HXSSubscribeProgressSingleViewCurrentTypeCurrent) {
            make.width.mas_equalTo(bigImageWidthHeight);
            make.height.mas_equalTo(bigImageWidthHeight);
        } else {
            make.width.mas_equalTo(smallImageWidthHeight);
            make.height.mas_equalTo(smallImageWidthHeight);
        }
    }];
    
    if(_currentType == HXSSubscribeProgressSingleViewCurrentTypeCurrent)
    {
        [self addSubview:self.contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).offset(5);
            make.centerX.equalTo(self);
        }];
    }
}

- (void)initTheLineView
{
    switch (_queueType)
    {
        case HXSSubscribeProgressSingleViewQueueTypeNormal:
        {
            [self addSubview:self.rightLineView];
            [self addSubview:self.leftLineView];
            
            [_leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_imageView.mas_left).offset(-5);
                make.centerY.equalTo(_imageView);
                make.width.mas_equalTo(LINE_WIDTH);
                make.height.mas_equalTo(3);
            }];
            
            [_rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imageView.mas_right).offset(5);
                make.centerY.equalTo(_imageView);
                make.width.mas_equalTo(LINE_WIDTH);
                make.height.mas_equalTo(3);
            }];
            
            if(_currentType == HXSSubscribeProgressSingleViewCurrentTypeNot) {
                [_leftLineView  setBackgroundColor:[UIColor colorWithRGBHex:0xd8d8d8]];
                [_rightLineView setBackgroundColor:[UIColor colorWithRGBHex:0xd8d8d8]];
            } else if (_currentType == HXSSubscribeProgressSingleViewCurrentTypeCurrent) {
                [_leftLineView  setBackgroundColor:[UIColor colorWithRGBHex:0x07A9FA]];
                [_rightLineView setBackgroundColor:[UIColor colorWithRGBHex:0xd8d8d8]];
            } else {
                [_leftLineView  setBackgroundColor:[UIColor colorWithRGBHex:0x07A9FA]];
                [_rightLineView setBackgroundColor:[UIColor colorWithRGBHex:0x07A9FA]];
            }
            
            break;
        }
        case HXSSubscribeProgressSingleViewQueueTypeFirst:
        {
            [self addSubview:self.rightLineView];
            
            [_rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imageView.mas_right).offset(5);
                make.centerY.equalTo(_imageView);
                make.width.mas_equalTo(LINE_WIDTH);
                make.height.mas_equalTo(3);
            }];
            
            if(_currentType == HXSSubscribeProgressSingleViewCurrentTypePass) {
                [_rightLineView  setBackgroundColor:[UIColor colorWithRGBHex:0x07A9FA]];
            } else {

                [_rightLineView setBackgroundColor:[UIColor colorWithRGBHex:0xd8d8d8]];
            }
            
            break;
        }
        case HXSSubscribeProgressSingleViewQueueTypeLast:
        {
            [self addSubview:self.leftLineView];
            
            [_leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_imageView.mas_left).offset(-5);
                make.centerY.equalTo(_imageView);
                make.width.mas_equalTo(LINE_WIDTH);
                make.height.mas_equalTo(3);
            }];
            
            if(_currentType == HXSSubscribeProgressSingleViewCurrentTypeNot) {
                [_leftLineView setBackgroundColor:[UIColor colorWithRGBHex:0xd8d8d8]];
            } else {
                [_leftLineView  setBackgroundColor:[UIColor colorWithRGBHex:0x07A9FA]];
            }
            
            break;
        }
    }
}


#pragma mark - getter

- (UILabel *)contentLabel
{
    if(!_contentLabel)
    {
        _contentLabel = [[UILabel alloc]init];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:13]];
        [_contentLabel setText:_contentStr];
        [_contentLabel setTextColor:[UIColor colorWithRGBHex:0x07A9FA]];
    }
    
    return _contentLabel;
}

- (UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc]init];
        
        switch (_currentType)
        {
                case HXSSubscribeProgressSingleViewCurrentTypeNot:
                {
                    [_imageView setImage:[UIImage imageNamed:_disableImageNameStr]];
                    break;
                }
                case HXSSubscribeProgressSingleViewCurrentTypeCurrent:
                {
                    [_imageView setImage:[UIImage imageNamed:_currentImageNameStr]];
                    break;
                }
                case HXSSubscribeProgressSingleViewCurrentTypePass:
                {
                    [_imageView setImage:[UIImage imageNamed:_enableImageNameStr]];
                    break;
                }
        }
        
    }
    
    return _imageView;
}

- (UIView *)rightLineView
{
    if(!_rightLineView)
    {
        _rightLineView = [[UIView alloc]init];
        [_rightLineView setBackgroundColor:[UIColor colorWithRGBHex:0xd8d8d8]];
        [_rightLineView.layer setCornerRadius:2];
    }
    
    return _rightLineView;
}

- (UIView *)leftLineView
{
    if(!_leftLineView)
    {
        _leftLineView = [[UIView alloc]init];
        [_leftLineView setBackgroundColor:[UIColor colorWithRGBHex:0xd8d8d8]];
        [_leftLineView.layer setCornerRadius:2];
    }
    
    return _leftLineView;
}

@end
