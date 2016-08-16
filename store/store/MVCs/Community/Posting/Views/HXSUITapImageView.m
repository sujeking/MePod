//
//  HXSUITapImageView.m
//  59Store
//
//  Created by J006 on 16/3/9.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSUITapImageView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface HXSUITapImageView()

@property (nonatomic, copy) void(^tapAction)(id);
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation HXSUITapImageView


- (void)tap
{
    if (self.tapAction)
        self.tapAction(self);
}

- (void)addTapBlock:(void(^)(id obj))tapAction
{
    self.tapAction = tapAction;
    self.userInteractionEnabled = YES;
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:_tapGesture];
}

- (void)removeTheTapAction
{
    if(_tapGesture)
        [self removeGestureRecognizer:_tapGesture];
}

- (void)sd_setImageWithUrl:(NSString *)imgUrlStr
          placeholderImage:(UIImage *)placeholderImage
                  tapBlock:(void(^)(id obj))tapAction complete:(void(^)(id obj))block
{
    __weak typeof(self) weakSelf = self;
    if(!imgUrlStr || [imgUrlStr isEqualToString:@""])
        return;
    NSURL *imageURL = [NSURL URLWithString:imgUrlStr];
    [self sd_setImageWithURL:imageURL placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        if(!image)
            return;
        [weakSelf addTapBlock:tapAction];
        block(nil);
    }];
}

- (void)sd_setImageWithUrl:(NSString *)imgUrlStr
          placeholderImage:(UIImage *)placeholderImage
                  tapBlock:(void (^)(id))tapAction
 andActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle
                  complete:(void (^)(UIImage *image))block
{
    __weak typeof(self) weakSelf = self;
    if(!imgUrlStr || [imgUrlStr isEqualToString:@""])
        return;
    NSURL *imageURL = [NSURL URLWithString:imgUrlStr];
    
    [self setImageWithURL:imageURL
         placeholderImage:placeholderImage
                  options:SDWebImageRetryFailed
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        if(!image)
            return;
        [weakSelf addTapBlock:tapAction];
        block(image);
    } usingActivityIndicatorStyle:activityStyle];
}

@end
