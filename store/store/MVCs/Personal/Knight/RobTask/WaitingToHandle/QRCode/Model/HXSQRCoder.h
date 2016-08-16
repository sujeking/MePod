//
//  HXSQRCoder.h
//  store
//
//  Created by 格格 on 16/4/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSQRCoder : NSObject


/**
 *  生成二维码
 *
 *  @param source 要生成二维码的内容
 *
 *  @return
 */
+ (CIImage *)createQRCodeImage:(NSString *)source;

/**
 *  针对大小生成二维码图片
 *
 *  @param image 二维码图片
 *  @param size  固定的尺寸
 *
 *  @return
 */
+ (UIImage *)resizeQRCodeImage:(CIImage *)image
                      withSize:(CGFloat)size;

/**
 *  更改二维码颜色
 *
 *  @param image 二维码图片
 *  @param red
 *  @param green
 *  @param blue
 *
 *  @return
 */
+ (UIImage *)specialColorImage:(UIImage*)image
                       withRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;

/**
 *  添加固定尺寸的中心图片
 *
 *  @param image    二维码图片
 *  @param icon     要添加的icon
 *  @param iconSize icon尺寸
 *
 *  @return
 */
+ (UIImage *)addIconToQRCodeImage:(UIImage *)image
                         withIcon:(UIImage *)icon
                     withIconSize:(CGSize)iconSize;

/**
 *  添加缩放的中心图片
 *
 *  @param image 二维码图片
 *  @param icon  icon图片
 *  @param scale 缩放倍数
 *
 *  @return
 */
+ (UIImage *)addIconToQRCodeImage:(UIImage *)image
                         withIcon:(UIImage *)icon
                        withScale:(CGFloat)scale;

@end
