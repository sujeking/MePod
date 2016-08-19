//
//  statusView.m
//  消息新消息
//
//  Created by  黎明 on 16/8/19.
//  Copyright © 2016年 suzw. All rights reserved.
//

#import "statusView.h"

//左右两边的间距
static CGFloat const padding   = 40;
//状态球的大小【背景】
static CGFloat const pointWith = 30;
//状态球的大小【实心】
static CGFloat const itemWith = 15;

@interface statusView()

@property (nonatomic, strong) CAShapeLayer *line1;
@property (nonatomic, strong) CAShapeLayer *line2;
@property (nonatomic, strong) CALayer      *leftLayer;
@property (nonatomic, strong) CALayer      *middleLayer;
@property (nonatomic, strong) CALayer      *rightLayer;
@property (nonatomic, assign) CGColorRef   unColorRef;
@property (nonatomic, assign) CGColorRef   finishColorRef;
@property (nonatomic, strong) NSArray<NSString *> *titles;

@end


@implementation statusView


#pragma mark - Intial Methods

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray <
                                                    NSString *>*)titles
{
    self = [super initWithFrame:frame];
    if(self) {
        
        self.titles = titles;
        self.unColorRef = [[UIColor lightGrayColor] CGColor];
        self.finishColorRef = [[UIColor greenColor] CGColor];
        
        [self setupSubViews];
        
        self.status = BeginStatus;
        self.statusCount = 3;

    }
    return self;
}

- (void)layoutSubviews
{
    if(self.statusCount == 2) {
        [self.layer addSublayer:self.leftLayer];
        [self.layer addSublayer:self.rightLayer];
        
    } else {
        [self.layer addSublayer:self.leftLayer];
        [self.layer addSublayer:self.middleLayer];
        [self.layer addSublayer:self.rightLayer];
    }
    
    [self addTitlLabelWithTitles:self.titles];
}

- (void)setupSubViews
{
    self.leftLayer = [self pointLayer];
    self.leftLayer.position = CGPointMake(padding, self.center.y);
    
    self.middleLayer = [self pointLayer];
    self.middleLayer.position = self.center;
    
    self.rightLayer = [self pointLayer];
    self.rightLayer.position = CGPointMake(CGRectGetWidth(self.bounds) - padding, self.center.y);

    
    CAShapeLayer *bgline = [CAShapeLayer layer];
    bgline.frame       = CGRectMake(self.leftLayer.position.x, 0,
                                    self.rightLayer.position.x - self.leftLayer.position.x, 1);
    bgline.fillColor   = nil;
    bgline.opacity     = 0.3;
    bgline.strokeColor = [UIColor colorWithWhite:0.667 alpha:1.000].CGColor;
    bgline.path        = [self line1PathWithPoint:CGPointMake(bgline.bounds.size.width, 0)].CGPath;
    bgline.position    = CGPointMake(bgline.position.x, self.center.y);

    
    self.line1 = [CAShapeLayer layer];
    self.line1.frame       = CGRectMake(self.leftLayer.position.x, 0,
                                        self.middleLayer.position.x - self.leftLayer.position.x, 1);
    self.line1.fillColor   = nil;
    self.line1.strokeColor = [UIColor greenColor].CGColor;
    self.line1.strokeEnd   = 0;
    self.line1.path        = [self line1PathWithPoint:CGPointMake(self.line1.bounds.size.width, 0)].CGPath;
    self.line1.position    = CGPointMake(self.line1.position.x, self.center.y);
    
    self.line2 = [CAShapeLayer layer];
    self.line2.frame       = CGRectMake(self.middleLayer.position.x, 0,
                                        self.middleLayer.position.x - self.leftLayer.position.x, 1);
    self.line2.fillColor   = nil;
    self.line2.strokeEnd = 0;
    self.line2.strokeColor = [UIColor greenColor].CGColor;
    self.line2.path        = [self line1PathWithPoint:CGPointMake(self.line2.bounds.size.width, 0)].CGPath;
    self.line2.position = CGPointMake(self.line2.position.x, self.center.y);
    
    [self.layer addSublayer:bgline];
    [self.layer addSublayer:self.line1];
    [self.layer addSublayer:self.line2];
}

- (void)show1
{
    [self.line1 addAnimation:[self line1Animation] forKey:@"line1Animation"];
}

- (void)show2
{
    [self.line2 addAnimation:[self line1Animation] forKey:@"line2Animation"];
}


#pragma mark - Action

- (void)addTitlLabelWithTitles:(NSArray<NSString *> *)titles
{
    for(int i = 0; i < self.statusCount; i++) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, 120, 40);
        label.text = titles[i];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        if(i == 0) {
            label.center = CGPointMake(self.leftLayer.position.x, self.center.y + pointWith);
        } else if(i == 1) {
            if(self.statusCount == 2){
                label.center = CGPointMake(self.rightLayer.position.x, self.center.y + pointWith);
                
            } else {
                label.center = CGPointMake(self.middleLayer.position.x, self.center.y + pointWith);
                
            }
        } else {
            label.center = CGPointMake(self.rightLayer.position.x, self.center.y + pointWith);

        }
        
        [self addSubview:label];
        
    }
}


#pragma mark - Get Set Methods

