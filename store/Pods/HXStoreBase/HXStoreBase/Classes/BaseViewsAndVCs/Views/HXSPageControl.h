//
//  HXSPageControl.h
//  store
//
//  Created by chsasaw on 14/11/22.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSPageControl : UIPageControl

/**
 *  设置当前页面及不在当前页面的图片
 *
 *  @param imagesArr 第一个为当前页面的图片  第二个为不是当前页面的图片
 */
- (void)updateImages:(NSArray<UIImage *> *)imagesArr;

@end
