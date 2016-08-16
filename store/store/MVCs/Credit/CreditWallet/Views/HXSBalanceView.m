//
//  HXSBalanceView.m
//  Test
//
//  Created by hudezhi on 15/11/4.
//  Copyright © 2015年 59store. All rights reserved.
//

#import "HXSBalanceView.h"


@interface NSString (NMSchemeItemDraw)

-(void)drawWithBasePoint:(CGPoint)basePoint Angle:(CGFloat)angle Font:(UIFont*)font color:(UIColor*)color;

@end

@implementation NSString (NMSchemeItemDraw)

-(void)drawWithBasePoint:(CGPoint)basePoint Angle:(CGFloat)angle Font:(UIFont*)font color:(UIColor*)color
{
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:color};
    
    CGSize  textSize = [self sizeWithAttributes:attributes];
    
    CGContextRef    context =   UIGraphicsGetCurrentContext();
    CGAffineTransform   t   =   CGAffineTransformMakeTranslation(basePoint.x, basePoint.y);
    CGAffineTransform   r   =   CGAffineTransformMakeRotation(angle);
    
    
    CGContextConcatCTM(context, t);
    CGContextConcatCTM(context, r);
    
    [self drawAtPoint:CGPointMake(-1 * textSize.width / 2, -1 * textSize.height / 2)
               withAttributes:attributes];
    
    CGContextConcatCTM(context, CGAffineTransformInvert(r));
    CGContextConcatCTM(context, CGAffineTransformInvert(t));
}

@end

static CGFloat Project_Scale = 0.34;     // 圆底部截距占整个宽度的百分比
static CGFloat Overflow_Angle = 10.0;    // 超过半圆部分的角度
static CGFloat Outer_Arc_Offset = 10.0;  // 外圆框相对于内圆的超出的半径
static CGFloat Scale_Angle_Offset = 8.0; // 刻度开始的偏移角(相对于水平位置)

@interface HXSBalanceView () {
    NSInteger _maxValue;
    CGFloat   _currentValue;
    
    UIView    *_topDecorationView;
    
    CALayer   *_twinkleLittleStarLayer;
    CAShapeLayer    *_tailPathLayer;
    UILabel   *_tipLabel;
    UILabel   *_availableMoneyLabel;
    UILabel   *_currencyLabel;
    
    CAGradientLayer *_leftGradientLayer;
    CAGradientLayer *_rightGradientLayer;
    
    UILabel     *_animatedLabel;
}

- (void)setup;

@end

