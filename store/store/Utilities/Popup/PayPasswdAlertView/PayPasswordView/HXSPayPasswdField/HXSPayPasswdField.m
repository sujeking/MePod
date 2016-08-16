//
//  HXSPayPasswdField.m
//  Test
//
//  Created by hudezhi on 15/7/25.
//  Copyright (c) 2015年 59store. All rights reserved.
//

#import "HXSPayPasswdField.h"

static NSInteger passwd_length = 6;

#define WIDTH_BORDER   (1.0 / [UIScreen mainScreen].scale)

@interface HXSNOCursorField : UITextField

@end

@implementation HXSNOCursorField 

#pragma mark - override

- (CGRect) caretRectForPosition:(UITextPosition*) position
{
    return CGRectZero;
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range
{
    return nil;
}

@end

@interface HXSPayPasswdField () {
    NSMutableArray  *_labels;
    HXSNOCursorField *_noCursorField;
}

@property (nonatomic, assign) CGFloat borderWidth;

@end

@implementation HXSPayPasswdField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (CGFloat)borderWidth
{
    return WIDTH_BORDER;
}

- (void)layoutSubviews
{
    // border width
    CGFloat w = roundf((self.width - self.borderWidth * (_labels.count + 1))/_labels.count);
    
    for(int i = 0; i < _labels.count; i++) {
        UILabel *label = _labels[i];
        
        CGFloat width = (i == (_labels.count - 1)) ? self.width - (w + self.borderWidth) *(i) : w ;
        label.frame = CGRectMake((w + self.borderWidth) * i, 0, width, self.height);
    }
}

- (void)updateLabelText
{
    NSInteger textLength = self.text.length;
    
    if (textLength > passwd_length) {
        _noCursorField.text = [self.text substringToIndex:6];
    }
    
    int i = 0;
    for (; (i < textLength) && (i < passwd_length); i++) {
        UILabel *label = _labels[i];
        label.text = @"\u25CF";
        label.textColor = [UIColor blackColor];
    }
    
    for(; i < passwd_length ; i++) {
        UILabel *label = _labels[i];
        label.text = @"";
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [_noCursorField becomeFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    return [_noCursorField canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return [_noCursorField resignFirstResponder];
}

- (BOOL)isFirstResponder
{
    return [_noCursorField isFirstResponder];
}

#pragma getter/setter

- (NSString *)text
{
    return _noCursorField.text;
}

#pragma mark - private method

- (UILabel *)passwdLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor colorWithRGBHex:0x999999];
    label.userInteractionEnabled = NO;
    
    return label;
}

- (void)setup
{
    _noCursorField = [[HXSNOCursorField alloc] init];
    [_noCursorField addTarget:self action:@selector(updateLabelText) forControlEvents:UIControlEventEditingChanged];
    _noCursorField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_noCursorField];
    
    _labels = [NSMutableArray arrayWithCapacity:6];
    
    for(int i = 0; i < passwd_length; i++) {
        UILabel* label = [self passwdLabel];
        [_labels addObject:label];
        [self addSubview:label];
        
    }
    
    self.backgroundColor = [UIColor colorWithRGBHex:0xE1E2E2];
    
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRGBHex:0xE1E2E2].CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.layer.cornerRadius = 3.0;
}

@end
