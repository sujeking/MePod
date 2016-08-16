//
//  HXSPickView.m
//  store
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPickView.h"

@implementation HXSPickView

- (id)initWithDelegate:(id)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)showPickViewIn:(UIView *)view
{
    self.suspendView = [[UIView alloc] init];
    self.suspendView.backgroundColor = [UIColor grayColor];
    self.suspendView.alpha = 0.0f;
    
    [self addSubview:self.suspendView];
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.suspendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding);
    }];
    
    self.pickView = [[UIPickerView alloc] init];
    self.pickView.backgroundColor = [UIColor whiteColor];
    self.pickView.delegate = self.delegate;
    self.pickView.dataSource = self.delegate;
    [self addSubview:self.pickView];
    
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(216);
        make.height.equalTo(@216);
    }];
    
    // 顶部取消和确定视图
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(44);
        make.height.equalTo(@44);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0x999999] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton setTitleColor:[UIColor colorWithRGBHex:0x999999] forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [self.topView addSubview:self.cancelButton];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).with.offset(10);
        make.top.equalTo(self.topView).with.offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@46);
    }];
    
    [self.topView addSubview:self.confirmButton];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).with.offset(-10);
        make.top.equalTo(self.topView).with.offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@46);
    }];
    
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(padding);
    }];
    
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.1];
}

- (void)startAnimation
{
    // 悬浮图层渐变动画
    [UIView beginAnimations:@"ChangeAlphaAnimation" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.suspendView setAlpha:0.7];
    [UIView commitAnimations];
    
    // 位移动画
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-216);
    }];
    
    [self.pickView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(0);
    }];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.topView layoutIfNeeded];
        [self.pickView layoutIfNeeded];
    }];
    
    
}

- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickedCancelButton:)]) {
        [self.delegate performSelector:@selector(clickedCancelButton:) withObject:self.pickView];
    }
    
    [self removeFromSuperview];
}

- (void)confirm:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickedConfirmButton:)]) {
        [self.delegate performSelector:@selector(clickedConfirmButton:) withObject:self.pickView];
    }
    
    [self removeFromSuperview];
}
@end
