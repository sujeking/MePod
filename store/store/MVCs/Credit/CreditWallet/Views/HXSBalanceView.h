//
//  HXSBalanceView.h
//  Test
//
//  Created by hudezhi on 15/11/4.
//  Copyright © 2015年 59store. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSBalanceView : UIView

@property (nonatomic, copy) NSString *tipText;
@property (nonatomic, assign) BOOL isFreeze;

- (void)setCurrentValue:(CGFloat)currentValue maxValue:(NSInteger)maxValue;

@end
