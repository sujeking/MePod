//
//  UIImage+Extension.h
//  store
//
//  Created by hudezhi on 15/7/25.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Extension)

+ (UIImage*) imageFromColor:(UIColor *)color;
+ (UIImage*) imageFromLayer:(CALayer*) layer;
- (NSString *)convertImageToString;
- (UIImage *)imageByScalingToMaxSize;

// 生成原角图片
+ (UIImage *)createRoundedRectImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;

@end
