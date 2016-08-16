//
//  HXSOrderShareInfoView.m
//  store
//
//  Created by hudezhi on 15/9/23.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSOrderActivityInfoView.h"

#import "UIButton+WebCache.h"
#import "HXSShareToWechatActionView.h"
#import "UIImageView+AFNetworking.h"
#import "HXSWebViewController.h"

#import "HXSWXApiManager.h"
#import "AFImageDownloader.h"

static CGFloat kShareInfoButtonWidth = 80;
static NSString *kActionshare = @"share_url";
static NSString *kActionopen = @"open_url";

//========================================================================

@interface HXSOrderShareImageView : UIImageView

@property (nonatomic, strong) HXSOrderActivitInfo *activityInfo;

@end

@implementation HXSOrderShareImageView

@end

//========================================================================

@interface HXSOrderActivityInfoView () {
}
@property (nonatomic, strong) UIImageView *tempImageView;

@end

@implementation HXSOrderActivityInfoView

#pragma mark - Private method

- (HXSOrderShareImageView *)imageViewWithShareInfo:(HXSOrderActivitInfo *)info
{
    HXSOrderShareImageView *shareImageView = [[HXSOrderShareImageView alloc] init];
    [shareImageView setContentMode:UIViewContentModeScaleAspectFit];
    [shareImageView setBackgroundColor:[UIColor clearColor]];
    [shareImageView setUserInteractionEnabled:YES];
    
    NSString *imageUrlText = [info.shareBtnImgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [shareImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlText] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(orderShareImageViewPressed:)];
    
    [shareImageView addGestureRecognizer:tap];
    
    shareImageView.activityInfo = info;
    
    return shareImageView;
}

- (void)orderShareImageViewPressed:(UIGestureRecognizer *)gesture
{
    HXSOrderShareImageView *shareImageView = (HXSOrderShareImageView *)gesture.view;
    HXSOrderActivitInfo *info = shareImageView.activityInfo;
    
    if ([info.action isEqualToString:kActionshare]) {
        [self shareToWeinXinWithInfo:info];
    }
    else if ([info.action isEqualToString:kActionopen]) {
        [self openWebUrlWithInfo:info];
    }
    else {
        DLog(@"------------------- Activity Info, Unknown action type: %@", info.action);
    }
}

- (void)shareToWeinXinWithInfo:(HXSOrderActivitInfo *)info
{
    UIView* superView = self.superview;
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    
    __weak typeof(self) weakSelf = self;
    HXSShareToWechatActionView *shareToWechatView = [[HXSShareToWechatActionView alloc] initShareToWechatView:^(BOOL success, BOOL timeline) {
        if (success) {
            UIImageView *imageView = [[UIImageView alloc] init];
            weakSelf.tempImageView = imageView;
            [MBProgressHUD showInView:superView status:@"获取分享资源..."];
            [weakSelf.tempImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:info.imageUrl]]
                                          placeholderImage:nil
                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                       BEGIN_MAIN_THREAD
                                                       [[UIImageView sharedImageDownloader].imageCache addImage:image
                                                                                                     forRequest:request
                                                                                       withAdditionalIdentifier:[request.URL absoluteString]];
                                                       [MBProgressHUD hideHUDForView: superView animated:YES];
                                                       [[HXSWXApiManager sharedManager] shareAppToWeixin:timeline
                                                                                        withActivityInfo:info
                                                                                                   image:image callback:nil];
                                                       END_MAIN_THREAD
                                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                       BEGIN_MAIN_THREAD
                                                       [MBProgressHUD hideHUDForView:superView animated:YES];
                                                       [MBProgressHUD showInViewWithoutIndicator:superView status:@"获取资源失败" afterDelay:1.0f];
                                                       END_MAIN_THREAD
                                                   }];
        }
    }];
    
    [shareToWechatView start];
}

- (void)openWebUrlWithInfo:(HXSOrderActivitInfo *)info
{
    HXSWebViewController *webVCtrl = [HXSWebViewController controllerFromXib];
    NSString *urlText = info.url;
    
    webVCtrl.url = [NSURL URLWithString:urlText];
    webVCtrl.title = info.title;
    
    RootViewController *tabRootCtrl = [AppDelegate sharedDelegate].rootViewController;
    UINavigationController *nav = tabRootCtrl.currentNavigationController;
    
    if (nav) {
        [nav pushViewController:webVCtrl animated:YES];
    }
    else {
        DLog(@"-------------- Current UIViewController doesn't have a NavigationController.");
    }
}

#pragma mark - Public method

- (void)showActivityInfos:(NSArray *)shareInfos inView:(UIView *)view
{
    [self showActivityInfos:shareInfos inView:view bottomSpace:0];
}

- (void)showActivityInfos:(NSArray *)shareInfos inView:(UIView *)view bottomSpace:(CGFloat)bottomSpace
{
    for (UIView *aView in self.subviews) {
        [aView removeFromSuperview];
    }
    [self removeFromSuperview];
    self.frame = CGRectMake(0, 0, 1, 1);
    
    if (view.width <= kShareInfoButtonWidth) {
        DLog(@"------- HXSOrderShareInfoView: the width of view is not enough to containe shareInfos");
        return;
    }
    
    if ((view == self) || (shareInfos.count < 1)) {
        return;
    }
    
    NSInteger columns = view.width/kShareInfoButtonWidth;
    CGFloat paddings = (view.width - columns*kShareInfoButtonWidth)/(columns + 1);
    NSInteger rows = (shareInfos.count + columns - 1)/columns;
    
    CGFloat height = rows*kShareInfoButtonWidth + (rows + 1)*paddings;
    DLog(@"-------------------- ShareInfo Height: %f", height);
    
    if (view.height < height) {
        DLog(@"------- HXSOrderShareInfoView: the height of view is not enough to containe shareInfos");
        return;
    }
    
    NSInteger btnCount = shareInfos.count;
    for (int i = 0 ; i < btnCount ; i++) {
        HXSOrderActivitInfo *info = shareInfos[i];
        HXSOrderShareImageView *shareImageView = [self imageViewWithShareInfo:info];
        
        NSInteger rowIdx = i/columns;
        NSInteger columnIdx = i%columns;
        
        CGFloat x = paddings + columnIdx*(kShareInfoButtonWidth + paddings);
        CGFloat y = paddings + rowIdx*(kShareInfoButtonWidth + paddings);
        
        if (shareInfos.count >= columns) {
            shareImageView.frame = CGRectMake(view.width - x - kShareInfoButtonWidth, height - y - kShareInfoButtonWidth, kShareInfoButtonWidth, kShareInfoButtonWidth);
        }
        else {
            shareImageView.frame = CGRectMake(x, height - y - kShareInfoButtonWidth, kShareInfoButtonWidth, kShareInfoButtonWidth);
        }
        [self addSubview:shareImageView];
    }
    
    CGFloat width;
    CGFloat x;
    if (shareInfos.count >= columns) {
        x = 0;
        width = columns*(kShareInfoButtonWidth + paddings) + paddings;
    }
    else {
        width = shareInfos.count*(kShareInfoButtonWidth + paddings) + paddings;
        x = view.width - width;
    }
    
    self.frame = CGRectMake(x, view.height, width, height);
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(x, view.height - height - bottomSpace, width, height);
    }];
}

@end
