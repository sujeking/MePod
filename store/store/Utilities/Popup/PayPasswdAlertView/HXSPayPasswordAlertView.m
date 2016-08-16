//
//  HXSPayPasswordAlertView.m
//  store
//
//  Created by ArthurWang on 15/7/30.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPayPasswordAlertView.h"

#import "HXSPayPasswdView.h"
#import "CustomIOSAlertView.h"
#import "HXSLineView.h"

#define BLANK_DISTANT_SCREEN_BIGGER  50
#define BLANK_DISTANT_SCREEN_SMALLER 30
#define PADDING                      20

@interface HXSPayPasswordAlertView ()

@property (nonatomic, strong) CustomIOSAlertView *customIOSAlertView;
@property (nonatomic, strong) HXSPayPasswdView   *alertView;
@property (nonatomic, assign) BOOL               didRightToLeft;
@property (nonatomic, strong) NSNumber           *hasSelectedExemptionBoolNum;

@end

@implementation HXSPayPasswordAlertView


#pragma mark - Initail Methods

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id)delegate
              leftButtonTitle:(NSString *)cancelButtonTitle
            rightButtonTitles:(NSString *)otherButtonTitle
{
    self = [super init];
    if (self) {
        self.titleStr                    = title;
        self.messageStr                  = message;
        self.customAlertViewDelegate     = delegate;
        self.didRightToLeft              = NO;
        self.leftBtnBlock                = nil;
        self.rightBtnBlock               = nil;
        self.hasSelectedExemptionBoolNum = nil;
        
        [self createPasswordAlertView];
        [self initialBtn]; 
        
        [self setBackgroundColor:[UIColor clearColor]];
        UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        [window addSubview:self];
        
        [self.alertView.passwdField becomeFirstResponder];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)cancelButtonTitle
            rightButtonTitles:(NSString *)otherButtonTitle
{
    return [self initWithTitle:title message:message delegate:nil leftButtonTitle:cancelButtonTitle rightButtonTitles:otherButtonTitle];
}

- (void)dealloc
{
    self.customIOSAlertView          = nil;
    self.alertView                   = nil;
    self.titleStr                    = nil;
    self.messageStr                  = nil;
    self.leftBtn                     = nil;
    self.rightBtn                    = nil;
    self.leftBtnBlock                = nil;
    self.rightBtnBlock               = nil;
    self.hasSelectedExemptionBoolNum = nil;
}


#pragma mark --- initialBtn
- (void)initialBtn
{
    [self.alertView.cancelButton addTarget:self
                                    action:@selector(onClickLeftBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.alertView.confirmButton addTarget:self
                                     action:@selector(onClickRightBtn:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - Public Methods

- (void)show
{
    [self setupExemptionViewInAlertView];
    
    [self.customIOSAlertView show];
}

- (void)close
{
    [self.customIOSAlertView close];
    
    [self removeFromSuperview];
}

#pragma mark - Target Methods

- (void)onClickLeftBtn:(UIButton *)button
{
    if ((nil != self.customAlertViewDelegate)
        && [self.customAlertViewDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:passwd:exemptionStatus:)]) {
        [self.customAlertViewDelegate alertView:self clickedButtonAtIndex:0 passwd:nil exemptionStatus:self.hasSelectedExemptionBoolNum]; // index of left button is 0
    }
    
    if (self.didRightToLeft) {
        if (nil != self.rightBtnBlock) {
            self.rightBtnBlock(nil, self.hasSelectedExemptionBoolNum);
        }
    } else {
        if (nil != self.leftBtnBlock) {
            self.leftBtnBlock(nil, self.hasSelectedExemptionBoolNum);
        }
    }
    
    [self.alertView endEditing:YES];
    
    [self close];
}

- (void)onClickRightBtn:(UIButton *)button
{
    if (6 > [self.alertView.passwdField.text length]) {
        return; // The length of password must be 6.
    }
    
    if ((nil != self.customAlertViewDelegate)
        && [self.customAlertViewDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:passwd:exemptionStatus:)]) {
        [self.customAlertViewDelegate alertView:self clickedButtonAtIndex:1 passwd:self.alertView.passwdField.text exemptionStatus:self.hasSelectedExemptionBoolNum]; // index of left button is 1
    }
    
    if (nil != self.rightBtnBlock) {
        self.rightBtnBlock(self.alertView.passwdField.text, self.hasSelectedExemptionBoolNum);
    }
    
    [self.alertView endEditing:YES];
    
    [self close];
}

- (void)onClickExemptionBtn:(UIButton *)button
{
    [button setSelected:!button.isSelected];
    
    if (button.isSelected) {
        self.hasSelectedExemptionBoolNum = [NSNumber numberWithBool:YES];
    } else {
        self.hasSelectedExemptionBoolNum = nil;
    }
}


#pragma mark - Private Methods

- (void)createPasswordAlertView
{
    HXSPayPasswdView *alertView = [self createPayPasswordView];
    
    [alertView layoutIfNeeded];
    
    self.alertView = alertView;
    
    _customIOSAlertView = [[CustomIOSAlertView alloc] init];
    self.customIOSAlertView.containerView = self.alertView;
    self.customIOSAlertView.buttonTitles = nil;
    self.customIOSAlertView.useMotionEffects = YES;
}

- (HXSPayPasswdView *)createPayPasswordView
{
    NSArray *viewsArr = [[NSBundle mainBundle] loadNibNamed:@"HXSPayPasswdView"
                                                      owner:nil
                                                    options:nil];
    HXSPayPasswdView *alertView = [viewsArr firstObject];
    
    alertView.autoresizingMask = NO;
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 7; // set to same kCustomIOSAlertViewCornerRadius in CustomIOSAlertView
    alertView.titleLabel.text = self.titleStr;
    
    if (nil == self.titleStr
        || [@"" isEqualToString:self.titleStr]) {
        alertView.titleLabel.hidden = YES;
    }
    
    [self setupFrameOfAlertView:alertView];
    
    return alertView;
}

- (void)setupFrameOfAlertView:(HXSPayPasswdView *)alertView
{
    CGFloat width;
    if (320 == SCREEN_WIDTH) {// iphone4s, 5, 5c, 5s
        width = SCREEN_WIDTH - 2 * BLANK_DISTANT_SCREEN_SMALLER;
    } else {
        width = SCREEN_WIDTH - 2 * BLANK_DISTANT_SCREEN_BIGGER;
    }
    
    // set up message label
    if ((nil == self.messageStr)
        || (0 >= [self.messageStr length])) {
        CGRect frame = alertView.frame;
        frame.size.width = width;
        frame.size.height -= alertView.messageLabel.frame.size.height;
        alertView.frame = frame;
        
        [alertView.messageLabel removeFromSuperview];
        [alertView.passwdField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertView.titleLabel.mas_bottom).with.mas_offset(PADDING);
        }];
        
    } else {
        // create message attttibutes string
        NSAttributedString *messageAttributeStr = [self createMessageLabelAttributedString];
        alertView.messageLabel.attributedText = messageAttributeStr;
        
        CGFloat messagelabelWidth = width - alertView.messageLabel.frame.origin.x * 2;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.lineSpacing = 5;
        NSDictionary *attributes = @{NSFontAttributeName:alertView.messageLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
        
        CGSize maxSize = CGSizeMake(messagelabelWidth, MAXFLOAT);
        CGSize labelSize = [self.messageStr boundingRectWithSize:maxSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                      attributes:attributes
                                                         context:nil].size;
        
        CGRect frame = alertView.frame;
        frame.size.width = width;
        if (labelSize.height > alertView.messageLabel.frame.size.height) {
            frame.size.height += labelSize.height - alertView.messageLabel.frame.size.height;
        }
        
        alertView.frame = frame;
    }
    
}

- (void)setupExemptionViewInAlertView
{
    [self.alertView.exemptionBtn setImage:[UIImage imageNamed:@"btn_choose_empty"]
                            forState:UIControlStateNormal];
    [self.alertView.exemptionBtn setImage:[UIImage imageNamed:@"btn_choose_blue"]
                            forState:UIControlStateSelected];
    [self.alertView.exemptionBtn setSelected:NO];
    
    [self.alertView.exemptionBtn addTarget:self
                               action:@selector(onClickExemptionBtn:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    if ((nil == self.displayExemptionBtnBoolNum)
        || ![self.displayExemptionBtnBoolNum boolValue]) {
        // don't display
        CGRect frame = self.alertView.frame;
        frame.size.height -= self.alertView.exemptionView.frame.size.height;
        self.alertView.frame = frame;
        
        [self.alertView.exemptionView removeFromSuperview];
        [self.alertView.topButtonLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView.passwdField.mas_bottom).with.mas_offset(PADDING);
        }];
    }
}


- (NSAttributedString *)createMessageLabelAttributedString
{
    NSMutableAttributedString *mAttributedStr = [[NSMutableAttributedString alloc] initWithString:self.messageStr];
    
    NSRange rangeChinese = [self.messageStr rangeOfString:@"（"];
    if (NSNotFound == rangeChinese.location) {
        NSRange rangeEnglish = [self.messageStr rangeOfString:@"("];
        if (NSNotFound == rangeEnglish.location) {
            return mAttributedStr;
        } else {
            NSRange rangeChange = NSMakeRange(rangeEnglish.location, ([self.messageStr length] - rangeEnglish.location));
            [mAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangeChange];
        }
    } else {
        NSRange rangeChange = NSMakeRange(rangeChinese.location, ([self.messageStr length] - rangeChinese.location));
        [mAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangeChange];
    }
    
    
    return mAttributedStr;
}


@end
