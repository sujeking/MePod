//
//  ProgressView.m
//  masony
//
//  Created by  黎明 on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ProgressView.h"
#import <Masonry.h>


float const Radius = 75/2;
float const eyeRadius = 2.2;

float const starAngle = -(M_PI/2);
float const endAngle = M_PI*3/2;


@interface ProgressView()

@property(nonatomic, strong) CAShapeLayer *shapeLayer;
@property(nonatomic, strong) CAShapeLayer *lineLayer;
@property(nonatomic, strong) CALayer *leftEye;
@property(nonatomic, strong) CALayer *rightEye;
@property(nonatomic, assign) CGPoint leftPoint;
@property(nonatomic, assign) CGPoint rightPoint;


@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progress = 0.0f;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    __block UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithWhite:0.600 alpha:0.300];
    UIView *xx = [self progressView];
    [bgView addSubview:xx];
    [xx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(226);
        make.top.mas_equalTo(130);
        make.centerX.mas_equalTo(bgView.center.x);
    }];
    
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (UIView *)progressView
{
    __block UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0.500];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
 
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"Resource.bundle/bg.png"];
    
    [imageView.layer addSublayer:self.rightEye];
    [imageView.layer addSublayer:self.leftEye];
    [imageView.layer addSublayer:self.shapeLayer];
    [imageView.layer addSublayer:self.lineLayer];
    
    [bgView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(75);
        make.center.mas_equalTo(bgView.center);
    }];
    return bgView;
}

/**
 *  开始动画
 */
- (void)startAnimation
{
    [self.leftEye addAnimation:[self leftPositionAnimation] forKey:@"leftPositionAnimation"];
    [self.rightEye addAnimation:[self rightPositionAnimation] forKey:@"rightPositionAnimation"];
    [self.shapeLayer addAnimation:[self strokeEndAnimation] forKey:@"strokeEndAnimation"];
}

/**
 *  精度条
 *
 *  @return
 */
- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.path = [self mainCirclePath].CGPath;
        _shapeLayer.fillColor=nil;
        _shapeLayer.lineWidth=3;
        _shapeLayer.strokeStart = 0;
        _shapeLayer.strokeEnd = 0;
        _shapeLayer.strokeColor=[[UIColor colorWithRed:0.070 green:0.704 blue:1.000 alpha:1.000] CGColor];
        _shapeLayer.timeOffset = 0.0f;
    }
    return _shapeLayer;
}


- (CAShapeLayer *)lineLayer
{
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.path = [[self linePath] CGPath];
        _lineLayer.fillColor = nil;
        _lineLayer.strokeColor = [[UIColor whiteColor] CGColor];
        _lineLayer.lineWidth = 3;
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineJoin = kCALineJoinRound;
        _lineLayer.strokeStart = 0;
        _lineLayer.strokeEnd = 0;
    }
    return _lineLayer;
}


/**
 *  右眼
 *
 *  @return
 */
- (CALayer *)rightEye
{
    if (!_rightEye) {
        _rightEye = [CALayer layer];
        _rightEye.frame = CGRectMake(52, 35, 3, 3);
        _rightEye.backgroundColor=[[UIColor colorWithRed:0.529 green:0.780 blue:0.914 alpha:1.000] CGColor];
        _rightEye.cornerRadius = 1.5;
        _rightEye.masksToBounds = YES;
    }
    return _rightEye;
}


/**
 *  左眼
 *
 *  @return
 */
- (CALayer *)leftEye
{
    if (!_leftEye) {
        _leftEye = [CALayer layer];
        _leftEye.frame = CGRectMake(20, 35, 3, 3);
        _leftEye.backgroundColor = [[UIColor colorWithRed:0.529 green:0.780 blue:0.914 alpha:1.000] CGColor];
        _leftEye.cornerRadius = 1.5;
        _leftEye.masksToBounds = YES;
    }
    return _leftEye;
}


/**
 *  左眼动画
 *
 *  @return
 */
- (CAKeyframeAnimation *)leftPositionAnimation
{
    CAKeyframeAnimation * leftPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    leftPositionAnim.path                  = [[self leftCirclePath] CGPath];
    leftPositionAnim.duration              = 7;
    return leftPositionAnim;
}
/**
 *  右眼动画
 *
 *  @return
 */
