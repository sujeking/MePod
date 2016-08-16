//
//  HXSMyFilesPopView.m
//  store
//
//  Created by J006 on 16/6/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyFilesPopView.h"

static CGFloat const buttonSingleHeight = 40;   // 单个按钮的高度
static CGFloat const triangleHeight = 5;        // 三角形高度
static NSTimeInterval const animationTime = 0.5;

#define lineColor [UIColor colorWithRed:225/255.0 green:226/255.0 blue:227/255.0 alpha:1.0]

@interface HXSMyFilesPopView()

@property (nonatomic ,strong) UIView                     *popMainView;
@property (nonatomic ,strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic ,assign) CGFloat                    popViewWidth;      // 弹出框的宽度
@property (nonatomic ,assign) HXSMyFilesPopViewRotation  rotation;
@property (nonatomic ,assign) HXSMyFilesPopViewDirection direction;
@property (nonatomic ,strong) UIView                     *targetClickView;
@property (nonatomic ,strong) UIButton                   *backGroundButton; // 背景透明图

@end

@implementation HXSMyFilesPopView


#pragma mark - init

+ (instancetype)initTheMyFilesPopViewWithBtnNameArray:(NSArray<NSString *> *)btnNameArray
                                           targetView:(UIView *)view
                                          andDelegate:(id<HXSMyFilesPopViewDelegate>)delegate
                                     popViewDirection:(HXSMyFilesPopViewDirection)direction
                                      popViewRotation:(HXSMyFilesPopViewRotation)rotation
{
    HXSMyFilesPopView *myFilesPopView = [[HXSMyFilesPopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    myFilesPopView.direction          = direction;
    myFilesPopView.rotation           = rotation;
    myFilesPopView.targetClickView    = view;
    myFilesPopView.delegate           = delegate;
    
    for (NSString *btnNameStr in btnNameArray)
    {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:btnNameStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRGBHex:0x999999] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTag:[btnNameArray indexOfObject:btnNameStr]];
        [button addTarget:myFilesPopView action:@selector(buttonTapActionWithUIButton:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [myFilesPopView.buttonArray addObject:button];
    }
    
    myFilesPopView.popViewWidth = [myFilesPopView checkTheButtonArrayAndGetTheWidth];
    
    return myFilesPopView;
}


#pragma mark - life cycle

-(void)drawRect:(CGRect)rect
{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setAlpha:0.0];
        //[self setupSubView];
    }
    return self;
}

- (void)showThePopView
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [self addSubview:self.backGroundButton];
    [self addSubview:self.popMainView];
    
    CGRect targetClickViewRect = [self getFrameInWindow:_targetClickView];
    UIButton *tempButtonView = [[UIButton alloc]initWithFrame:targetClickViewRect];
    [tempButtonView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:tempButtonView];
    
    if(_direction == HXSMyFilesPopViewDirectionUp) {
        switch (_rotation)
        {
            case HXSMyFilesPopViewRotationLeft:
            {
                [_popMainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(tempButtonView.mas_top).offset(-triangleHeight);
                    make.right.equalTo(tempButtonView);
                    make.width.mas_equalTo(_popViewWidth);
                    make.height.mas_equalTo(buttonSingleHeight * _buttonArray.count);
                }];
                break;
            }
            case HXSMyFilesPopViewRotationMiddle:
            {
                [_popMainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(tempButtonView.mas_top).offset(-triangleHeight);
                    make.centerX.equalTo(tempButtonView);
                    make.width.mas_equalTo(_popViewWidth);
                    make.height.mas_equalTo(buttonSingleHeight * _buttonArray.count);
                }];
                break;
            }
            case HXSMyFilesPopViewRotationRight:
            {
                [_popMainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(tempButtonView.mas_top).offset(-triangleHeight);
                    make.left.equalTo(tempButtonView);
                    make.width.mas_equalTo(_popViewWidth);
                    make.height.mas_equalTo(buttonSingleHeight * _buttonArray.count);
                }];
                break;
            }
        }
    } else if(_direction == HXSMyFilesPopViewDirectionDown) {
        switch (_rotation)
        {
            case HXSMyFilesPopViewRotationLeft:
            {
                [_popMainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tempButtonView.mas_bottom).offset(triangleHeight);
                    make.right.equalTo(tempButtonView);
                    make.width.mas_equalTo(_popViewWidth);
                    make.height.mas_equalTo(buttonSingleHeight * _buttonArray.count);
                }];
                break;
            }
            case HXSMyFilesPopViewRotationMiddle:
            {
                [_popMainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tempButtonView.mas_bottom).offset(triangleHeight);
                    make.centerX.equalTo(tempButtonView);
                    make.width.mas_equalTo(_popViewWidth);
                    make.height.mas_equalTo(buttonSingleHeight * _buttonArray.count);
                }];
                break;
            }
            case HXSMyFilesPopViewRotationRight:
            {
                [_popMainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tempButtonView.mas_bottom).offset(triangleHeight);
                    make.left.equalTo(tempButtonView);
                    make.width.mas_equalTo(_popViewWidth);
                    make.height.mas_equalTo(buttonSingleHeight * _buttonArray.count);
                }];
                break;
            }
        }
    }
    
    [self drawRectInThePopView];
    
    [self initTheTriangle];
    
    [self initTheButtonView];
    
    [UIView animateWithDuration:animationTime animations:^{
        [self setAlpha:1.0];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  初始化设置三角形指向
 */
- (void)initTheTriangle
{
    CGPoint startPoint,endPoint,thirdPoint;
    CGRect rect = [self getFrameInWindow:_targetClickView];
    
    if(_direction == HXSMyFilesPopViewDirectionUp) {
        startPoint = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y);
        endPoint   = CGPointMake(startPoint.x - triangleHeight, startPoint.y - triangleHeight -1);// -1为了掩盖外边框
        thirdPoint = CGPointMake(startPoint.x + triangleHeight/2, startPoint.y - triangleHeight -1);// -1为了掩盖外边框
    } else {
        startPoint = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height);
        endPoint   = CGPointMake(startPoint.x - triangleHeight, startPoint.y + triangleHeight + 1);// +1为了掩盖外边框
        thirdPoint = CGPointMake(startPoint.x + triangleHeight, startPoint.y + triangleHeight + 1);// +1为了掩盖外边框
    }
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:startPoint];
    [triangle addLineToPoint:endPoint];
    [triangle addLineToPoint:thirdPoint];
    [triangle closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor     = [UIColor whiteColor].CGColor;
    shapeLayer.path          = triangle.CGPath;
    
    [self.layer addSublayer:shapeLayer];
}

