//
//  HXSCommunityPhotosViewController.m
//  store
//
//  Created by J006 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityPhotosViewController.h"

#import "HXSCustomAlertView.h"
#import "HXSActionSheet.h"
#import "MBProgressHUD+HXS.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface HXSCommunityPhotosViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSURL               *urlString;
@property (nonatomic, strong) UIImageView         *photoItemImageView;
@property (nonatomic, strong) MBProgressHUD       *mbProgHUD;
@property (nonatomic, readwrite) float            progress;
@property (nonatomic, readwrite) BOOL             zoomByDoubleTap;
@property (nonatomic, strong) HXSActionSheet      *actionSheet;

@property (nonatomic, readwrite) NSInteger        receivedSize;
@property (nonatomic, readwrite) NSInteger        expectedSize;

@property (nonatomic, readwrite) NSInteger        type;
@property (nonatomic, readwrite) BOOL             isHasOriginImageView;
@property (nonatomic, strong) HXSCommunitUploadImageEntity *entity;

@end

@implementation HXSCommunityPhotosViewController

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_scrollView  addSubview:self.photoItemImageView];
    [self initTheGesture];
}

- (void)viewDidLayoutSubviews
{
    if(!_isHasOriginImageView)
    {
        [self.photoItemImageView setFrame:self.scrollView.frame];
    }
    [self adjustFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark init

- (void)initHXSCommunityPhotosViewControllerWithEntity:(HXSCommunitUploadImageEntity *)entity
                                           andWithType:(CommunitPhotoBrowserSingleViewType)type
{
    _type = type;
    if(!entity)
        return;
    if(entity.urlStr)
    {
        NSURL *url = [[NSURL alloc]initWithString:entity.urlStr];
        _urlString = url;
    }

    _entity = entity;
}

- (void)setTheOriginImageView:(UIImageView *)imageView
{
    [self.photoItemImageView setImage:imageView.image];
    _isHasOriginImageView = YES;
    [self.photoItemImageView setFrame:[self getFrameInWindow:imageView]];
}

- (void)initTheGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:doubleTap];

    UITapGestureRecognizer *singleTapMBProgHUD = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapMBProgHUD.delaysTouchesBegan = YES;
    singleTapMBProgHUD.numberOfTapsRequired = 1;
    [self.mbProgHUD addGestureRecognizer:singleTapMBProgHUD];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    if (_zoomByDoubleTap)
    {
        CGFloat insetY = (CGRectGetHeight(_scrollView.bounds) - CGRectGetHeight(_photoItemImageView.frame))/2;
        insetY = MAX(insetY, 0.0);
        if (0.5 < ABS(_photoItemImageView.frame.origin.y - insetY))
            [self setY:insetY :_photoItemImageView];
    }
    return _photoItemImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView*)scrollView withView:(UIView*)view atScale:(CGFloat)scale
{
    _zoomByDoubleTap = NO;
    CGFloat insetY = (CGRectGetHeight(_scrollView.bounds) - CGRectGetHeight(_photoItemImageView.frame))/2;
    insetY = MAX(insetY, 0.0);
    if (0.5 < ABS(_photoItemImageView.frame.origin.y - insetY))
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self setY:insetY :_photoItemImageView];
        }];
    }
}

#pragma mark GestureRecognizer

/**
 *  单击回到前一个页面
 *
 *  @param tap
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    if(_type == kCommunitPhotoBrowserSingleViewTypeViewImage)
    {
        __weak typeof(self) weakSelf = self;
        
        CGRect frame = [self getFrameInWindow:_entity.imageView];

        if (self.delegate && [self.delegate respondsToSelector:@selector(noticeTheViewBrowserBGColorTurnClear)])
        {
            [self.delegate noticeTheViewBrowserBGColorTurnClear];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.photoItemImageView setFrame:frame];
            weakSelf.view.alpha = 0.0;
        } completion:^(BOOL finished)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(removeAndBackToMainView)])
            {
                [self.delegate removeAndBackToMainView];
            }
        }];
    }
}

/**
 *  双击放大
 *
 *  @param tap
 */
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    self.zoomByDoubleTap = YES;
    if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    else
    {
        CGPoint touchPoint = [tap locationInView:self.scrollView];
        CGFloat scale = self.scrollView.maximumZoomScale/ self.scrollView.zoomScale;
        CGRect rectTozoom=CGRectMake(touchPoint.x * scale, touchPoint.y * scale, 1, 1);
        [self.scrollView zoomToRect:rectTozoom animated:YES];
    }
}

