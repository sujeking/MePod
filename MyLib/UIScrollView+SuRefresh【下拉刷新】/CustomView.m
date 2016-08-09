//
//  CustomView.m
//
//  Code generated using QuartzCode 1.21 on 16/5/5.
//  www.quartzcodeapp.com
//

#import "CustomView.h"

@interface CustomView ()

@property (nonatomic, assign) CGPoint oldCenter;
@end

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
        [self setupLayers];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		
        [self setupLayers];
	}
	return self;
}


- (void)setupLayers
{
    self.backgroundColor = [UIColor whiteColor];
    CAShapeLayer *path   = [CAShapeLayer layer];
    path.frame           = CGRectMake(SCREEN_WIDTH/2-20, 35, 40, 45);
    path.fillColor       = nil;
    path.lineWidth       = 0.5;
    path.path            = [self pathPath].CGPath;
    path.strokeStart     = 0;
    path.strokeEnd       = 0;

    CAShapeLayer *redPath   = [CAShapeLayer layer];
    redPath.frame           = CGRectMake(SCREEN_WIDTH/2-20, 35, 40, 45);
    redPath.fillColor       = nil;
    redPath.lineWidth       = 0.5;
    redPath.path            = [self pathPath].CGPath;
    redPath.strokeStart     = 0;
    redPath.strokeEnd       = 0;

    CAShapeLayer *greenPath   = [CAShapeLayer layer];
    greenPath.frame           = CGRectMake(SCREEN_WIDTH/2-20, 35, 40, 45);
    greenPath.fillColor       = nil;
    greenPath.lineWidth       = 0.5;
    greenPath.path            = [self pathPath].CGPath;
    greenPath.strokeStart     = 0;
    greenPath.strokeEnd       = 0;

    CAShapeLayer *yellowPath   = [CAShapeLayer layer];
    yellowPath.frame           = CGRectMake(SCREEN_WIDTH/2-20, 35, 40, 45);
    yellowPath.fillColor       = nil;
    yellowPath.lineWidth       = 0.5;
    yellowPath.path            = [self pathPath].CGPath;
    yellowPath.strokeStart     = 0;
    yellowPath.strokeEnd       = 0;
    
    self.oldCenter = path.position;
    
//    
    
    CAShapeLayer * ball = [CAShapeLayer layer];
    ball.frame     =  CGRectMake(SCREEN_WIDTH/2-7.5, 85, 15, 15);
    ball.fillColor = [UIColor colorWithRed:1 green: 0.502 blue:0 alpha:1].CGColor;
    ball.lineWidth = 0;
    ball.path      = [self ballPath].CGPath;
    
    CAShapeLayer * ball1 = [CAShapeLayer layer];
    ball1.frame     =  CGRectMake(SCREEN_WIDTH/2-7.5, 85, 15, 15);
    ball1.fillColor = [UIColor colorWithRed:0.261 green: 0.501 blue:1 alpha:1].CGColor;
    ball1.lineWidth = 0;
    ball1.path      = [self ballPath].CGPath;
    
    CAShapeLayer * ball2 = [CAShapeLayer layer];
    ball2.frame     =  CGRectMake(SCREEN_WIDTH/2-7.5, 85, 15, 15);
    ball2.fillColor = [UIColor colorWithRed:0.413 green: 1 blue:0.896 alpha:1].CGColor;
    ball2.lineWidth = 0;
    ball2.path      = [self ballPath].CGPath;
    
    CAShapeLayer * ball3 = [CAShapeLayer layer];
    ball3.frame       = CGRectMake(SCREEN_WIDTH/2-7.5, 85, 15, 15);
    ball3.fillColor   = [UIColor colorWithRed:0.988 green: 0.458 blue:1 alpha:1].CGColor;
    ball3.lineWidth   = 0;
    ball3.path        = [self ballPath].CGPath;

    _ball  = ball;
    _ball1 = ball1;
    _ball2 = ball2;
    _ball3 = ball3;
    
    _redPathLayer    = redPath;
    _greenPathLayer  = greenPath;
    _yellowPathLayer = yellowPath;
    _bluePathLayer   = path;

    _greenPathLayer.strokeColor  = [UIColor colorWithRed:0.416 green:0.784 blue:0.784 alpha:1.000].CGColor;
    _redPathLayer.strokeColor    = [UIColor colorWithRed:0.863 green:0.345 blue:0.510 alpha:1.000].CGColor;
    _yellowPathLayer.strokeColor = [UIColor colorWithRed:0.969 green:0.639 blue:0.380 alpha:1.000].CGColor;
    _bluePathLayer.strokeColor   = [UIColor colorWithRed:0.082 green:0.584 blue:0.973 alpha:1.000].CGColor;

    [self.layer addSublayer:greenPath];
    [self.layer addSublayer:redPath];
    [self.layer addSublayer:yellowPath];
    [self.layer addSublayer:path];

    [self.layer addSublayer:ball];
    [self.layer addSublayer:ball1];
    [self.layer addSublayer:ball2];
    [self.layer addSublayer:ball3];
}