@implementation HXSBalanceView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    
    if (_topDecorationView == nil) {
        _topDecorationView = [[UIView alloc] init];
        _topDecorationView.backgroundColor = [UIColor colorWithRGBHex:0x08A9FA];
        [self addSubview:_topDecorationView];
    }
    
    if (_tailPathLayer == nil) {
        _tailPathLayer = [[CAShapeLayer alloc] init];
        _tailPathLayer.strokeColor = [UIColor whiteColor].CGColor;
        _tailPathLayer.fillColor = [UIColor clearColor].CGColor;
        _tailPathLayer.lineWidth = 3.0;
        
        [self.layer addSublayer:_tailPathLayer];
    }
    
    if (_twinkleLittleStarLayer == nil) {
        _twinkleLittleStarLayer = [[CALayer alloc] init];
        UIImage *littleStarImage = [UIImage imageNamed:@"twinkle_little_star"];
        _twinkleLittleStarLayer.contents = (__bridge id _Nullable)(littleStarImage.CGImage);
        _twinkleLittleStarLayer.bounds = CGRectMake(0, 0, 20.0, 20.0);

        [self.layer addSublayer:_twinkleLittleStarLayer];
    }
    
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor colorWithRGBHex:0x999999];
        _tipLabel.font = [UIFont systemFontOfSize:14.0];
        _tipLabel.text = @"剩余可用余额";
        [self addSubview:_tipLabel];
    }
    
    if (_availableMoneyLabel == nil) {
        _availableMoneyLabel = [[UILabel alloc] init];
        _availableMoneyLabel.backgroundColor = [UIColor clearColor];
        _availableMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _availableMoneyLabel.font = [UIFont systemFontOfSize:32];
        if ((kHXSCreditAccountStatusOpened == creditCardInfo.accountStatusIntNum.intValue
             || kHXSCreditAccountStatusChecking == creditCardInfo.accountStatusIntNum.intValue)) {
            _availableMoneyLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
        } else {
            _availableMoneyLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        }
        [self addSubview:_availableMoneyLabel];
    }
    
    if (_currencyLabel == nil) {
        _currencyLabel = [[UILabel alloc] init];
        _currencyLabel.backgroundColor = [UIColor clearColor];
        _currencyLabel.textAlignment = NSTextAlignmentRight;
        _currencyLabel.font = [UIFont systemFontOfSize:24];
        _currencyLabel.text = @"￥";
        if (kHXSCreditAccountStatusOpened == creditCardInfo.accountStatusIntNum.intValue
             || kHXSCreditAccountStatusChecking == creditCardInfo.accountStatusIntNum.intValue) {
            _currencyLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
        } else {
            _currencyLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        }
        [self addSubview:_currencyLabel];
    }
     
    if (_animatedLabel == nil) {
        _animatedLabel = [[UILabel alloc] init];
        _animatedLabel.textAlignment = NSTextAlignmentCenter;
        _animatedLabel.textColor = [UIColor whiteColor];
        _animatedLabel.font = [UIFont systemFontOfSize:16.0];
        _animatedLabel.text = @"正青春，花不完";
        
        [self addSubview:_animatedLabel];
    }
    
    if (_leftGradientLayer == nil) {
        _leftGradientLayer = [[CAGradientLayer alloc] init];
        
        _leftGradientLayer.startPoint = CGPointMake(0.0, 0.5);
        _leftGradientLayer.endPoint = CGPointMake(1.0, 0.5);
        _leftGradientLayer.colors =  @[(id)[[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor,
                                       (id)[UIColor whiteColor] .CGColor];
        _leftGradientLayer.locations = @[@0.0,@1.0];
        
        [self.layer addSublayer:_leftGradientLayer];
    }
    
    if (_rightGradientLayer == nil) {
        _rightGradientLayer = [[CAGradientLayer alloc] init];
        
        _rightGradientLayer.startPoint = CGPointMake(0.0, 0.5);
        _rightGradientLayer.endPoint = CGPointMake(1.0, 0.5);
        _rightGradientLayer.colors =  @[(id)[UIColor whiteColor] .CGColor,
                                        (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor];
        _rightGradientLayer.locations = @[@0.0,@1.0];
        
        [self.layer addSublayer:_rightGradientLayer];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _topDecorationView.frame = CGRectMake(0, -64, self.width, 64);
    
    CGSize size = [_tipLabel.text sizeWithAttributes:@{NSFontAttributeName: _tipLabel.font}];
    _tipLabel.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat centenY = (SCREEN_HEIGHT < 600) ? 40 : 50;
    _animatedLabel.frame = CGRectMake(0, 0, 200, 30);
    _animatedLabel.center = CGPointMake(self.width/2.0, centenY);
    
    _leftGradientLayer.frame = CGRectMake(self.width/2.0 - 160, centenY, 50, 0.5);
    _rightGradientLayer.frame = CGRectMake(self.width/2.0 + 110, centenY, 50, 0.5);
    
    
    size = [_availableMoneyLabel.text sizeWithAttributes:@{NSFontAttributeName: _availableMoneyLabel.font}];
    
    _availableMoneyLabel.frame = CGRectMake(0, 0, size.width, size.height);
    _availableMoneyLabel.center = CGPointMake(self.width/2.0 + 10.0, self.height - 30);
    _currencyLabel.frame = CGRectMake(0, _availableMoneyLabel.y, _availableMoneyLabel.x + 5.0, _availableMoneyLabel.height);
    _currencyLabel.center = CGPointMake(_currencyLabel.center.x, self.height - 28);
    
    CGFloat offset = (SCREEN_WIDTH <= 320) ? _tipLabel.height/2.0 : 15;
    _tipLabel.center = CGPointMake(self.width/2.0, _availableMoneyLabel.y - offset);
    
    [self animateTwinkleLittleStar];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 渐变色背景
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 (const CGFloat[8]){0.03, 0.66f, 0.98f, 1.0f,
                                                                     0.0f, 0.81, 0.89f, 1.0f},
                                                                 (const CGFloat[2]){0.0f,1.0f},
     2);
    
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)),
                                CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)),
                                0);
    
    CGColorSpaceRelease(colorSpace);
    
    // 画圆
    UIColor *color = [UIColor whiteColor];
    [color set];
    
    CGFloat overflowAngle = Overflow_Angle/180.0; // 10度
    CGFloat angle = M_PI*overflowAngle;
    CGFloat projection = self.width*Project_Scale;
    CGFloat radius = projection/cos(angle);
    CGFloat intercept = projection*tan(angle);
    CGPoint center = CGPointMake(self.width/2.0, self.height - intercept);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:(M_PI - angle) endAngle: angle clockwise:YES];
    [path fill];
    
    [path removeAllPoints];
    
    CGFloat scaleW = 3.0; // 刻度长度
    
    // 画刻度,左右对称的
    CGFloat scaleOffset = (M_PI*(90 + Scale_Angle_Offset))/(180.0*5.0);
    [[UIColor colorWithRGBHex:0xB3E5FC] set];
    
    CGFloat scaleAngle = -(M_PI*Scale_Angle_Offset)/180.0;
    for (int i = 0 ; i <= 5; i++) {
        CGFloat cosValue = cos(scaleAngle);
        CGFloat sinValue = sin(scaleAngle);
        // 画刻度
        CGFloat w1 = radius * cosValue;
        CGFloat h1 = radius * sinValue;
        
        CGFloat radiusOffset = (i%2) ? scaleW : 2*scaleW;
        CGFloat w2 = (radius - radiusOffset)*cosValue;
        CGFloat h2 = (radius - radiusOffset)*sinValue;
        
        CGPoint point1 = CGPointMake(center.x - w1, center.y - h1);
        CGPoint point2 = CGPointMake(center.x - w2, center.y - h2);
        
        [path moveToPoint:point1];
        [path addLineToPoint:point2];
        
        if (i != 5) {
            point1 = CGPointMake(center.x + w1, center.y - h1);
            point2 = CGPointMake(center.x + w2, center.y - h2);
        
            [path moveToPoint:point1];
            [path addLineToPoint:point2];
        }
        
        UIFont *font = [UIFont systemFontOfSize:10.0];
        UIColor *color = [UIColor colorWithRGBHex:0xB3E5FC];
        // 画刻度值
        if (i%2 == 0) {
            CGFloat w3 = (radius - radiusOffset - 10)*cosValue;
            CGFloat h3 = (radius - radiusOffset - 10)*sinValue;
            NSInteger scaleValue = (NSInteger)(10 * i);
            NSString *scaleValueStr = [NSString stringWithFormat:@"%li%%", (long)scaleValue];
            CGPoint drawPoint = CGPointMake(center.x - w3, center.y - h3);
        
            [scaleValueStr drawWithBasePoint:drawPoint Angle:(3*M_PI_2 + scaleAngle) Font:font color:color];
            
            drawPoint = CGPointMake(center.x + w3, center.y - h3);
            scaleValue = (NSInteger)(10 * (10 - i));
            scaleValueStr = [NSString stringWithFormat:@"%li%%", (long)scaleValue];
            
            // 最大值画不下
            if (i == 0) {
                CGSize size = [scaleValueStr sizeWithAttributes:@{NSFontAttributeName:font}];
                drawPoint = CGPointMake(center.x + w3, center.y - h3 - size.height/2.0);
            }
            
            [scaleValueStr drawWithBasePoint:drawPoint Angle:(M_PI_2 - scaleAngle) Font:font color:color];
        }
        
        
        scaleAngle += scaleOffset;
    }
    
    [path stroke];
    
    [path removeAllPoints];
    
    [[UIColor colorWithRGBHex:0x77DAE9] set];
    path.lineWidth = 3.0;
    [path addArcWithCenter:center radius:radius + Outer_Arc_Offset startAngle:(M_PI - angle) endAngle:M_PI*2 + angle clockwise:YES];
    [path stroke];
}

