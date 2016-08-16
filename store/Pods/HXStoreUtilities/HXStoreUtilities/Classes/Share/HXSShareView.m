//
//  HXSShareView.m
//  store
//
//  Created by ArthurWang on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShareView.h"

#import "HXSShareDetailView.h"
#import "HXSBlurImageView.h"
#import "HXSSinaWeiboManager.h"
#import "HXSQQSdkManager.h"
#import "HXSWXApiManager.h"
#import "UIImageView+AFNetworking.h"
#import <MBProgressHUD.h>
#import "AFImageDownloader.h"
#import "HXMacrosUtils.h"
#import "Masonry.h"
#import "UIColor+Extensions.h"
#import "MBProgressHUD+HXS.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"

#define TAG_BASIC                    1000
#define HEIGHT_SHARE_BUTTON          45
#define HEIGHT_SHARE_SCROLLER_VIEW   105
#define NUMBER_SHARE_BUTTON_ONE_PAGE 5

@implementation HXSShareParameter


@end


@interface HXSShareView () <UIScrollViewDelegate>

@property (nonatomic, strong) HXSShareDetailView *shareDetailView;
@property (nonatomic, strong) HXSBlurImageView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *shareImage;

@end

@implementation HXSShareView

- (instancetype)initShareViewWithParameter:(HXSShareParameter *)shareParameter callBack:(HXSShareCallbackBlock)callBack
{
    self = [super init];
    if (nil != self) {
        self.shareParameter = shareParameter;
        self.shareCallBack = callBack;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:[UIScreen mainScreen].bounds];
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        [window addSubview:self];
    }
    
    return self;
}

- (void)dealloc
{
    self.shareParameter = nil;
    self.shareDetailView.scrollView.delegate = nil;
    self.shareCallBack = nil;
}


#pragma mark - Setter Getter Methods

- (HXSShareDetailView *)shareDetailView
{
    if (nil == _shareDetailView) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *bundlePath = [bundle pathForResource:@"Share" ofType:@"bundle"];
        if (bundlePath) {
            bundle = [NSBundle bundleWithPath:bundlePath];
        }
        
        _shareDetailView = [[bundle loadNibNamed:NSStringFromClass([HXSShareDetailView class])
                                           owner:self
                                         options:nil] firstObject];
        
        _shareDetailView.scrollView.delegate = self;
        
        [_shareDetailView.cancelBtn addTarget:self
                                       action:@selector(onClickCancelBtn:)
                             forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissShareDetailView)];
        [_shareDetailView addGestureRecognizer:tap];
    }
    
    return _shareDetailView;
}

- (void)initialShareButtons
{
    if (0 >= [self.shareParameter.shareTypeArr count]) {
        return; // Don't display anything
    }
    
    for (UIView *view in [self.shareDetailView.scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    UIView *lastView = nil;
    for (int i = 0; i < [self.shareParameter.shareTypeArr count]; i++) {
        NSNumber *shareTypeNum = [self.shareParameter.shareTypeArr objectAtIndex:i];
        
        UIView *view = [self createViewWithShareType:[shareTypeNum integerValue]];
        CGFloat width = SCREEN_WIDTH / NUMBER_SHARE_BUTTON_ONE_PAGE;
        
        [self.shareDetailView.scrollView addSubview:view];
        
        if (0 == i) { // first one
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(HEIGHT_SHARE_SCROLLER_VIEW);
                make.top.left.bottom.equalTo(self.shareDetailView.scrollView);
            }];
            
            lastView = view;
        } else if (([self.shareParameter.shareTypeArr count] - 1) == i)  {// last one
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(HEIGHT_SHARE_SCROLLER_VIEW);
                make.left.mas_equalTo(lastView.mas_right).mas_offset(0);
                make.top.bottom.right.mas_equalTo(self.shareDetailView.scrollView);
            }];
            
            lastView = nil;
        } else {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(HEIGHT_SHARE_SCROLLER_VIEW);
                make.left.mas_equalTo(lastView.mas_right).mas_offset(0);
                make.top.bottom.mas_equalTo(self.shareDetailView.scrollView);
            }];
            
            lastView = view;
        }
        
        [self.shareDetailView.scrollView layoutIfNeeded];
    }
}