- (void)startAllAnimations:(id)sender
{
    [self.greenPathLayer addAnimation:[self pathAnimation] forKey:@"custom2"];
    [self.redPathLayer addAnimation:[self path2Animation] forKey:@"custom1"];
    [self.yellowPathLayer addAnimation:[self path3Animation] forKey:@"custom3"];
    [self.bluePathLayer addAnimation:[self path4Animation] forKey:@"custom4"];

    [self.ball  addAnimation:[self ballAnimation] forKey:@"ballAnimation"];
    [self.ball1 addAnimation:[self ball2Animation] forKey:@"ball2Animation"];
    [self.ball2 addAnimation:[self ball3Animation] forKey:@"ball3Animation"];
    [self.ball3 addAnimation:[self ball4Animation] forKey:@"ball4Animation"];
}


- (CABasicAnimation*)pathAnimation
{
    CABasicAnimation * strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue          = @0;
    strokeEndAnim.toValue            = @1;
    strokeEndAnim.duration           = 1.3;
    strokeEndAnim.repeatCount        = 2;
    strokeEndAnim.fillMode            = kCAFillModeForwards;
    strokeEndAnim.removedOnCompletion = NO;

    return strokeEndAnim;
}

- (CABasicAnimation*)path2Animation
{
    CABasicAnimation * strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue          = @0;
    strokeEndAnim.toValue            = @1;
    strokeEndAnim.duration           = 1.4;
    strokeEndAnim.repeatCount        = 2;
    strokeEndAnim.fillMode = kCAFillModeForwards;
    strokeEndAnim.removedOnCompletion = NO;
    
    return strokeEndAnim;
}

- (CABasicAnimation*)path3Animation
{
    CABasicAnimation * strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue          = @0;
    strokeEndAnim.toValue            = @1;
    strokeEndAnim.duration           = 1.5;
    strokeEndAnim.repeatCount        = 2;
    strokeEndAnim.fillMode = kCAFillModeForwards;
    strokeEndAnim.removedOnCompletion = NO;
    
    return strokeEndAnim;
}

- (CABasicAnimation*)path4Animation
{
    CABasicAnimation * strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue          = @0;
    strokeEndAnim.toValue            = @1;
    strokeEndAnim.duration           = 1.6;
    strokeEndAnim.delegate           = self;
    strokeEndAnim.repeatCount        = 2;
    strokeEndAnim.fillMode = kCAFillModeForwards;
    strokeEndAnim.removedOnCompletion = NO;
    
    return strokeEndAnim;
}

- (CAAnimationGroup*)ballAnimation{
    CABasicAnimation * transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.fromValue          = [NSValue valueWithCATransform3D:CATransform3DIdentity];;
    transformAnim.toValue            = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)];;
    transformAnim.duration           = 0.7;
    
    CAKeyframeAnimation * positionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.path                  = [[self rightpathPath] CGPath];
    positionAnim.duration              = 0.5;
    
    CAAnimationGroup *ovalAnimGroup   = [CAAnimationGroup animation];
    ovalAnimGroup.animations          = @[transformAnim, positionAnim];
    [ovalAnimGroup.animations setValue:kCAFillModeForwards forKeyPath:@"fillMode"];
    ovalAnimGroup.fillMode            = kCAFillModeForwards;
    ovalAnimGroup.removedOnCompletion = NO;
    ovalAnimGroup.duration = [self maxDurationFromAnimations:ovalAnimGroup.animations];
    ovalAnimGroup.repeatCount   = 3;
    
    return ovalAnimGroup;
}

