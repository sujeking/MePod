//
//  HXSPullRefreshImageView.h
//  store
//
//  Created by J006 on 16/6/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

typedef NS_ENUM(NSUInteger, HXSPullRefreshHeaderState)
{
    HXSPullRefreshHeaderStateNone = 0,   //正常状态
    HXSPullRefreshHeaderStateTriggering,
    HXSPullRefreshHeaderStateTriggered,
    HXSPullRefreshHeaderStateLoading,
    HXSPullRefreshHeaderStateCanFinish
};

@interface HXSPullRefreshImageView : UIImageView

@property (nonatomic, assign)   CGFloat                     progress;
@property (nonatomic, weak)   UIScrollView                *parentScrollView;
@property (nonatomic, assign)   HXSPullRefreshHeaderState   topRefreshStatus;
@property (nonatomic, copy)     void                        (^refreshingCallback)();
@property (nonatomic, assign)   CGFloat                     scrollviewWidth;

- (void)getGifImageWithUrk:(NSURL *)url
                returnData:(void(^)(NSArray<UIImage *> *imageArray,
                                   NSArray<NSNumber *> *timeArray,
                                   CGFloat totalTime,
                                   NSArray<NSNumber *> *widths,
                                   NSArray<NSNumber *> *heights))dataBlock;
- (void)yh_setImage:(NSURL *)imageUrl;
- (void)adjustStatusByTop:(float)y;
- (void)initLoadingImageView:(FLAnimatedImageView *)imageView;
- (void)beginLoading;
- (void)endLoadding;

@end
