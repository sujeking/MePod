//
//  UIScrollView+HXSPullRefresh.h
//  store
//
//  Created by J006 on 16/6/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPullRefreshImageView.h"
#import <objc/runtime.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

static CGFloat pullTotalHeight   = 64;
static CGFloat pullTopViewHeight = 44;
static CGFloat pullBallWidth     = 136;
static CGFloat pullBallHeight    = 59;
static CGFloat pullStartHeight   = 15;

@interface UIScrollView (HXSPullRefresh)


@property (nonatomic, strong) NSString                *progressImageName;
@property (nonatomic, strong) NSString                *loadingImageName;
@property (nonatomic, strong) FLAnimatedImageView     *loadingImageView;
@property (nonatomic, strong) id observer;

- (void)addRefreshHeaderWithCallback:(void (^)())callback;

- (void)beginRefreshing;

- (void)endRefreshing;

- (void)removeRefreshHeader;//

/**
 *  传入图片名称
 *
 *  @param progressImageName 跟手gif动画
 *  @param loadingImageName  加载gif动画
 */
- (void)setLoadMoreProgressImageName:(NSString *)progressImageName
                    LoadingImageName:(NSString *)loadingImageName;

@end