- (CAAnimationGroup*)ball2Animation{
    CABasicAnimation * transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.fromValue          = [NSValue valueWithCATransform3D:CATransform3DIdentity];;
    transformAnim.toValue            = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)];;
    transformAnim.duration           = 0.7;
    transformAnim.beginTime          = 0.5;
    
    CAKeyframeAnimation * positionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.path                  = [[self leftpathPath] CGPath];
    positionAnim.duration              = 0.5;
    positionAnim.beginTime             = 0.5;
    
    CAAnimationGroup *ovalAnimGroup   = [CAAnimationGroup animation];
    ovalAnimGroup.animations          = @[transformAnim, positionAnim];
    [ovalAnimGroup.animations setValue:kCAFillModeForwards forKeyPath:@"fillMode"];
    ovalAnimGroup.fillMode            = kCAFillModeForwards;
    ovalAnimGroup.removedOnCompletion = NO;
    ovalAnimGroup.duration = [self maxDurationFromAnimations:ovalAnimGroup.animations];
    ovalAnimGroup.repeatCount   = 3;
    
    return ovalAnimGroup;
}

- (CAAnimationGroup*)ball3Animation{
    CABasicAnimation * transformAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    transformAnim.fromValue          = @(1);
    transformAnim.toValue            = @(0.2);
    transformAnim.duration           = 0.7;
    transformAnim.beginTime          = 1;
    
    CAKeyframeAnimation * positionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.path                  = [[self rightpathPath] CGPath];
    positionAnim.duration              = 0.5;
    positionAnim.beginTime             = 1;
    
    CAAnimationGroup *ovalAnimGroup   = [CAAnimationGroup animation];
    ovalAnimGroup.animations          = @[transformAnim, positionAnim];
    [ovalAnimGroup.animations setValue:kCAFillModeForwards forKeyPath:@"fillMode"];
    ovalAnimGroup.fillMode            = kCAFillModeForwards;
    ovalAnimGroup.removedOnCompletion = NO;
    ovalAnimGroup.duration = [self maxDurationFromAnimations:ovalAnimGroup.animations];
    ovalAnimGroup.repeatCount   = 3;
    
    return ovalAnimGroup;
}

- (CAAnimationGroup*)ball4Animation{
    CABasicAnimation * transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.fromValue          = [NSValue valueWithCATransform3D:CATransform3DIdentity];;
    transformAnim.toValue            = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)];;
    transformAnim.duration           = 0.7;
    transformAnim.beginTime          = 1.51;
    
    CAKeyframeAnimation * positionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.path                  = [[self leftpathPath] CGPath];
    positionAnim.duration              = 0.5;
    positionAnim.beginTime             = 1.5;
    
    CAAnimationGroup *ovalAnimGroup   = [CAAnimationGroup animation];
    ovalAnimGroup.animations          = @[transformAnim, positionAnim];
    [ovalAnimGroup.animations setValue:kCAFillModeForwards forKeyPath:@"fillMode"];
    ovalAnimGroup.fillMode            = kCAFillModeForwards;
    ovalAnimGroup.removedOnCompletion = NO;
    ovalAnimGroup.duration = [self maxDurationFromAnimations:ovalAnimGroup.animations];
    ovalAnimGroup.repeatCount   = 3;
    
    return ovalAnimGroup;
}

#pragma mark - Bezier Path

