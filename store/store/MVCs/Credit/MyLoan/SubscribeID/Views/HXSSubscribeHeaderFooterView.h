//
//  HXSSubscribeHeaderFooterView.h
//  59dorm
//  申请开通界面单个label的header,footer界面
//  Created by J006 on 16/7/8.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSSubscribeHeaderFooterView : UIView

+ (instancetype)createSubscribeHeaderFooterViewWithContent:(NSString *)content
                                                 andHeight:(CGFloat)height
                                               andFontSize:(CGFloat)fontSize
                                              andTextColor:(UIColor*)textColor;

@end
