//
//  HXSRegisterVerifyButton.h
//  store
//
//  Created by hudezhi on 15/11/10.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * @Important: when you alloc HSSVerifyButton in code or drag a UIButton in storyboard,
 *             please make the UIButtonType to UIButtonTypeCustom.
 * The UIButtonTypeSystem will lead a flush when update title to 获取验证码(xx)
 
 
 *
 * 注册时的 获取验证码 按钮风格跟在 外卖中 获取验证码直接注册登录的风格不一致，直接修改 HSSVerifyButton 会影响到外卖中的风格, 所以直接建一个新的算了
 */

@interface HXSRegisterVerifyButton : UIButton

@property (nonatomic, readonly) BOOL isCounting;

- (void)countingSeconds:(NSInteger)seconds;

@end