- (void)initTheButtonView
{
    for (UIButton *button in _buttonArray)
    {
        [_popMainView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_popMainView);
            make.right.equalTo(_popMainView);
            make.top.equalTo(_popMainView).offset(buttonSingleHeight * [_buttonArray indexOfObject:button]);
            make.height.mas_equalTo(buttonSingleHeight);
        }];
        if([_buttonArray indexOfObject:button] != _buttonArray.count-1)
        {
            [self drawLineInTheButton:button];
        }
    }
}


#pragma mark - Button Action

- (void)buttonTapActionWithUIButton:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationTime animations:^{
        [weakSelf setAlpha:0.0];
    } completion:^(BOOL finished) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(buttonClick:andWithIndex:)]) {
            [weakSelf dismissTheView];
            [weakSelf.delegate buttonClick:self andWithIndex:button.tag];
        }
    }];
}


#pragma mark - BackGround Tap

/**
 *  背景界面点击
 *
 *  @param sender
 */
- (void)backGroundViewAction
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationTime animations:^{
        [weakSelf setAlpha:0.0];
    } completion:^(BOOL finished) {
        [weakSelf dismissTheView];
    }];
}

- (void)dismissTheView
{
    [self removeFromSuperview];
}


#pragma mark - Get popView Width

/**
 *  获取按钮最大宽度
 *
 *  @return
 */
- (CGFloat)checkTheButtonArrayAndGetTheWidth
{
    if(!_buttonArray || _buttonArray.count == 0) {
        return 0;
    }
    
    CGFloat popViewWidth    = 0;
    CGFloat leftPadding     = 10;//左边边距
    CGFloat rightPadding    = 10;//右边边距
    
    for (UIButton *button in _buttonArray) {
        NSString *btnTitleStr = button.currentTitle;
        CGFloat titleWidth = [btnTitleStr boundingRectWithSize:CGSizeMake(MAXFLOAT,0)
                                                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                       context:nil].size.width;
        CGFloat tempWidth = titleWidth + leftPadding + rightPadding;
        if(tempWidth > popViewWidth) {
            popViewWidth = tempWidth;
        }
    }
    
    return popViewWidth;
}


#pragma mark - DrawLine In the Button

/**
 *  按钮底部画线
 *
 *  @param button
 */
- (void)drawLineInTheButton:(UIButton *)button
{
    CGFloat buttonHeight = buttonSingleHeight;
    CGFloat buttonWidth  = _popViewWidth;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, buttonHeight)];
    [path addLineToPoint:CGPointMake(buttonWidth, buttonHeight)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor     = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor   = lineColor.CGColor;
    shapeLayer.lineWidth     = 1;
    shapeLayer.path          = path.CGPath;
    
    [button.layer addSublayer:shapeLayer];
}

/**
 *  整个弹出框画边框
 */
- (void)drawRectInThePopView
{
    _popMainView.layer.cornerRadius = 2;
    
    _popMainView.layer.borderWidth = 1;
    
    _popMainView.layer.borderColor = lineColor.CGColor;
    
    [_popMainView setClipsToBounds:YES];
}


#pragma mark - private method

- (CGRect)getFrameInWindow:(UIView *)view
{
    // 改用[UIApplication sharedApplication].keyWindow.rootViewController.view，防止present新viewController坐标转换不准问题
    return [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}


#pragma mark - getter/setter

- (UIView *)popMainView
{
    if(!_popMainView)
    {
        _popMainView = [[UIView alloc]init];
        [_popMainView setBackgroundColor:[UIColor whiteColor]];
    }
    return _popMainView;
}

- (NSMutableArray<UIButton *> *)buttonArray
{
    if(!_buttonArray)
    {
        _buttonArray = [[NSMutableArray<UIButton *> alloc]init];
    }
    return _buttonArray;
}

- (UIButton *)backGroundButton
{
    if(!_backGroundButton) {
        _backGroundButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_backGroundButton setBackgroundColor:[UIColor clearColor]];
        [_backGroundButton addTarget:self
                              action:@selector(backGroundViewAction)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _backGroundButton;
}

@end