- (UIImageView *)imageView
{
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}


#pragma mark - Create Share Views

- (UIView *)createViewWithShareType:(HXSShareType)shareType
{
    // create share view
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor colorWithRGBHex:0xF1F2F4]];
    
    // button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[self imageOfShareType:shareType] forState:UIControlStateNormal];
    button.tag = shareType + TAG_BASIC;
    [button addTarget:self
               action:@selector(onClickShareBtn:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.width.height.mas_equalTo(HEIGHT_SHARE_BUTTON);
        make.top.mas_equalTo(view.mas_top).mas_offset(17);
    }];
    
    // title
    UILabel *label = [[UILabel alloc] init];
    label.text = [self titleOfShareType:shareType];
    label.textColor = [UIColor colorWithRGBHex:0x999999];
    label.font = [UIFont systemFontOfSize:12.0f];
    
    [view addSubview:label];
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.top.mas_equalTo(button.mas_bottom).mas_offset(10);
    }];
    
    return view;
}

- (NSString *)titleOfShareType:(HXSShareType)shareType
{
    switch (shareType) {
        case kHXSShareTypeWechatFriends: return @"微信好友";
            break;
            
        case kHXSShareTypeWechatMoments: return @"朋友圈";
            break;
            
        case kHXSShareTypeSina: return @"新浪微博";
            break;
            
        case kHXSShareTypeMessage: return @"短信";
            break;
            
        case kHXSShareTypeQQMoments: return @"QQ空间";
            break;
            
        case kHXSShareTypeQQFriends: return @"QQ好友";
            break;
        case kHXSShareTypeCopyLink:return @"复制链接";
            break;
        default:
            break;
    }
    
    return nil;
}

- (UIImage *)imageOfShareType:(HXSShareType)shareType
{
    switch (shareType) {
        case kHXSShareTypeWechatFriends: return [UIImage imageNamed:@"ic_share_weixin"];
            break;
            
        case kHXSShareTypeWechatMoments: return [UIImage imageNamed:@"ic_share_pengyouquan"];
            break;
            
        case kHXSShareTypeSina: return [UIImage imageNamed:@"ic_share_weibo"];
            break;
            
        case kHXSShareTypeMessage: return [UIImage imageNamed:@"ic_share_duanxin"];
            break;
            
        case kHXSShareTypeQQMoments: return [UIImage imageNamed:@"ic_share_kongjian"];
            break;
            
        case kHXSShareTypeQQFriends: return [UIImage imageNamed:@"ic_share_qq"];
            break;
        case kHXSShareTypeCopyLink: return [UIImage imageNamed:@"ic_share_copy"];
            break;
        default:
            break;
    }
    
    return nil;
}


#pragma mark - Public Methods

- (void)show
{
    // draw views
    NSInteger count = [self.shareParameter.shareTypeArr count] / NUMBER_SHARE_BUTTON_ONE_PAGE;
    if (0 < ([self.shareParameter.shareTypeArr count] % NUMBER_SHARE_BUTTON_ONE_PAGE)) {
        count++;
    }
    [self.shareDetailView.pageControl setNumberOfPages:count];
    [self initialShareButtons];
    if(!self.shareParameter.imageURLStr)
    {
        [self displayShareDetailView];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self status:@"获取分享资源..."];
    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shareParameter.imageURLStr]]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       BEGIN_MAIN_THREAD                                       
                                       [[UIImageView sharedImageDownloader].imageCache addImage:image
                                                                                     forRequest:request
                                                                       withAdditionalIdentifier:[request.URL absoluteString]];
                                       
                                       [MBProgressHUD hideHUDForView:weakSelf animated:YES];
                                       
                                       NSData *imageData = UIImagePNGRepresentation(image);
                                       if (nil == imageData) {
                                           imageData = UIImageJPEGRepresentation(image, 1);
                                       }
                                       if (32 * 1000 < [imageData length]) { // size is bigger than 32K
                                           UIImage *scaleImage = [image imageByScalingToMaxSize];
                                           weakSelf.shareImage = scaleImage;
                                       } else {
                                           weakSelf.shareImage = image;
                                       }
                                       
                                       [weakSelf displayShareDetailView];
                                       END_MAIN_THREAD
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       BEGIN_MAIN_THREAD
                                       [MBProgressHUD hideHUDForView:weakSelf animated:YES];
                                       [MBProgressHUD showInViewWithoutIndicator:weakSelf status:@"获取资源失败" afterDelay:1.0f];
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           [weakSelf close];
                                       });
                                       END_MAIN_THREAD
                                   }];
    
}

