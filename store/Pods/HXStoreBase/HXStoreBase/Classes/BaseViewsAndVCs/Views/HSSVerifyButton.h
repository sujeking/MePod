//
//  HSSVerifyButton.h
//  Test
//
//  Created by hudezhi on 15/7/24.
//  Copyright (c) 2015年 59store. All rights reserved.
//

#import "UIRenderingButton.h"

/*
 * @Important: when you alloc HSSVerifyButton in code or drag a UIButton in storyboard, 
 *             please make the UIButtonType to UIButtonTypeCustom.
 * The UIButtonTypeSystem will lead a flush when update title to 获取验证码(xx)
*/
@interface HSSVerifyButton : UIRenderingButton

@property (nonatomic, readonly) BOOL isCounting;
- (void)countingSeconds:(NSInteger)seconds;

@end