- (UIBezierPath*)pathPath
{
    UIBezierPath *pathPath = [UIBezierPath bezierPath];
    [pathPath moveToPoint:CGPointMake(25.263, 0.083)];
    [pathPath addLineToPoint:CGPointMake(9.411, 0.001)];
    [pathPath addLineToPoint:CGPointMake(0, 13.186)];
    [pathPath addLineToPoint:CGPointMake(3.68, 16.137)];
    [pathPath addCurveToPoint:CGPointMake(6.949, 13.827) controlPoint1:CGPointMake(4.778, 16.231) controlPoint2:CGPointMake(4.334, 14.624)];
    [pathPath addCurveToPoint:CGPointMake(9.533, 13.423) controlPoint1:CGPointMake(7.575, 13.637) controlPoint2:CGPointMake(8.493, 13.443)];
    [pathPath addCurveToPoint:CGPointMake(12.656, 14.447) controlPoint1:CGPointMake(11.112, 13.394) controlPoint2:CGPointMake(11.859, 13.923)];
    [pathPath addCurveToPoint:CGPointMake(14.967, 16.645) controlPoint1:CGPointMake(13.813, 15.206) controlPoint2:CGPointMake(14.562, 15.898)];
    [pathPath addCurveToPoint:CGPointMake(15.284, 17.163) controlPoint1:CGPointMake(15.077, 16.849) controlPoint2:CGPointMake(15.179, 17.026)];
    [pathPath addCurveToPoint:CGPointMake(15.284, 17.163) controlPoint1:CGPointMake(15.433, 17.358) controlPoint2:CGPointMake(15.04, 17.142)];
    [pathPath addCurveToPoint:CGPointMake(16.296, 14.447) controlPoint1:CGPointMake(15.623, 16.504) controlPoint2:CGPointMake(15.89, 15.24)];
    [pathPath addCurveToPoint:CGPointMake(17.044, 13.186) controlPoint1:CGPointMake(16.524, 14) controlPoint2:CGPointMake(16.79, 13.528)];
    [pathPath addCurveToPoint:CGPointMake(17.547, 12.555) controlPoint1:CGPointMake(17.241, 12.92) controlPoint2:CGPointMake(17.439, 12.765)];
    [pathPath addCurveToPoint:CGPointMake(16.491, 11.72) controlPoint1:CGPointMake(17.181, 12.441) controlPoint2:CGPointMake(16.73, 11.929)];
    [pathPath addCurveToPoint:CGPointMake(13.177, 10.119) controlPoint1:CGPointMake(15.882, 11.188) controlPoint2:CGPointMake(15.538, 10.747)];
    [pathPath addCurveToPoint:CGPointMake(7.885, 9.622) controlPoint1:CGPointMake(9.887, 9.244) controlPoint2:CGPointMake(8.953, 9.954)];
    [pathPath addLineToPoint:CGPointMake(11.645, 4.648)];
    [pathPath addCurveToPoint:CGPointMake(21.029, 4.581) controlPoint1:CGPointMake(13.991, 4.631) controlPoint2:CGPointMake(18.683, 4.597)];
    [pathPath addCurveToPoint:CGPointMake(22.441, 4.571) controlPoint1:CGPointMake(21.382, 4.578) controlPoint2:CGPointMake(22.088, 4.573)];
    [pathPath addLineToPoint:CGPointMake(25.263, 0)];
    [pathPath moveToPoint:CGPointMake(3.956, 23.419)];
    [pathPath addLineToPoint:CGPointMake(0, 24.199)];
    [pathPath addCurveToPoint:CGPointMake(1.272, 27.784) controlPoint1:CGPointMake(0.067, 24.251) controlPoint2:CGPointMake(0.233, 26.147)];
    [pathPath addCurveToPoint:CGPointMake(5.689, 31.9) controlPoint1:CGPointMake(2.457, 29.654) controlPoint2:CGPointMake(4.587, 31.323)];
    [pathPath addCurveToPoint:CGPointMake(18.933, 29.497) controlPoint1:CGPointMake(11.892, 35.152) controlPoint2:CGPointMake(17.061, 31.52)];
    [pathPath addCurveToPoint:CGPointMake(22.256, 21.316) controlPoint1:CGPointMake(21.351, 26.883) controlPoint2:CGPointMake(22.131, 22.037)];
    [pathPath addCurveToPoint:CGPointMake(23.66, 16.903) controlPoint1:CGPointMake(22.576, 19.463) controlPoint2:CGPointMake(22.925, 17.825)];
    [pathPath addCurveToPoint:CGPointMake(27.678, 14.738) controlPoint1:CGPointMake(24.261, 16.151) controlPoint2:CGPointMake(25.895, 15.043)];
    [pathPath addCurveToPoint:CGPointMake(31.264, 15.039) controlPoint1:CGPointMake(29.263, 14.468) controlPoint2:CGPointMake(31.034, 14.954)];
    [pathPath addCurveToPoint:CGPointMake(35.678, 20.509) controlPoint1:CGPointMake(34.617, 16.272) controlPoint2:CGPointMake(35.456, 19.237)];
    [pathPath addCurveToPoint:CGPointMake(29.714, 29.029) controlPoint1:CGPointMake(36.485, 25.125) controlPoint2:CGPointMake(33.635, 28.676)];
    [pathPath addCurveToPoint:CGPointMake(23.283, 25.919) controlPoint1:CGPointMake(25.191, 29.437) controlPoint2:CGPointMake(23.525, 25.899)];
    [pathPath addCurveToPoint:CGPointMake(20.89, 30.387) controlPoint1:CGPointMake(22.141, 28.073) controlPoint2:CGPointMake(20.826, 29.446)];
    [pathPath addCurveToPoint:CGPointMake(22.057, 31.647) controlPoint1:CGPointMake(20.925, 30.901) controlPoint2:CGPointMake(21.536, 31.077)];
    [pathPath addCurveToPoint:CGPointMake(25.576, 33.101) controlPoint1:CGPointMake(22.579, 32.217) controlPoint2:CGPointMake(24.089, 32.705)];
    [pathPath addCurveToPoint:CGPointMake(28.847, 33.622) controlPoint1:CGPointMake(27.089, 33.504) controlPoint2:CGPointMake(28.34, 33.392)];
    [pathPath addLineToPoint:CGPointMake(20.89, 44.782)];
    [pathPath addLineToPoint:CGPointMake(26.507, 45)];
    [pathPath addLineToPoint:CGPointMake(37.957, 29.029)];
    [pathPath addCurveToPoint:CGPointMake(39.404, 25.919) controlPoint1:CGPointMake(38.013, 28.84) controlPoint2:CGPointMake(38.995, 27.102)];
    [pathPath addCurveToPoint:CGPointMake(39.993, 21.316) controlPoint1:CGPointMake(39.936, 24.38) controlPoint2:CGPointMake(39.924, 23.175)];
    [pathPath addCurveToPoint:CGPointMake(37.957, 14.569) controlPoint1:CGPointMake(40.116, 17.994) controlPoint2:CGPointMake(38.573, 15.372)];
    [pathPath addCurveToPoint:CGPointMake(33.577, 11.133) controlPoint1:CGPointMake(36.438, 12.59) controlPoint2:CGPointMake(34.235, 11.398)];
    [pathPath addCurveToPoint:CGPointMake(24.75, 11.133) controlPoint1:CGPointMake(30.284, 9.811) controlPoint2:CGPointMake(25.897, 10.716)];
    [pathPath addCurveToPoint:CGPointMake(19.579, 15.747) controlPoint1:CGPointMake(21.631, 12.267) controlPoint2:CGPointMake(20.141, 14.78)];
    [pathPath addCurveToPoint:CGPointMake(18.446, 18.929) controlPoint1:CGPointMake(19.242, 16.326) controlPoint2:CGPointMake(18.775, 17.472)];
    [pathPath addCurveToPoint:CGPointMake(17.964, 22.427) controlPoint1:CGPointMake(18.181, 20.104) controlPoint2:CGPointMake(18.247, 20.862)];
    [pathPath addCurveToPoint:CGPointMake(10.198, 28.518) controlPoint1:CGPointMake(17.681, 23.993) controlPoint2:CGPointMake(15.21, 28.911)];
    [pathPath addCurveToPoint:CGPointMake(3.956, 23.419) controlPoint1:CGPointMake(5.186, 28.124) controlPoint2:CGPointMake(3.987, 23.447)];
    
    return pathPath;
}

