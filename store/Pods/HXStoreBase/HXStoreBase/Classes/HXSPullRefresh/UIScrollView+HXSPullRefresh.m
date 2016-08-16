//
//  UIScrollView+HXSPullRefresh.m
//  store
//
//  Created by J006 on 16/6/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "UIScrollView+HXSPullRefresh.h"

#import "HXAppDeviceHelper.h"
#import "HXMacrosUtils.h"

@interface UIScrollView()

@property (nonatomic, weak) HXSPullRefreshImageView *topShowView;

@end

@implementation UIScrollView (HXSPullRefresh)

#pragma mark - run time
static char HXSRefreshHeaderViewKey;

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark init

- (FLAnimatedImageView *)createTheBallImageView
{
    FLAnimatedImageView *loadIngImageView = [[FLAnimatedImageView alloc] init];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreBase" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    NSString* gifPath      = [bundle pathForResource:@"59TopLoading"
                                              ofType:@"gif"];
    NSData *data           = [NSData dataWithContentsOfFile:gifPath];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    loadIngImageView.animatedImage = image;
    [loadIngImageView setHidden:YES];
    
    return loadIngImageView;
}

- (void)initTheProgressImageView
{
    if (self.topShowView)
    {
        return;
    }
    
    HXSPullRefreshImageView *headerView = nil;
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        headerView = [[HXSPullRefreshImageView alloc]initWithFrame:CGRectMake(0, -pullBallHeight, SCREEN_WIDTH, pullTopViewHeight)];
    } else {
        headerView = [[HXSPullRefreshImageView alloc] init];
    }
    
    [headerView setContentMode:UIViewContentModeScaleAspectFit];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreBase" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    NSString *gifPathStr = [bundle pathForResource:@"59TopReFreshBall" ofType:@"gif"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:gifPathStr];
    
    
    [headerView yh_setImage:url];
    headerView.topRefreshStatus = HXSPullRefreshHeaderStateNone;
    headerView.parentScrollView = self;
    [self addSubview:headerView];
    self.topShowView = headerView;
}

#pragma mark Public Methods

- (void)addRefreshHeaderWithCallback:(void (^)())callback
{
    [self initTheProgressImageView];
    self.topShowView.refreshingCallback = callback;
    
    self.loadingImageView = [self createTheBallImageView];
    [self addSubview:self.loadingImageView];
    if(SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        [self.loadingImageView setFrame:CGRectMake(self.topShowView.frame.origin.x + (self.topShowView.frame.size.width - pullBallWidth) / 2, self.topShowView.frame.origin.y, pullBallWidth, pullBallHeight)];
    }
    
    [self.topShowView initLoadingImageView:self.loadingImageView];
}

- (void)beginRefreshing
{
    [self.topShowView beginLoading];
}

- (void)endRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.topShowView.topRefreshStatus = HXSPullRefreshHeaderStateCanFinish;
    });
}

- (void)removeRefreshHeader
{
    if(self.topShowView)
    {
        [self.topShowView removeFromSuperview];
        self.topShowView = nil;
    }
    
    if(self.loadingImageView)
    {
        [self.loadingImageView removeFromSuperview];
        self.loadingImageView = nil;
    }
}

- (void)setLoadMoreProgressImageName:(NSString *)progressImageName
                    LoadingImageName:(NSString *)loadingImageName
{
    self.progressImageName = progressImageName;
    self.loadingImageName  = loadingImageName;
}

#pragma mark getter setter

- (void)setObserver:(id)observer
{
    objc_setAssociatedObject(self, @"observer", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)observer
{
    return objc_getAssociatedObject(self, @"observer");
}

- (void)setTopShowView:(HXSPullRefreshImageView *)topShowView
{
    [self willChangeValueForKey:@"HXSRefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &HXSRefreshHeaderViewKey,
                             topShowView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"HXSRefreshHeaderViewKey"];
}

- (HXSPullRefreshImageView *)topShowView
{
    return objc_getAssociatedObject(self, &HXSRefreshHeaderViewKey);
}

- (void)setLoadingImageView:(FLAnimatedImageView *)loadingImageView
{
    objc_setAssociatedObject(self, @"loadingImageView", loadingImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (FLAnimatedImageView *)loadingImageView
{
    return objc_getAssociatedObject(self, @"loadingImageView");
}

- (void)setProgressImageName:(NSString *)progressImageName
{
    objc_setAssociatedObject(self, @"progressImageName", progressImageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)progressImageName
{
    return objc_getAssociatedObject(self, @"progressImageName");
}

- (void)setLoadingImageName:(NSString *)loadingImageName
{
    objc_setAssociatedObject(self, @"loadingImageName", loadingImageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)loadingImageName
{
    return objc_getAssociatedObject(self, @"loadingImageName");
}


@end