- (CAKeyframeAnimation *)rightPositionAnimation
{
    CAKeyframeAnimation * rightPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    rightPositionAnim.path                  = [[self rightCirclePath] CGPath];
    rightPositionAnim.duration              = 7;
    
    return rightPositionAnim;
}


/**
 *  环形动画
 *
 *  @return
 */
- (CABasicAnimation *)strokeEndAnimation
{
    CABasicAnimation * strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue          = @0;
    strokeEndAnim.toValue            = @1;
    strokeEndAnim.duration           = 5;
    strokeEndAnim.delegate = self;
    
    strokeEndAnim.fillMode            = kCAFillModeForwards;
    strokeEndAnim.removedOnCompletion = NO;
    
    return strokeEndAnim;
}

/**
 *  左眼路径
 *
 *  @return
 */
- (UIBezierPath *)leftCirclePath
{
    self.leftPoint = CGPointMake(21, 36);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.leftPoint
                                                        radius:eyeRadius
                                                    startAngle:starAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    return path;
}

/**
 *  右眼路劲
 *
 *  @return
 */
- (UIBezierPath *)rightCirclePath
{
    self.rightPoint = CGPointMake(53, 36);

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.rightPoint
                                                             radius:eyeRadius
                                                         startAngle:starAngle
                                                           endAngle:endAngle
                                                          clockwise:YES];
    return path;
}


/**
 *  大圆环路劲
 *
 *  @return
 */
- (UIBezierPath *)mainCirclePath
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Radius, Radius)
                                                        radius:Radius
                                                    startAngle:starAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    return path;
}


/**
 *  画线动画
 *
 *  @return
 */
-(CABasicAnimation *)lineAnim
{
    CABasicAnimation * lineEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    lineEnd.fromValue          = @0;
    lineEnd.toValue            = @1;
    lineEnd.duration           = 0.5;
    lineEnd.fillMode            = kCAFillModeForwards;
    lineEnd.removedOnCompletion = NO;
    [lineEnd setValue:@"lineEnd" forKey:@"finish"];
    lineEnd.delegate = self;

    return lineEnd;
}

/**
 *  画线路径
 *
 *  @return
 */
- (UIBezierPath*)linePath{
    UIBezierPath *pathPath = [UIBezierPath bezierPath];
    [pathPath moveToPoint:CGPointMake(40/2, 74/2)];
    [pathPath addLineToPoint:CGPointMake(130/4, 200/4)];
    [pathPath addLineToPoint:CGPointMake(230/4, 90/4)];
    return pathPath;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"finish"] isEqual:@"lineEnd"]) {
        
        [UIView animateWithDuration:1 animations:^{
            [self setAlpha:0];
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self.leftEye removeFromSuperlayer];
        [self.leftEye removeFromSuperlayer];
        
        self.shapeLayer.fillColor = [[UIColor colorWithRed:0.070 green:0.704 blue:1.000 alpha:1.000] CGColor];
        self.shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
        [self.lineLayer addAnimation:[self lineAnim] forKey:@"cc"];
    }
}


- (void)setProgress:(CGFloat)progress
{
    if (_progress == progress) {
        return;
    }
    _progress = progress;

    CGFloat angle = _progress*2*M_PI - M_PI/2;

    self.rightEye.position = [self calcCircleCoordinateWithCenter:CGPointMake(53, 36)
                                                     andWithAngle:angle
                                                    andWithRadius:eyeRadius];
    self.leftEye.position = [self calcCircleCoordinateWithCenter:CGPointMake(21, 36)
                                                     andWithAngle:angle
                                                    andWithRadius:eyeRadius];

    self.shapeLayer.strokeEnd = _progress;

    if (ceilf(_progress *100) == 100) {
        [self.leftEye removeFromSuperlayer];
        [self.leftEye removeFromSuperlayer];
        
        self.shapeLayer.fillColor = [[UIColor colorWithRed:0.070 green:0.704 blue:1.000 alpha:1.000] CGColor];
        self.shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
        [self.lineLayer addAnimation:[self lineAnim] forKey:@"cc"];
    }
}


- (CGPoint) calcCircleCoordinateWithCenter:(CGPoint)center  andWithAngle:(CGFloat)angle
                             andWithRadius:(CGFloat)radius{
    
    CGFloat x = radius*cosf(angle);
    CGFloat y = radius*sinf(angle);
    return CGPointMake(center.x+x, center.y+y);
}


@end
