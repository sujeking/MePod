//
//  HXSOrderShareInfoView.h
//  store
//
//  Created by hudezhi on 15/9/23.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSOrderActivityInfoView : UIView

- (void)showActivityInfos:(NSArray *)shareInfos inView:(UIView *)view;
- (void)showActivityInfos:(NSArray *)shareInfos inView:(UIView *)view bottomSpace:(CGFloat)bottomSpace;

@end