- (UIBezierPath*)ballPath{
    UIBezierPath*  ballPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 14, 14)];
    return ballPath;
}

- (UIBezierPath*)rightpathPath{
    UIBezierPath *rightpathPath = [UIBezierPath bezierPath];
    [rightpathPath moveToPoint:CGPointMake(SCREEN_WIDTH/2, 85)];
    [rightpathPath addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH/2 + 100, 100) controlPoint:CGPointMake(SCREEN_WIDTH/2 + 30, 30)];
    return rightpathPath;
}

- (UIBezierPath*)leftpathPath{
    UIBezierPath *leftpathPath = [UIBezierPath bezierPath];
    [leftpathPath moveToPoint:CGPointMake(SCREEN_WIDTH/2, 85)];
    [leftpathPath addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH/2 - 100, 100) controlPoint:CGPointMake(SCREEN_WIDTH/2 - 30, 30)];
    return leftpathPath;
}


- (CGFloat)maxDurationFromAnimations:(NSArray*)anims{
    CGFloat maxDuration = 0;
    for (CAAnimation *anim in anims) {
        maxDuration = MAX(anim.beginTime + anim.duration * (CGFloat)(anim.repeatCount == 0 ? 1.0f : anim.repeatCount) * (anim.autoreverses ? 2.0f : 1.0f), maxDuration);
    }
    if (maxDuration == INFINITY) {
        maxDuration = 1000.0f;
    }
    
    return maxDuration;
}



