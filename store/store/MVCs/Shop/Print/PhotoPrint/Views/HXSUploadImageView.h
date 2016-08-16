//
//  HXSUploadImageView.h
//  store
//
//  Created by J006 on 16/5/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSUploadImageViewDelegate <NSObject>

@optional

/**
 *  上传动画成功完毕
 */
- (void)confirmUploadFinished;

@end

@interface HXSUploadImageView : UIView

@property (nonatomic, strong) UILabel *uploadContentLabel;

@property (nonatomic, weak) id<HXSUploadImageViewDelegate> delegate;

/**手动动画  输入百分比  在【0 ~ 1】之间*/
@property (nonatomic, assign) CGFloat progress;

/**自动动画*/
- (void)startAnimation;

@end
