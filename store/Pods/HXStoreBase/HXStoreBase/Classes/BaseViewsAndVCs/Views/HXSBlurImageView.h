//
//  HXSBlurImageView.h
//  store
//
//  Created by chsasaw on 15/1/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSBlurImageView : UIImageView

- (void)blurSetImage:(UIImage *)image;
- (void)blurSetImage:(UIImage *)image colorLevel:(CGFloat)level;
- (void)blurSetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (BOOL)hasImageNow;

@end
