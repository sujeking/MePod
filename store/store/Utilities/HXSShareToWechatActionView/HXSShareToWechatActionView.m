//
//  HXSShareToWechatActionView.m
//  store
//
//  Created by ArthurWang on 15/9/18.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSShareToWechatActionView.h"

#import "HXSBoxOrderEntity.h"
#import "HXSRaffleView.h"
#import "HXSBlurImageView.h"


@interface HXSShareToWechatActionView ()

@property (nonatomic, copy) void (^block)(BOOL finished, BOOL timeline);

@property (nonatomic, strong) HXSRaffleView *raffleView;
@property (nonatomic, strong) HXSBlurImageView *backgroundView;


@end

@implementation HXSShareToWechatActionView

#pragma mark - Initial Methods

- (instancetype)initShareToWechatView:(void (^)(BOOL, BOOL))finished
{
    self = [super init];
    if (self) {
        self.block          = finished;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:[UIScreen mainScreen].bounds];
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        [window addSubview:self];
    }
    
    return self;
}

- (void)dealloc
{
    self.block = nil;
}


#pragma mark - Setter Getter Methods

- (HXSRaffleView *)raffleView
{
    if (nil == _raffleView) {
        _raffleView = [[[NSBundle mainBundle] loadNibNamed:@"HXSRaffleView"
                                                     owner:self
                                                   options:nil] firstObject];
        
        [_raffleView.wechatBtn addTarget:self
                                  action:@selector(onClickWechatBtn:)
                        forControlEvents:UIControlEventTouchUpInside];
        [_raffleView.friendsBtn addTarget:self
                                   action:@selector(onClickFriendsBtn:)
                         forControlEvents:UIControlEventTouchUpInside];
        [_raffleView.cancelBtn addTarget:self
                                  action:@selector(onClickCancelBtn:)
                        forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissRaffleView)];
        [_raffleView addGestureRecognizer:tap];
    }
    
    return _raffleView;
}


#pragma mark - Public Methods

- (void)start
{
    [self displayRaffleView];
}

- (void)end
{
    [self removeFromSuperview];
}

- (void)finishShareToWechat:(BOOL)success timeline:(BOOL)timeline
{
    self.block(success, timeline);
    
    [self end];
}


#pragma mark - Target Methods

- (void)onClickWechatBtn:(UIButton *)button
{
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [self.raffleView removeFromSuperview];
    
    [self finishShareToWechat:YES timeline:NO];
}

- (void)onClickFriendsBtn:(UIButton *)button
{
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [self.raffleView removeFromSuperview];
    
    [self finishShareToWechat:YES timeline:YES];
}

- (void)onClickCancelBtn:(UIButton *)button
{
    [self dismissRaffleView];
}


#pragma mark - Raffle View Animation

- (void)displayRaffleView
{
    // create a blur background view under box oder pay view
    [self createBlurBackGroundView];
    
    CGRect frame = self.raffleView.frame;
    frame.origin.y = frame.size.height;
    self.raffleView.frame = frame;
    
    [self addSubview:self.raffleView];
    [self.raffleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backgroundView setAlpha:0.0];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         CGRect frame = self.raffleView.frame;
                         frame.origin.y = 0;
                         self.raffleView.frame = frame;
                         [self.backgroundView setAlpha:1.0];
                     } completion:nil];
}

- (void)dismissRaffleView
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect frame = self.raffleView.frame;
                         frame.origin.y = frame.size.height;
                         self.raffleView.frame = frame;
                         [self.backgroundView setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [self.backgroundView removeFromSuperview];
                         self.backgroundView = nil;
                         [self.raffleView removeFromSuperview];
                         
                         [self finishShareToWechat:NO timeline:NO];
                     }];
}

#pragma mark - Create Blur Background View

- (void)createBlurBackGroundView
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    
    HXSBlurImageView *backgroundImageView = [[HXSBlurImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [backgroundImageView blurSetImage:image];
    
    self.backgroundView = backgroundImageView;
    
    [self addSubview:backgroundImageView];
}




@end
