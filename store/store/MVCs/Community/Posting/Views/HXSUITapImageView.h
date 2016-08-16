//
//  HXSUITapImageView.h
//  59Store
//
//  Created by J006 on 16/3/9.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  有点击事件的UIImageViews
 */
@interface HXSUITapImageView : UIImageView

- (void)addTapBlock:(void(^)(id obj))tapAction;
/**
 *  @param imgUrlStr 带图片链接地址
 *  @param placeholderImage 默认图片
 *  @param tapAction 点击事件
 */
- (void)sd_setImageWithUrl:(NSString *)imgUrlStr
          placeholderImage:(UIImage *)placeholderImage
                  tapBlock:(void(^)(id obj))tapAction
                  complete:(void(^)(id obj))block;
/**
 *  带转圈动画的读图
 *
 *  @param imgUrlStr 带图片链接地址
 *  @param placeholderImage 默认图片
 *  @param tapAction 点击事件
 *  @param activityStyle
 *  @param block
 */
- (void)sd_setImageWithUrl:(NSString *)imgUrlStr
          placeholderImage:(UIImage *)placeholderImage
                  tapBlock:(void (^)(id))tapAction
 andActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle
                  complete:(void (^)(UIImage *image))block;

/**
 *  移除按图后的block
 */
- (void)removeTheTapAction;

@end
