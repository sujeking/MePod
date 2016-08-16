//
//  HXSEmptyTableBackgroundView.h
//  store
//
//  Created by hudezhi on 15/8/19.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSEmptyTableBackgroundView : UIView

+ (instancetype)view;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

// 默认图片居中, 设置图片距顶部距离以及图片和文字间距离
- (void)setTopPadding:(CGFloat)topPadding spacing:(CGFloat)scaping;

@end
