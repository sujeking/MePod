//
//  HXSLoadFailureView.m
//  HXSLoadingAnimation
//
//  Created by BeyondChao on 16/5/16.
//  Copyright © 2016年 BeyondChao. All rights reserved.
//

#import "HXSLoadFailureView.h"

CGFloat const LoadFailureEyeballSize = 15;
CGFloat const MouthWaveWidth = 35;

@interface HXSLoadFailureView ()

/** 左眼珠 */
@property (nonatomic, strong) CALayer *leftEyeballLayer;
/** 右眼珠 */
@property (nonatomic, strong) CALayer *rightEyeballLayer;
/** 嘴 */
@property (nonatomic, strong) UIView *mouthWaveView;

@end

@implementation HXSLoadFailureView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.contents = (id)[UIImage imageNamed:@"body.png"].CGImage;
        
        [self addSubLayer];
    }
    return self;
}

- (void)addSubLayer {
    
    // 添加左眼珠
    CGFloat leftEyex = 36;
    CGFloat leftEyey = 32;
    self.leftEyeballLayer = [self createEyeballLayer:@"left.png"];
    self.leftEyeballLayer.position = CGPointMake(leftEyex, leftEyey);
    [self.layer addSublayer:self.leftEyeballLayer];
    [self.leftEyeballLayer addAnimation:[self eyeballRotateAnimation] forKey:@"leftEye"];
    
    // 添加右眼珠
    CGFloat rightEyex = self.bounds.size.width - CGRectGetMaxX(self.leftEyeballLayer.frame) + 4;
    self.rightEyeballLayer = [self createEyeballLayer:@"right.png"];
    self.rightEyeballLayer.position =  CGPointMake(rightEyex, leftEyey);
    [self.layer addSublayer:self.rightEyeballLayer];
    [self.rightEyeballLayer addAnimation:[self eyeballRotateAnimation] forKey:@"rightEye"];
    
    CGFloat mouthX = leftEyex + 13;
    CGFloat mouthY = leftEyey + 13;
    CGFloat mouthH = 4;
    // 添加嘴
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(mouthX, mouthY, MouthWaveWidth, mouthH)];
    container.backgroundColor = [UIColor clearColor];
    [container setClipsToBounds:YES];
    [self addSubview:container];

    self.mouthWaveView = [[UIView alloc] initWithFrame:CGRectMake(-MouthWaveWidth, 0, MouthWaveWidth * 2, mouthH)];
    self.mouthWaveView.layer.contents = (id)[UIImage imageNamed:@"wave"].CGImage;
    [container addSubview:self.mouthWaveView];
    [self animateWave];
}

- (CALayer *)createEyeballLayer:(NSString *)imageName{
    CALayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds =  CGRectMake(0, 0, LoadFailureEyeballSize, LoadFailureEyeballSize);
    shapeLayer.contents = (id)[UIImage imageNamed:imageName].CGImage;
    
    return shapeLayer;
}

- (CABasicAnimation *)eyeballRotateAnimation {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    // 设定动画选项
    animation.duration = 0.3; // 持续时间
    animation.repeatCount = HUGE_VALF; // 重复次数
    
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI]; // 终止角度
    
    return animation;
}

- (void)animateWave {
    [UIView animateWithDuration:1.2 delay:0.0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
        self.mouthWaveView.transform = CGAffineTransformMakeTranslation(MouthWaveWidth / 2, 0);
    } completion:^(BOOL finished) {
        self.mouthWaveView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}


@end
