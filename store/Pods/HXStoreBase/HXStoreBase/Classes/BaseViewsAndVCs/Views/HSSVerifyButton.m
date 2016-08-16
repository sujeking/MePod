//
//  HSSVerifyButton.m
//  Test
//
//  Created by hudezhi on 15/7/24.
//  Copyright (c) 2015年 59store. All rights reserved.
//

#import "HSSVerifyButton.h"

#import "UIColor+Extensions.h"
#import "HXAppDeviceHelper.h"
#import "UIImage+Extension.h"

@interface HSSVerifyButton() {
    NSInteger   _count;
    NSTimer     *_timer;
}

- (void)setupVerifyBtn;
- (void)refresh:(NSTimer *)timer;
- (void)updateDynamicTitle;

@end

@implementation HSSVerifyButton

- (void)awakeFromNib
{
    [self setupVerifyBtn];
}

- (void)setupVerifyBtn
{
    self.borderWidth = 0.5;
    self.borderColor = [UIColor colorWithRGBHex:0xCCCCCC];
    self.backgroundColor = [UIColor colorWithARGBHex:0xC0ECFC];
    self.cornerRadius = 4.0;
    
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [self setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithRGBHex:0xC0ECFC]]
                    forState:UIControlStateDisabled];
}

#pragma mark - override

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self setTitle:@"发送验证码" forState:UIControlStateDisabled];
}

#pragma mark - private method

- (void)updateDynamicTitle
{
    NSString *title = [NSString stringWithFormat:@"已发送%ds", (int)_count]; // 获取验证码
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [UIView setAnimationsEnabled:NO];
        [self setTitle:title forState:UIControlStateDisabled];
        [UIView setAnimationsEnabled:YES];
    }
    else {
        self.titleLabel.text = title;
        [self setTitle:title forState:UIControlStateDisabled];
    }
}

- (void)refresh:(NSTimer *)timer
{
    if(--_count > 0) {
        [self updateDynamicTitle];
    }
    else {
        [_timer invalidate];
        self.enabled = YES;
        self.backgroundColor = [UIColor colorWithRGBHex:0xC0ECFC];
        [self setTitle:@"重新发送" forState:UIControlStateNormal];
    }
}

#pragma mark - public method

- (BOOL) isCounting
{
    return [_timer isValid];
}

- (void)countingSeconds:(NSInteger)seconds
{
    _count = seconds;
    
    if(_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
    self.enabled = NO;
    _count--;
    [self updateDynamicTitle];
}

@end