- (CALayer *)pointLayer
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, pointWith, pointWith);
    CAShapeLayer *bglayer = [self bgLayer];
    CAShapeLayer *itemlayer = [self itemLayer];
    itemlayer.position = CGPointMake(pointWith/2, pointWith/2);
    [layer addSublayer:bglayer];
    [layer addSublayer:itemlayer];
    
    return layer;
}

- (CAShapeLayer *)bgLayer
{
    CAShapeLayer * bgLayer = [CAShapeLayer layer];
    bgLayer.anchorPoint    = CGPointMake(0.5, 0.5);
    bgLayer.frame          = CGRectMake(0, 0, pointWith, pointWith);
    bgLayer.opacity        = 0.3;
    bgLayer.fillColor      = [UIColor greenColor].CGColor;
    bgLayer.lineWidth      = 0;
    bgLayer.shadowColor    = [UIColor greenColor].CGColor;
    bgLayer.shadowOpacity  = 1;
    bgLayer.shadowOffset   = CGSizeMake(0, -0);
    bgLayer.name           = @"bgLayer";
    bgLayer.path           = [self bgLayerPath].CGPath;
    
    return bgLayer;
}

- (CAShapeLayer *)itemLayer
{
    CAShapeLayer * itemLayer = [CAShapeLayer layer];
    itemLayer.anchorPoint    = CGPointMake(0.5, 0.5);
    itemLayer.frame          = CGRectMake(0, 0, itemWith, itemWith);
    itemLayer.fillColor      = [UIColor greenColor].CGColor;
    itemLayer.lineWidth      = 0;
    itemLayer.shadowColor    = [UIColor greenColor].CGColor;
    itemLayer.shadowOpacity  = 1;
    itemLayer.name           = @"itemLayer";
    itemLayer.shadowOffset   = CGSizeMake(0, -0);
    itemLayer.path           = [self itemLayerPath].CGPath;
    
    return itemLayer;
}

- (UIBezierPath*)bgLayerPath
{
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, pointWith, pointWith)];
    return ovalPath;
}

- (UIBezierPath*)itemLayerPath
{
    UIBezierPath*  oval2Path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, itemWith, itemWith)];
    return oval2Path;
}

- (UIBezierPath*)line1PathWithPoint:(CGPoint)point
{
    UIBezierPath *line1Path = [UIBezierPath bezierPath];
    [line1Path moveToPoint:CGPointMake(0, 0)];
    [line1Path addLineToPoint:CGPointMake(point.x, 0)];
    
    return line1Path;
}

- (CABasicAnimation*)line1Animation
{
    CABasicAnimation * strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue          = @0;
    strokeEndAnim.toValue            = @1;
    strokeEndAnim.duration           = 0.5;
    strokeEndAnim.delegate = self;
    strokeEndAnim.fillMode = kCAFillModeForwards;
    strokeEndAnim.removedOnCompletion = NO;
    
    return strokeEndAnim;
}

- (CABasicAnimation*)resetAnimation
{
    CABasicAnimation * strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue          = @1;
    strokeEndAnim.toValue            = @0;
    strokeEndAnim.duration           = 0;
    strokeEndAnim.fillMode = kCAFillModeForwards;
    strokeEndAnim.removedOnCompletion = NO;
    
    return strokeEndAnim;
}

- (void)setDoneStatusColor:(CALayer *)layer
{
    for(CAShapeLayer *shapeLayer in layer.sublayers) {
        shapeLayer.fillColor = self.finishColorRef;
        shapeLayer.shadowColor = self.finishColorRef;
        if([shapeLayer.name isEqualToString:@"itemLayer"]) {
            shapeLayer.opacity = 1;
        }

    }
}

- (void)setUnfinishedStatusColor:(CALayer *)layer
{
    for(CAShapeLayer *shapeLayer in layer.sublayers) {
        shapeLayer.fillColor = self.unColorRef;
        shapeLayer.shadowColor = self.unColorRef;
        if([shapeLayer.name isEqualToString:@"itemLayer"]) {
            shapeLayer.opacity = 0;
        }
    }
}

- (void)setStatus:(Status)status
{
    _status = status;
    
    switch (status) {
        case BeginStatus: {
            [self.line1 addAnimation:[self resetAnimation] forKey:@"kkk"];
            [self.line2 addAnimation:[self resetAnimation] forKey:@"kkk2"];
            
            [self setDoneStatusColor:self.leftLayer];
            [self setUnfinishedStatusColor:self.middleLayer];
            [self setUnfinishedStatusColor:self.rightLayer];
        }
            break;
        case DealingStatus: {
            if(self.statusCount == 2) {
                self.status = EndStatus;
            } else {
                [self show1];
            }
        }
            break;
            
        case EndStatus: {
            if(self.statusCount == 2) {
                [self show1];
            } else {
                [self show2];
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - AnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([self.line1 animationForKey:@"line1Animation"] == anim) {
        
        [self setDoneStatusColor:self.leftLayer];
        [self setDoneStatusColor:self.middleLayer];
        [self setUnfinishedStatusColor:self.rightLayer];
        
        if(self.statusCount == 2) {
            [self show2];
        }
        
    } else if([self.line2 animationForKey:@"line2Animation"] == anim) {
        [self setDoneStatusColor:self.leftLayer];
        [self setDoneStatusColor:self.middleLayer];
        [self setDoneStatusColor:self.rightLayer];
    }
}

@end
