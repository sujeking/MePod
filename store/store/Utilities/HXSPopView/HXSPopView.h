//
//  HXSPopView.h
//  aaaaaa
//
//  Created by  黎明 on 16/7/12.
//  Copyright © 2016年 suzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSPopView : UIView

/**
 *  根据要展示的内容【view】进行初始化
 *
 *  @param view view
 *
 *  @return popView
 */
- (instancetype)initWithView:(UIView *)view;
/**
 *  展示出来弹出层
 */
- (void)show;

- (void)closeWithCompleteBlock:(void(^)())block;

@end