/**
 *  长按弹出保存图片
 *
 *  @param longPress
 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        [self.actionSheet show];
    }
}

#pragma mark private method

- (void)adjustFrame
{
    if (!_photoItemImageView.image)
        return;
    /*
    UIImage *image = _photoItemImageView.image;
    if(_isHasOriginImageView)//如果是传过来的起始图片
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            _photoItemImageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height - image.size.height*[UIScreen mainScreen].bounds.size.width / image.size.width)/2,
                                                   [UIScreen mainScreen].bounds.size.width,
                                                   image.size.height*[UIScreen mainScreen].bounds.size.width / image.size.width);
            self.view.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        _photoItemImageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height - image.size.height*[UIScreen mainScreen].bounds.size.width / image.size.width)/2,
                                               [UIScreen mainScreen].bounds.size.width,
                                               image.size.height*[UIScreen mainScreen].bounds.size.width / image.size.width);
        self.view.alpha = 1;
    }
     */
     
    
    // 基本尺寸参数
    CGFloat boundsWidth = _scrollView.bounds.size.width;
    CGFloat boundsHeight = _scrollView.bounds.size.height;
    CGFloat imageWidth = _photoItemImageView.image.size.width;
    CGFloat imageHeight = _photoItemImageView.image.size.height;
    // 设置伸缩比例
    CGFloat imageScale = boundsWidth / imageWidth;
    CGFloat minScale = MIN(1.0, imageScale);
    
    CGFloat maxScale = 2.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)])
    {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    
    _scrollView.maximumZoomScale = maxScale;
    _scrollView.minimumZoomScale = minScale;
    _scrollView.zoomScale = minScale;
    
    if(_isHasOriginImageView)//如果是传过来的起始图片
    {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect imageFrame = CGRectMake(0, MAX(0, (boundsHeight- imageHeight*imageScale)/2), boundsWidth, imageHeight *imageScale);
            _photoItemImageView.frame = imageFrame;
        }];
        CGRect imageFrame = CGRectMake(0, MAX(0, (boundsHeight- imageHeight*imageScale)/2), boundsWidth, imageHeight *imageScale);
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(imageFrame), CGRectGetHeight(imageFrame));
    }
    else
    {
        CGRect imageFrame = CGRectMake(0, MAX(0, (boundsHeight- imageHeight*imageScale)/2), boundsWidth, imageHeight *imageScale);
        
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(imageFrame), CGRectGetHeight(imageFrame));
        _photoItemImageView.frame = imageFrame;
    }
    
}

- (void)setY:(CGFloat)yPoint :(UIView*)view
{
    CGRect frame = view.frame;
    frame.origin.y = yPoint;
    view.frame = frame;
}

- (CGRect)getFrameInWindow:(UIView *)view
{
    // 改用[UIApplication sharedApplication].keyWindow.rootViewController.view，防止present新viewController坐标转换不准问题
    return [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

/**
 *  保存图片到本地
 */
- (void)saveThePhotoToLocal
{
    UIImageWriteToSavedPhotosAlbum(_photoItemImageView.image,self,@selector(saveImageCheckWithImage:didFinishSavingWithError:contextInfo:),nil);
}

- (void)saveImageCheckWithImage:(UIImage *)image
       didFinishSavingWithError:(NSError *)error
                    contextInfo:(void *)contextInfo
{
    if(image && !error)
    {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"保存成功" afterDelay:1.5];
    }
    else  if(error)
    {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"保存失败" afterDelay:1.5];
    }
}

#pragma mark getter setter

- (UIImageView *)photoItemImageView
{
    if(!_photoItemImageView)
    {
        _photoItemImageView = [[UIImageView  alloc]init];
        [_photoItemImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_photoItemImageView setClipsToBounds:YES];
        [_photoItemImageView  setBackgroundColor:[UIColor clearColor]];
        [self.mbProgHUD  show:YES];
        
        __weak typeof(self) weakSelf = self;
        [_photoItemImageView  sd_setImageWithURL:_urlString
                                placeholderImage:nil
                                         options:SDWebImageRetryFailed
                                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             weakSelf.receivedSize  = receivedSize;
             weakSelf.expectedSize  = expectedSize;
             weakSelf.mbProgHUD.progress = (float)weakSelf.receivedSize/weakSelf.expectedSize;
             
         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if(image)
             {
                 if(weakSelf.type == kCommunitPhotoBrowserSingleViewTypeViewImage)
                 {
                     UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                                                   action:@selector(handleLongPress:)];
                     [weakSelf.scrollView addGestureRecognizer:longPressGesture];
                 }
                 [weakSelf.view setNeedsLayout];
             }
             [weakSelf.mbProgHUD removeFromSuperview];
         }];
        
    }
    return _photoItemImageView;
}

- (MBProgressHUD *)mbProgHUD
{
    if(!_mbProgHUD)
    {
        _mbProgHUD = [[MBProgressHUD alloc] initWithView:_photoItemImageView];
        [self.view addSubview:_mbProgHUD];
        _mbProgHUD.labelText = @"图片正在加载";
        _mbProgHUD.mode = MBProgressHUDModeAnnularDeterminate;
    }
    return _mbProgHUD;
}

- (HXSActionSheet *)actionSheet
{
    if(!_actionSheet)
    {
        HXSActionSheetEntity *savePhotoEntity = [[HXSActionSheetEntity alloc] init];
        savePhotoEntity.nameStr = @"保存图片";
        
        __weak typeof(self) weakSelf = self;
        HXSAction *savePhotoAction = [HXSAction actionWithMethods:savePhotoEntity
                                                       handler:^(HXSAction *action){
                                                           [weakSelf saveThePhotoToLocal];
                                                       }];
        _actionSheet = [HXSActionSheet actionSheetWithMessage:@""
                                            cancelButtonTitle:@"取消"];
        
        [_actionSheet addAction:savePhotoAction];
        
        if(_type == kCommunitPhotoBrowserSingleViewTypeViewImage)
        {
            HXSActionSheetEntity *reportPhotoEntity = [[HXSActionSheetEntity alloc] init];
            reportPhotoEntity.nameStr = @"举报";
            HXSAction *reportPhotoAction = [HXSAction actionWithMethods:reportPhotoEntity
                                                                handler:^(HXSAction *action){
                                                                    if (weakSelf.delegate
                                                                        && [weakSelf.delegate respondsToSelector:@selector(reportThePhoto)])
                                                                    {
                                                                        [weakSelf.delegate reportThePhoto];
                                                                    }
                                                                }];
            [_actionSheet addAction:reportPhotoAction];
        }
        
    }
    return _actionSheet;
}


@end