- (void)close
{
    [self removeFromSuperview];
}


#pragma mark - Target Methods

- (void)onClickCancelBtn:(UIButton *)button
{
    [self dismissShareDetailView];
}

- (void)onClickShareBtn:(UIButton *)btn
{
    HXSShareType shareType = btn.tag - TAG_BASIC;
    
    NSString *title = self.shareParameter.titleStr;
    NSString *text = self.shareParameter.textStr;
    UIImage *image = self.shareImage;
    NSString *imageUrl = self.shareParameter.imageURLStr;
    NSString *url = self.shareParameter.shareURLStr;
    
    switch (shareType) {
        case kHXSShareTypeWechatFriends:
        {
            if(![[HXSWXApiManager sharedManager] isWechatInstalled]) {
                [MBProgressHUD showInViewWithoutIndicator:self status:@"您当前没有安装微信" afterDelay:1.5];
                return;
            }
            
            [[HXSWXApiManager sharedManager] shareToWeixinWithTitle:title text:text image:image url:url timeLine:NO callback:self.shareCallBack];
        }
            break;
            
        case kHXSShareTypeWechatMoments:
        {
            if(![[HXSWXApiManager sharedManager] isWechatInstalled]) {
                [MBProgressHUD showInViewWithoutIndicator:self status:@"您当前没有安装微信" afterDelay:1.5];
                return;
            }
            
            [[HXSWXApiManager sharedManager] shareToWeixinWithTitle:text text:text image:image url:url timeLine:YES callback:self.shareCallBack];
        }
            break;
            
        case kHXSShareTypeSina:
        {
            [[HXSSinaWeiboManager sharedManager] shareToWeiboWithText:text image:image callback:self.shareCallBack];
        }
            break;
            
        case kHXSShareTypeMessage:
        {
            // Do nothing
            
        }
            break;
            
        case kHXSShareTypeQQMoments:
        {
            [[HXSQQSdkManager sharedManager] shareToZoneWithTitle:title
                                                             text:text
                                                            image:imageUrl
                                                              url:url callback:self.shareCallBack];
        }
            break;
            
        case kHXSShareTypeQQFriends:
        {
            [[HXSQQSdkManager sharedManager] shareToQQWithTitle:title
                                                           text:text
                                                          image:imageUrl
                                                            url:url callback:self.shareCallBack];
        }
            break;
            
        case kHXSShareTypeCopyLink:
        {
            [self copyShareLink];
        }
            break;
        default:
            break;
    }
    
    [self close];
}

#pragma mark - copy share url Link

//拷贝分享链接到剪贴板
- (void)copyShareLink
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setString:self.shareParameter.shareURLStr];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    hud.labelText = @"复制成功";

    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
}


#pragma mark - Show Detail View

- (void)displayShareDetailView
{
    // create a blur background view under box oder pay view
    [self createBlurBackGroundView];
    
    CGRect frame = self.shareDetailView.frame;
    frame.origin.y = frame.size.height;
    self.shareDetailView.frame = frame;
    
    [self addSubview:self.shareDetailView];
    [self.shareDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backgroundView setAlpha:0.0];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         CGRect frame = self.shareDetailView.frame;
                         frame.origin.y = 0;
                         self.shareDetailView.frame = frame;
                         [self.backgroundView setAlpha:1.0];
                     } completion:nil];
}

- (void)dismissShareDetailView
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect frame = self.shareDetailView.frame;
                         frame.origin.y = frame.size.height;
                         self.shareDetailView.frame = frame;
                         [self.backgroundView setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [self.backgroundView removeFromSuperview];
                         self.backgroundView = nil;
                         [self.shareDetailView removeFromSuperview];
                         
                         [self close];
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


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x < 0) {
        return;
    }
    
    int page = (int)scrollView.contentOffset.x / scrollView.width;
    
    [self.shareDetailView.pageControl setCurrentPage:page];
}

@end
