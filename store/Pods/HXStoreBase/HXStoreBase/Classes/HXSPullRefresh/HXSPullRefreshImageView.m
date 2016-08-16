//
//  HXSPullRefreshImageView.m
//  store
//
//  Created by J006 on 16/6/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPullRefreshImageView.h"

#import <ImageIO/ImageIO.h>
#import "HXAppDeviceHelper.h"
#import "Masonry.h"
#import "UIScrollView+HXSPullRefresh.h"
#import "UIView+Extension.h"


@interface HXSPullRefreshImageView()

@property (nonatomic, strong) NSArray             *imageArray;
@property (nonatomic, strong) NSArray             *timeArray;
@property (nonatomic, strong) NSArray             *widths;
@property (nonatomic, strong) NSArray             *heights;
@property (nonatomic, assign) CGFloat             totalTime;
@property (nonatomic, strong) CAKeyframeAnimation *animation;
@property (nonatomic, assign) BOOL                refreshing;
@property (nonatomic, assign) CGFloat             offSetY;
@property (nonatomic, strong) FLAnimatedImageView *loadingImageView;
@property (nonatomic, strong) FLAnimatedImage     *flaImage;

@end

@implementation HXSPullRefreshImageView

#pragma mark life cycle

- (void)layoutSubviews
{
    if(SYSTEM_VERSION_GREATER_THAN(@"8.0"))
    {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.parentScrollView);
            make.right.equalTo(self.parentScrollView);
            make.top.equalTo(self.parentScrollView).offset(-pullTopViewHeight -  pullStartHeight);
            make.centerX.equalTo(self.parentScrollView);
            make.height.mas_equalTo(pullTopViewHeight);
        }];
        
        [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(pullBallWidth);
            make.height.mas_equalTo(pullBallHeight);
        }];
    }
    
    [super layoutSubviews];
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        [self setFrame:CGRectMake(0, -pullBallHeight, self.parentScrollView.width, pullTopViewHeight)];
        [self.loadingImageView setFrame:CGRectMake(0 + (self.width - pullBallWidth) / 2, self.y, pullBallWidth, pullBallHeight)];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    
    if (newSuperview)
    {
        // 新的父控件
        [newSuperview addObserver:self
                       forKeyPath:@"contentOffset"
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:nil];
        
        // 设置宽度
        self.scrollviewWidth = newSuperview.frame.size.width;
        
        // 记录UIScrollView
        _parentScrollView = (UIScrollView *)newSuperview;
    }
}

- (void)dealloc
{
    self.parentScrollView   = nil;
    self.refreshingCallback = nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        NSValue * point = (NSValue *)[change objectForKey:@"new"];
        CGPoint p = [point CGPointValue];
        [self adjustStatusByTop:p.y];
    }
}

#pragma mark init

- (void)initLoadingImageView:(FLAnimatedImageView *)imageView;
{
    if(imageView)
    {
        _loadingImageView = imageView;
    }
}

- (void)setProgress:(CGFloat)progress
{
    
    _progress = 1.4 * progress;
    
    if(_progress <= 1.0)
    {
        _refreshing = NO;
        [[self layer]removeAllAnimations];
        NSUInteger index = (ceilf(_progress * (self.imageArray.count - 1)));
        UIImage *image = self.imageArray[index];
        [self.layer setContents:image];
    }
    else
    {
        if(!_refreshing)
        {
            [[self layer]addAnimation:self.animation forKey:@"gifAnimation"];
            _refreshing = YES;
        }
    }
}


//解析gif文件数据的方法 block中会将解析的数据传递出来
- (void)getGifImageWithUrk:(NSURL *)url
                returnData:(void(^)(NSArray<UIImage *> *imageArray,
                                    NSArray<NSNumber *> *timeArray,
                                    CGFloat totalTime,
                                    NSArray<NSNumber *> *widths,
                                    NSArray<NSNumber *> *heights))dataBlock
{
    
    //通过文件的url来将gif文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    //获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    //定义一个变量记录gif播放一轮的时间
    float allTime = 0;
    //存放所有图片
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    //存放每一帧播放的时间
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
    NSMutableArray *widthArray = [[NSMutableArray alloc] init];
    //存放每张图片的高度
    NSMutableArray *heightArray = [[NSMutableArray alloc] init];
    //遍历
    for (size_t i=0; i < count; i++)
    {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        //获取图片信息
        CFDictionaryRef imageInfo = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSNumber *widthNum = CFDictionaryGetValue(imageInfo, kCGImagePropertyPixelWidth);
        NSNumber *heightNum = CFDictionaryGetValue(imageInfo, kCGImagePropertyPixelHeight);
        
        [widthArray addObject:widthNum];
        [heightArray addObject:heightNum];
        
        NSDictionary *timeDic = CFDictionaryGetValue(imageInfo, kCGImagePropertyGIFDictionary);
        CGFloat time          = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime] floatValue];
        allTime              += time;
        [timeArray addObject:[NSNumber numberWithFloat:time]];

        
        CFRelease(imageInfo);
    }
    
    CFRelease(source);
    
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}