#pragma mark - private method

- (void)animateTwinkleLittleStar
{
    if (_maxValue == 0) {
        return;
    }
    
    CGFloat overflowAngle = Overflow_Angle/180.0;
    CGFloat angle = M_PI*overflowAngle;
    CGFloat projection = self.width*Project_Scale;
    
    CGFloat radius = projection/cos(angle) + Outer_Arc_Offset;
    CGFloat intercept = projection*tan(angle);
    CGPoint center = CGPointMake(self.width/2.0, self.height - intercept);
    
    CGFloat progress = _currentValue/_maxValue;
    
    CGFloat startAngleOffset = M_PI*Scale_Angle_Offset/180.0;
    
    CGFloat startAngle = M_PI - startAngleOffset;
    CGFloat endAngle = startAngle + (M_PI + 2*startAngleOffset)*progress;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:(M_PI - angle) endAngle: endAngle clockwise:YES];
    
    CGPoint endPosition = path.currentPoint;
    _twinkleLittleStarLayer.position = endPosition;
    
    CAKeyframeAnimation *flyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    flyAnimation.path = path.CGPath;
    flyAnimation.calculationMode = kCAAnimationPaced;
    flyAnimation.duration = 1.5;
    [_twinkleLittleStarLayer addAnimation:flyAnimation forKey:nil];
    
    UIBezierPath *tailPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:(M_PI - angle) endAngle: endAngle clockwise:YES];
    _tailPathLayer.path = tailPath.CGPath;
    
    CABasicAnimation *tailPathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailPathAnimation.duration = 1.5;
    tailPathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    tailPathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    [_tailPathLayer addAnimation:tailPathAnimation forKey:nil];
}

#pragma mark - public method

- (void)setTipText:(NSString *)tipText
{
    _tipLabel.text = tipText;
    [self setNeedsLayout];
}

- (void)setCurrentValue:(CGFloat)currentValue maxValue:(NSInteger)maxValue
{
    _maxValue = maxValue;
    _currentValue = currentValue;
    
    [self setNeedsDisplay];
    
    _availableMoneyLabel.text = [NSString stringWithFormat:@"%.2f", (float)_currentValue];
    [self setNeedsLayout];
    
    [self animateTwinkleLittleStar];
}

@end
