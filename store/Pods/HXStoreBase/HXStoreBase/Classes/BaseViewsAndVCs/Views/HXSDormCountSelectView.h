//
//  HXSDormCountSelectView.h
//  store
//
//  Created by chsasaw on 14/11/20.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXMacrosEnum.h"

@class HXSDormCountSelectView;

@protocol HXSDormCountSelectViewDelegate <NSObject>

- (void)countSelectView:(HXSDormCountSelectView *)countView didEndEdit:(int)count;
- (void)countAdd;

@end

@interface HXSDormCountSelectView : UIView

@property (nonatomic, assign) HXSDormItemStatus status;
@property (nonatomic, weak) id<HXSDormCountSelectViewDelegate> delegate;

@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) NSNumber *maxCount; // default is INT_MAX

- (void)setCount:(int)count animated:(BOOL)animated manual:(BOOL)manual;
- (int)getCount;
- (void)setStatus:(HXSDormItemStatus)status animated:(BOOL)animated;

@end