//
//  HXSKeyBoardBarView.m
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSKeyBoardBarView.h"

@interface HXSKeyBoardBarView()

@end

@implementation HXSKeyBoardBarView

- (void)awakeFromNib
{
    [self initSubViews];
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.inputTextView.bounds)-10, CGRectGetHeight(self.inputTextView.bounds))];
        
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        
    }
    return _placeholderLabel;
}

- (UIButton *)delButton
{
    if (!_delButton) {
        _delButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.inputTextView.bounds)-26, (CGRectGetHeight(self.inputTextView.bounds)-16)/2, 16, 16)];

        [_delButton setBackgroundImage:[UIImage imageNamed:@"ic_follow_cancel"] forState:UIControlStateNormal];
        
        [_delButton addTarget:self action:@selector(cleanInputTextViewText) forControlEvents:UIControlEventTouchUpInside];
        _delButton.hidden = YES;
    }
    return _delButton;
}

- (void)cleanInputTextViewText
{
    self.inputTextView.text = nil;
    self.placeholderLabel.hidden = NO;
    self.delButton.hidden = YES;
}

/**
 *  初始化子控件
 */
- (void)initSubViews
{
    self.inputTextView.layer.borderWidth = 0.5f;
    self.inputTextView.layer.borderColor = [[UIColor colorWithR:204 G:204 B:204 A:1] CGColor];
    self.inputTextView.layer.cornerRadius = 3.0f;
    self.inputTextView.layer.masksToBounds = YES;

    [self.inputTextView addSubview:self.placeholderLabel];
    [self.inputTextView addSubview:self.delButton];
    [self.sendButton setEnabled:NO];
    [self.sendButton addTarget:self action:@selector(sendReplayAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.inputTextView.delegate = self;
    
    
    
    
}

//重置
- (void)resetInuptTextView
{
    self.inputTextView.text = nil;
    
    [self.sendButton setEnabled:NO];
    
    self.placeholderLabel.hidden = NO;
}


/**
 *  发送按钮点击
 *
 *  @param sender
 */
- (void)sendReplayAction:(id)sender
{
    NSString *contentStr = self.inputTextView.text;
    
    
    if (self.sendReplayTextBlock) {
        
        contentStr = [contentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (contentStr.length != 0)
        {
            self.sendReplayTextBlock(contentStr);
        }
    }    
    
    self.inputTextView.text      = nil;
    self.placeholderLabel.hidden = NO;
}

#pragma mark -


- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        
        self.delButton.hidden        = NO;
        self.sendButton.enabled      = YES;
        self.placeholderLabel.hidden = YES;
    } else {
        
        self.sendButton.enabled      = NO;
        self.delButton. hidden       = YES;
        self.placeholderLabel.hidden = NO;
    }
    
    if (textView.text.length >= 120)
    {
        textView.text = [textView.text substringToIndex:120];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length >= 120) {
        
        return NO;
    } else if([text isEqualToString:@"\n"]) {
        
        [self sendReplayAction:nil];
        return NO;
    } else {
        return YES;
    }
}



- (void)setCommentedTitle:(NSString *)commentedTitle
{
    if (commentedTitle.length == 0) {

        self.placeholderLabel.text = @"回复 ";

    } else {

        self.placeholderLabel.text = commentedTitle;
    }

}



@end