-(void)yh_setImage:(NSURL *)imageUrl
{
    __weak typeof(self) weakSelf = self;
    [self getGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        //添加帧动画
        CAKeyframeAnimation *animation    = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        NSMutableArray<NSNumber *> *times = [[NSMutableArray alloc]init];
        float currentTime                 = 0;
        
        //设置每一帧的时间占比
        for (int i=0; i < imageArray.count; i++) {
            [times addObject:[NSNumber numberWithFloat:currentTime / totalTime]];
            currentTime += [timeArray[i] floatValue];
        }
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //设置循环
        animation.repeatCount = MAXFLOAT;
        //设置播放总时长
        animation.duration  = totalTime;
        weakSelf.imageArray = imageArray;
        weakSelf.timeArray  = timeArray;
        weakSelf.widths     = widths;
        weakSelf.heights    = heights;
        weakSelf.totalTime  = totalTime;
        weakSelf.animation  = animation;
    }];
}

- (void)setTopRefreshStatus:(HXSPullRefreshHeaderState)topRefreshStatus
{
    switch (topRefreshStatus)
    {
        case HXSPullRefreshHeaderStateNone:
        {
            [_loadingImageView      stopAnimating];
            [_loadingImageView      setHidden:YES];
            if(_refreshing)
            {
                return;
            }
            self.image = nil;
        }
            break;
        case HXSPullRefreshHeaderStateTriggering:
        {
            if(_refreshing)
            {
                return;
            }
            
            if(_offSetY < -pullTotalHeight)
            {
                _offSetY = -pullTotalHeight;
            }
            
            int index = ceilf((_offSetY / -pullTotalHeight) * (self.imageArray.count - 1));
            UIImage *image = self.imageArray[index];
            [self.layer setContents:image];
        }
            break;
        case HXSPullRefreshHeaderStateTriggered:
        {
            [self.parentScrollView setScrollEnabled:YES];
            if(_refreshing)
            {
                return;
            }
            if(_offSetY < -pullTotalHeight)
            {
                _offSetY = -pullTotalHeight;
            }
            
            NSInteger index = ceilf((_offSetY / -pullTotalHeight) * (self.imageArray.count - 1));
            UIImage *image = self.imageArray[index];
            [self.layer setContents:image];
        }
            break;
        case HXSPullRefreshHeaderStateLoading:
        {
            if(!_refreshing)
            {
                [self.layer setContents:nil];
                _refreshing = YES;
                self.refreshingCallback();
                
                [self.parentScrollView setScrollEnabled:NO];
                
                [UIView animateWithDuration:1.0 animations:^{
                    [self.parentScrollView setContentOffset:CGPointMake(0, -pullBallHeight)];
                    [self.parentScrollView setContentInset:UIEdgeInsetsMake(pullBallHeight + 20, 0, 0, 0)];
                    
                } completion:^(BOOL finished) {
                    
                    [self.parentScrollView setScrollEnabled:YES];
                }];

                [_loadingImageView setHidden:NO];
                [_loadingImageView setAnimatedImage:self.flaImage];
                [_loadingImageView startAnimating];
            }
        }
            break;
        case HXSPullRefreshHeaderStateCanFinish:
        {
            if(_refreshing)
            {
                [UIView animateWithDuration:0.3
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear animations:^
                 {
                     [self.parentScrollView setContentOffset:CGPointZero];
                     [self.parentScrollView setContentInset:UIEdgeInsetsZero];
                 } completion:^(BOOL finished) {
                     [self.loadingImageView stopAnimating];
                     [self.loadingImageView setAnimatedImage:nil];
                     [self.loadingImageView setHidden:YES];
                     _refreshing = NO;
                 }];
            }
            else
            {
                [self.loadingImageView stopAnimating];
                [self.loadingImageView setHidden:YES];
                [self.loadingImageView setAnimatedImage:nil];

                _refreshing = NO;
            }
        }
            break;
    }
    
}

- (void)adjustStatusByTop:(float)y
{
    _offSetY = 2 * y;
    if(y > -pullStartHeight && self.parentScrollView.isDragging)
    {
        self.topRefreshStatus = HXSPullRefreshHeaderStateNone;
    }
    else if(y >  - pullTopViewHeight
            && _offSetY <= -pullStartHeight && self.parentScrollView.isDragging)
    {
        self.topRefreshStatus = HXSPullRefreshHeaderStateTriggering;
    }
    else if(y < -pullTopViewHeight
            && self.parentScrollView.isDragging)
    {
        self.topRefreshStatus = HXSPullRefreshHeaderStateTriggered;
    }
    else if(y <= - pullTopViewHeight
            && !self.parentScrollView.isDragging && !_refreshing)
    {
        self.topRefreshStatus = HXSPullRefreshHeaderStateLoading;
    }
    
}

- (void)beginLoading
{
    
    if (_topRefreshStatus == HXSPullRefreshHeaderStateLoading)
    {
        if(_refreshingCallback) {
            _refreshingCallback();
        }
    }
    else
    {
        self.topRefreshStatus = HXSPullRefreshHeaderStateLoading;
    }
}

- (void)endLoadding
{
    self.topRefreshStatus = HXSPullRefreshHeaderStateCanFinish;
}

#pragma mark getter

- (FLAnimatedImage *)flaImage
{
    if(!_flaImage)
    {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *bundlePath = [bundle pathForResource:@"HXStoreBase" ofType:@"bundle"];
        if (bundlePath) {
            bundle = [NSBundle bundleWithPath:bundlePath];
        }
        NSString* gifPath    = [bundle pathForResource:@"59TopLoading"
                                                ofType:@"gif"];
        
        NSData *data         = [NSData dataWithContentsOfFile:gifPath];
        _flaImage            = [FLAnimatedImage animatedImageWithGIFData:data];
    }
    return _flaImage;
}



@end
