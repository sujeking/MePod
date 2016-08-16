//
//  HXSMyNewPayBillInstallmentFooterView.m
//  store
//
//  Created by J006 on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyNewPayBillInstallmentFooterView.h"

@interface HXSMyNewPayBillInstallmentFooterView()

@end

@implementation HXSMyNewPayBillInstallmentFooterView

+ (id)myNewPayBillInstallmentFooterView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
    [self initTheView];
}

/**
 *  初始化相关界面
 */
- (void)initTheView
{
    _contractTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    _contractTextView.editable = NO;
    
    NSString *beginStr = @"同意";
    NSString *protocolStr = @"59账单分期";
    NSString *endStr = @"协议";
    NSString *wholeStr = [NSString stringWithFormat:@"%@%@%@", beginStr, protocolStr, endStr];
    
    NSRange beginRange = [wholeStr rangeOfString:beginStr];
    NSRange protocolRange = [wholeStr rangeOfString:protocolStr];
    NSRange endRange = [wholeStr rangeOfString:endStr];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:13]
                          range:NSMakeRange(0, wholeStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x999999)
                          range:beginRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x54ADF9)
                          range:protocolRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x999999)
                          range:endRange];
    [attributedStr addAttribute:NSLinkAttributeName
                          value:[NSURL URLWithString:@"protocol://"]
                          range:protocolRange];
    NSDictionary *linkedDic = @{NSForegroundColorAttributeName:UIColorFromRGB(0x54ADF9),
                                NSUnderlineColorAttributeName:UIColorFromRGB(0x54ADF9),
                                NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
    
    _contractTextView.linkTextAttributes = linkedDic;
    _contractTextView.attributedText = attributedStr;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(jumpToBoxProtocal)];
    [_contractTextView addGestureRecognizer:tap];
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [self jumpToBoxProtocal];
    
    return YES;
}


#pragma mark - Jump To Box Protocal

- (void)jumpToBoxProtocal
{
    if([self.delegate respondsToSelector:@selector(jumpToInstallmentWebView)])
        [self.delegate jumpToInstallmentWebView];
}


#pragma mark - Button Action

/**
 *确定分期，返回我的账单按钮功能
 */
- (IBAction)confirmAndBackButtonAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(confirmInstallment)]) {
        [self.delegate confirmInstallment];
    }
}

@end