#pragma mark -
-(void)setTopRefreshStatus:(REFRESH_STATUS)topRefreshStatus
{
    if(_topRefreshStatus == topRefreshStatus) {
        return;
    }
    switch (topRefreshStatus) {
        case REFRESH_STATUS_NORMAL: {
            [UIView animateWithDuration:0.25 animations:^{
                [self.parentScrollView setContentInset:UIEdgeInsetsZero];
                [self.parentScrollView setScrollEnabled:YES];
            }];
            [self showNormal];
        }
            break;
        case REFRESH_STATUS_BEFORE_REFRESH: {
            [self showBeforeRefresh];
        }
            break;
            
        case REFRESH_STATUS_REFRESHING: {
            [UIView animateWithDuration:0.25 animations:^{
                self.parentScrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
                self.parentScrollView.scrollEnabled = NO;
            }];
            [self showRefreshing];
        }
            break;
        default:
            break;
    }
    _topRefreshStatus = topRefreshStatus;
}


- (void)adjustStatusByTop:(float) y
{
    if(self.parentScrollView.isDragging) {

        self.greenPathLayer.strokeEnd  = fabs(y / CGRectGetHeight(self.frame)*0.4) ;
        self.redPathLayer.strokeEnd    = fabs((y + 5) / CGRectGetHeight(self.frame)*0.4) ;
        self.yellowPathLayer.strokeEnd = fabs((y + 10) / CGRectGetHeight(self.frame)*0.4) ;
        self.bluePathLayer.strokeEnd   = fabs((y + 15) / CGRectGetHeight(self.frame)*0.4) ;
        
        if(y + 20 <= self.frame.origin.y) {
            self.topRefreshStatus = REFRESH_STATUS_BEFORE_REFRESH;
        } else {
            self.topRefreshStatus = REFRESH_STATUS_NORMAL;
        }
    } else {
        if(y + 20 <= self.frame.origin.y) {
            self.topRefreshStatus = REFRESH_STATUS_REFRESHING;
        }
    }
}


-(void)showBeforeRefresh
{
 
}

-(void)showNormal
{
}

-(void)showRefreshing
{
    [self startAllAnimations:nil];
    if (self.refreshingCallback) {
        self.refreshingCallback();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.topRefreshStatus = REFRESH_STATUS_NORMAL;
        
        [self.greenPathLayer removeAllAnimations];
        [self.redPathLayer removeAllAnimations];
        [self.yellowPathLayer removeAllAnimations];
        [self.bluePathLayer removeAllAnimations];
        
        [self.ball removeAllAnimations];
        [self.ball1 removeAllAnimations];
        [self.ball2 removeAllAnimations];
        [self.ball3 removeAllAnimations];
        
    }
}




@end