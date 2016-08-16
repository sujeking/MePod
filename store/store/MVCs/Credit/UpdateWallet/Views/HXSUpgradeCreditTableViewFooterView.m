//
//  HXSUpgradeCreditTableViewFooterView.m
//  store
//
//  Created by  黎明 on 16/7/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUpgradeCreditTableViewFooterView.h"


@interface HXSUpgradeCreditTableViewFooterView()

@property (weak, nonatomic) IBOutlet UITextView *protocolTextView;
@property (weak, nonatomic) IBOutlet HXSRoundedButton *subimtButton;
@property (weak, nonatomic) IBOutlet UIButton *hasReadProtocolButton;

@end

@implementation HXSUpgradeCreditTableViewFooterView

- (void)awakeFromNib
{
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    [self.hasReadProtocolButton setImage:[UIImage imageNamed:@"btn_choose_empty"]
                                forState:UIControlStateNormal];
    [self.hasReadProtocolButton setImage:[UIImage imageNamed:@"btn_choose_blue"]
                                forState:UIControlStateSelected];
    
    self.hasReadProtocolButton.selected = YES;
    self.subimtButton.enabled = NO;
    
    self.protocolTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.protocolTextView.editable = NO;
    
    NSString *beginStr = @"同意";
    NSString *protocolStr = @" 59钱包开通协议 ";
    NSString *wholeStr = [NSString stringWithFormat:@"%@%@", beginStr, protocolStr];
    
    NSRange beginRange = [wholeStr rangeOfString:beginStr];
    NSRange protocolRange = [wholeStr rangeOfString:protocolStr];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15]
                          range:NSMakeRange(0, wholeStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x999999)
                          range:beginRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x54ADF9)
                          range:protocolRange];
    [attributedStr addAttribute:NSLinkAttributeName
                          value:[NSURL URLWithString:@"protocol://"]
                          range:protocolRange];
    NSDictionary *linkedDic = @{NSForegroundColorAttributeName:UIColorFromRGB(0x54ADF9),
                                NSUnderlineColorAttributeName:UIColorFromRGB(0x54ADF9),
                                NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
    
    self.protocolTextView.linkTextAttributes = linkedDic;
    self.protocolTextView.attributedText = attributedStr;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(protocolTextViewTapAction)];
    [self.protocolTextView addGestureRecognizer:tap];
}

- (void)protocolTextViewTapAction
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(loadWalletProtocalVC)])
    {
        [self.delegate performSelector:@selector(loadWalletProtocalVC)];
    }
}


- (IBAction)submitButtonClickAction:(id)sender
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(submitButonClickAction)])
    {
        [self.delegate performSelector:@selector(submitButonClickAction)];
    }
}


- (IBAction)onClickReadedBtn:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
    
    [self updateButtonStatus];
}


- (void)setCanSubmitStatus:(BOOL)canSubmitStatus
{
    _canSubmitStatus = canSubmitStatus;
    
    [self updateButtonStatus];
}

- (void)updateButtonStatus
{
    if (self.canSubmitStatus && self.hasReadProtocolButton.isSelected)
    {
        self.subimtButton.enabled = YES;
    }
    else
    {
        self.subimtButton.enabled = NO;
    }
}



@end
