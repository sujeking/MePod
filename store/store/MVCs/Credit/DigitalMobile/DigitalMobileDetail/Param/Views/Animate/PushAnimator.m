//
//  PushAnimator.m
//  RecordTechnology
//
//  Created by ArthurWang on 16/1/29.
//  Copyright © 2016年 InSigma HengTian Softwar Ltd. All rights reserved.
//

#import "PushAnimator.h"

@interface PushAnimator ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, weak) UIViewController *toViewController;
@property (nonatomic, weak) UIView           *containerView;

@end

@implementation PushAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.containerView = [transitionContext containerView];
    self.transitionContext = transitionContext;
    
    UIView *toView = self.toViewController.view;
    toView.y = [UIScreen mainScreen].bounds.size.height;
    toView.width = [UIScreen mainScreen].bounds.size.width;
    toView.height = [UIScreen mainScreen].bounds.size.height;

    [self.containerView addSubview:toView];
    
    UIView *fromView = self.fromViewController.view;
    [fromView setAlpha:0.7];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         toView.y = [UIScreen mainScreen].bounds.size.height - toView.height;
                     } completion:^(BOOL finished) {
                         [weakSelf.transitionContext completeTransition:![weakSelf.transitionContext transitionWasCancelled]];
                     }];
}

@end
