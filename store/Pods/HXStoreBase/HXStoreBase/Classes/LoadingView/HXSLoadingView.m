//
//  HXSLoadingView.m
//  store
//
//  Created by ArthurWang on 15/8/10.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSLoadingView.h"

#import "HXSLoadingAnimation.h"
#import "HXSLoadFailureView.h"
#import "HXMacrosUtils.h"
#import "UIView+Extension.h"
#import "Masonry.h"

#define LoadRegionSize(s) (s * ([UIScreen mainScreen].scale >= 3.0 ? 1.15 : 1))

@interface HXSLoadingView ()

@property (nonatomic, strong) UIView *dialogView;

@property (nonatomic, assign) BOOL isAnimationing;
@property (nonatomic, copy)   void(^loadingBlock)(void);

@end

@implementation HXSLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.isAnimationing = NO;
    }
    return self;
}

#pragma mark - Setter Getter Methods

- (void)setDialogView:(UIView *)dialogView
{
    if (nil != _dialogView) {
        
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        self.dialogView.layer.transform = CATransform3DConcat(self.dialogView.layer.transform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
        self.dialogView.layer.opacity = 0.0f;
        
        [self.dialogView removeFromSuperview];

    }
    
    _dialogView = nil;
    _dialogView = dialogView;
}

#pragma mark - Public Methods

+ (void)showLoadingInView:(UIView *)view
{
    HXSLoadingView *shareInstance = [HXSLoadingView createLoadingViewInView:view];
    
    [shareInstance showLoading];
}

+ (void)showLoadFailInView:(UIView *)view block:(void (^)(void))block
{
    HXSLoadingView *shareInstance = [HXSLoadingView createLoadingViewInView:view];
    
    [shareInstance showLoadFail:block];
}

+ (void)closeInView:(UIView *)view
{
    HXSLoadingView *shareInstance = [HXSLoadingView findLoadingViewInView:view];
    
    [shareInstance close];
}

+ (void)closeInView:(UIView *)view after:(NSTimeInterval)time
{
    HXSLoadingView *shareInstance = [HXSLoadingView findLoadingViewInView:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shareInstance close];
    });
}

+ (BOOL)isShowingLoadingViewInView:(UIView *)view
{
    HXSLoadingView *shareInstance = [HXSLoadingView findLoadingViewInView:view];
    
    return (nil == shareInstance) ? NO : YES;
}


#pragma mark - Setter Getter Methods

- (UIView *)loadingView
{
    CGFloat loadViewWH = LoadRegionSize(54);
    UIView *loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, loadViewWH, loadViewWH)];
    [self addSubview:loadView];
    
    id <HXSLoadingAnimaitonProtocol> animation = [[HXSLoadingAnimation alloc] init];
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:)]) {
        [animation setupAnimationInLayer:loadView.layer withSize:loadView.bounds.size];
        loadView.layer.speed = 1.0; // start animation
    }
    return loadView;
    
}

- (UIView *)loadFailView
{
    int width = 180;
    int height = 200;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)]; // frame is image view's frame and label's frame
    view.backgroundColor = [UIColor clearColor];
    UIImageView *loadingFailImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_kong_wodehuifu"]];
    
    [view addSubview:loadingFailImageView];
    
    [loadingFailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.centerX.equalTo(view);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(140);
    }];
    
    UILabel *label = [[UILabel alloc] init];

    label.text = @"加载失败了...";
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textColor = HXS_INFO_NOMARL_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    // 创建加载失败视图
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loadingFailImageView.mas_bottom).offset(15);
        make.centerX.equalTo(view);
    }];

    
    return view;
}

#pragma mark - Private Methods

+ (instancetype)createLoadingViewInView:(UIView *)view
{
    UIView *superLoadingView = nil;
    
    if (nil == view) {
        UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
        
        superLoadingView = window;
    } else {
        superLoadingView = view;
    }
    
    for (UIView *subView in [superLoadingView subviews]) {
        if ([subView isKindOfClass:self]) {
            [subView removeFromSuperview];
        }
    }
    
    HXSLoadingView *shareInstance = [[HXSLoadingView alloc] initWithFrame:CGRectMake(0, 0, superLoadingView.width, superLoadingView.height)];
    
    [superLoadingView addSubview:shareInstance];
    
    [shareInstance mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superLoadingView);
    }];
    
    return shareInstance;
}

+ (instancetype)findLoadingViewInView:(UIView *)view
{
    HXSLoadingView *shareInstance = nil;
    
    for (UIView *subView in [view subviews]) {
        if ([subView isKindOfClass:self]) {
            shareInstance = (HXSLoadingView *)subView;
            
            break;
        }
    }
    
    if (nil == shareInstance) {
        UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
        
        for (UIView *subView in [window subviews]) {
            if ([subView isKindOfClass:self]) {
                shareInstance = (HXSLoadingView *)subView;
                
                break;
            }
        }
    }
    return shareInstance;
}

- (void)showLoading
{
    self.dialogView = [self loadingView];
    
    self.isAnimationing = YES;
    
    [self show];
    
}

- (void)showLoadFail:(void (^)(void))block
{
    self.loadingBlock = block;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(runBlock)];
    
    [self addGestureRecognizer:tap];
    
    self.dialogView = [self loadFailView];
    
    self.isAnimationing = YES;
    
    [self show];
}

- (void)show
{
    self.dialogView.layer.shouldRasterize = YES;
    self.dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.dialogView.center = self.center;
    
    [self addSubview:self.dialogView];
    
    [self.dialogView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.dialogView.frame.size);
        make.center.equalTo(self);
    }];
    
    self.dialogView.layer.opacity = 0.5f;
    self.dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.dialogView.layer.opacity = 1.0f;
                         self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
}

- (void)close
{
    if (!self.isAnimationing) {
        return;
    }
    
    self.isAnimationing = NO;
    
    if (nil == self.superview) {
        return;
    }
    
    self.loadingBlock = nil;
    
    CATransform3D currentTransform = self.dialogView.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[self.dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    self.dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [self.dialogView removeFromSuperview];
                         self.dialogView = nil;
                     }
     ];
    
}

- (void)runBlock
{
    if (nil == self.loadingBlock) {
        return;
    }
    
    self.loadingBlock();
}



@end
