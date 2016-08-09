//
//  ProgressView.h
//  masony
//
//  Created by  黎明 on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

//手动动画  输入百分比  在【0 ~ 1】之间
@property (nonatomic, assign) CGFloat progress;

//自动动画
- (void)startAnimation;
@end
