//
//  HXSPickView.h
//  store
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSPickViewDelegate<NSObject>

@optional
- (void)clickedCancelButton:(UIPickerView *)pickView;
- (void)clickedConfirmButton:(UIPickerView *)pickView;

@end

@interface HXSPickView : UIView

// 灰色图层
@property (strong, nonatomic) UIView *suspendView;
@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIView *topView;

@property (weak, nonatomic) id delegate;

- (id)initWithDelegate:(id)delegate;
- (void)showPickViewIn:(UIView *)view;

@end
