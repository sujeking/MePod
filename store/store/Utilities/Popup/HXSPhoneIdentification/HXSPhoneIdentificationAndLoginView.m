//
//  HXSPhoneIdentificationAndLoginView.m
//  store
//
//  Created by ArthurWang on 15/9/15.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPhoneIdentificationAndLoginView.h"

#import "HXSPhoneIdentificationView.h"
#import "CustomIOSAlertView.h"
#import "HXSPersonalInfoModel.h"


#define PADDING               20
#define WIDTH_BUTTON_IPHONE5S 100

#define TAG_PHONE_TEXT_FILED           1000
#define LENGTH_VERIFICATION_CODE       6

@interface HXSPhoneIdentificationAndLoginView () <UITextFieldDelegate>

@property (nonatomic, strong) NSString *phoneNumberStr;
@property (nonatomic, copy) void (^block)(BOOL finished, NSString *message);

@property (nonatomic, strong) HXSPhoneIdentificationView *phoneIdentificationView;
@property (nonatomic, strong) CustomIOSAlertView *phoneIdentificationAlertView;

@property (nonatomic, assign) BOOL hasRegisteredFlag;   // 0 didn't register,  1 has registered

@end

@implementation HXSPhoneIdentificationAndLoginView

#pragma mark - Initial Methods

- (instancetype)initWithPhone:(NSString *)phoneNumberStr
                     finished:(void (^)(BOOL, NSString *))finished
{
    self = [super init];
    if (self) {
        self.phoneNumberStr = phoneNumberStr;
        self.block          = finished;
        
        [self setupIdentificationAlertView];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        [window addSubview:self];
    }
    
    return self;
}

- (void)dealloc
{
    self.phoneNumberStr = nil;
    self.block = nil;
}


#pragma mark - Setter Getter Methods

- (void)setupIdentificationAlertView
{
    _phoneIdentificationAlertView = nil;
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    alertView.containerView = self.phoneIdentificationView;
    alertView.buttonTitles = nil;
    alertView.useMotionEffects = YES;
    
    _phoneIdentificationAlertView = alertView;
}

- (HXSPhoneIdentificationView *)phoneIdentificationView
{
    if (nil == _phoneIdentificationView) {
        HXSPhoneIdentificationView *phoneIdentificationView = [[[NSBundle mainBundle] loadNibNamed:@"HXSPhoneIdentificationView"
                                                                                             owner:nil
                                                                                           options:nil] firstObject];
        [phoneIdentificationView.fecthIdentifierBtn addTarget:self
                                                       action:@selector(onClickFetchIdentifierBtn:)
                                             forControlEvents:UIControlEventTouchUpInside];
        [phoneIdentificationView.sendIdentificationBtn addTarget:self
                                                          action:@selector(onClickSendIdentificationBtn:)
                                                forControlEvents:UIControlEventTouchUpInside];
        [phoneIdentificationView.cancelBtn addTarget:self
                                              action:@selector(onClickCancelBtn:)
                                    forControlEvents:UIControlEventTouchUpInside];
        [phoneIdentificationView.fecthIdentifierBtn countingSeconds:MESSAGE_CODE_WAITING_TIME];
        phoneIdentificationView.phoneTextField.tag = TAG_PHONE_TEXT_FILED;
        phoneIdentificationView.phoneTextField.delegate = self;
        [phoneIdentificationView.phoneTextField setTintColor:[UIColor grayColor]];
        
        [phoneIdentificationView.sendIdentificationBtn setEnabled:NO];
        
        if (SCREEN_WIDTH == 320) { // 320 is width of iphone4s, iphone5, iphone5c, iphone5s
            phoneIdentificationView.cancelBtnConstraint.constant = WIDTH_BUTTON_IPHONE5S;
        }
        
        _phoneIdentificationView = phoneIdentificationView;
    }
    
    CGFloat padding = 25.0;
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2*padding, 217);
    
    _phoneIdentificationView.frame = frame;
    
    [_phoneIdentificationView layoutIfNeeded];
    
    return _phoneIdentificationView;
}


#pragma mark - Public Methods

- (void)start
{
    if (nil == self.phoneNumberStr
        || ![self.phoneNumberStr isValidCellPhoneNumber]) {
        
        [self finishPhoneIdentification:NO message:@"请输入手机号"];
        return;
    }
    
    [self sendIdenfication];
}

- (void)end
{
    [self removeFromSuperview];
}

- (void)finishPhoneIdentification:(BOOL)success message:(NSString *)message
{
    self.block(success, message);
    
    [self end];
}


#pragma mark - Target Methods

- (void)onClickFetchIdentifierBtn:(HSSVerifyButton *)button
{
    if (button.isCounting) {
        return;
    }
    
    [self sendIndeficationWhenhasShownAlertView];
    [button countingSeconds:MESSAGE_CODE_WAITING_TIME];
}

- (void)onClickSendIdentificationBtn:(UIButton *)button
{
    if ((nil == self.phoneIdentificationView.phoneTextField.text)
        || (0 >= [self.phoneIdentificationView.phoneTextField.text length])) {
        self.phoneIdentificationView.phoneTextField.placeholder = @"验证码不能为空";
        
        return;
    }
    
    self.phoneIdentificationView.phoneTextField.placeholder = @"请输入验证码";
    
    // send code
    [self sendVerificationCode:_phoneIdentificationView.phoneTextField.text];
    
}

- (void)onClickCancelBtn:(UIButton *)button
{
    [self.phoneIdentificationAlertView close];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (LENGTH_VERIFICATION_CODE == [textField.text length]) {
        [self.phoneIdentificationView.sendIdentificationBtn setEnabled:YES];
    } else {
        [self.phoneIdentificationView.sendIdentificationBtn setEnabled:NO];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (TAG_PHONE_TEXT_FILED == textField.tag) {
        self.phoneIdentificationView.phoneTextField.placeholder = @"请输入验证码";
        
        NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:textField.text];
        [mutableStr replaceCharactersInRange:range withString:string];
        
        if (LENGTH_VERIFICATION_CODE < [mutableStr length]) {
            return NO;
        } else {
            if (LENGTH_VERIFICATION_CODE == [mutableStr length]) {
                [self.phoneIdentificationView.sendIdentificationBtn setEnabled:YES];
            } else {
                [self.phoneIdentificationView.sendIdentificationBtn setEnabled:NO];
            }
            
            return YES;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.phoneIdentificationView.sendIdentificationBtn setEnabled:NO];
    
    return YES;
}

#pragma mark - Connect Service

- (void)showPhoneIdentificationView
{
    // 手机号可能更改,每次弹出来时刷新
    self.phoneIdentificationView.titleLabel.text = [NSString stringWithFormat:@"手机验证(%@)", [self.phoneNumberStr addSegmentPhoneNumber]];
    if (self.hasRegisteredFlag) {
        self.phoneIdentificationView.alertContentLabel.text = @"验证成功后，将自动登录并完成下单";
    } else {
        self.phoneIdentificationView.alertContentLabel.text = @"验证成功后，将自动创建59账号并完成下单";
    }

    self.phoneIdentificationView.phoneTextField.placeholder = @"输入验证码";
    self.phoneIdentificationView.phoneTextField.text = @"";
    [self.phoneIdentificationView.phoneTextField becomeFirstResponder];
    [self.phoneIdentificationView.fecthIdentifierBtn countingSeconds:MESSAGE_CODE_WAITING_TIME];
    [self.phoneIdentificationView.sendIdentificationBtn setEnabled:NO];
    
    self.phoneIdentificationAlertView.containerView = self.phoneIdentificationView;
    
    [self.phoneIdentificationAlertView show];
}

- (void)sendIdenfication
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showInView:window];
    [HXSPersonalInfoModel sendAuthCodeWithPhone:self.phoneNumberStr
                                      verifyType:HXSVerifyAppLogin
                                        complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
                                          [MBProgressHUD hideHUDForView:window animated:YES];
                                          if (kHXSNoError != code) {
                                              [weakSelf finishPhoneIdentification:NO
                                                                      message:message];
                                              return ;
                                          }
                                          
                                          if (DIC_HAS_NUMBER(authInfo, @"register_flag")) {
                                              weakSelf.hasRegisteredFlag = [[authInfo objectForKey:@"register_flag"] boolValue];
                                          }
                                          
                                          [weakSelf showPhoneIdentificationView];
                                      }];
}

- (void)sendIndeficationWhenhasShownAlertView
{
    __weak typeof(self) weakSelf = self;
    
    [HXSPersonalInfoModel sendAuthCodeWithPhone:self.phoneNumberStr
                                      verifyType:HXSVerifyAppLogin
                                        complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
                                            if (kHXSNoError != code) {
                                                [weakSelf finishPhoneIdentification:NO
                                                                        message:message];
                                                
                                                return ;
                                            }
                                        }];
}

- (void)sendVerificationCode:(NSString *)codeStr
{
    [MBProgressHUD showInView:self];
    
    __weak typeof(self) weakSelf = self;
    [HXSPersonalInfoModel verifAuthCodeWithPhone:self.phoneNumberStr
                                            code:codeStr
                                      verifyType:HXSVerifyAppLogin
                                        complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
                                            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
                                            if (kHXSNoError != code) {
                                                weakSelf.phoneIdentificationView.phoneTextField.text = nil;
                                                weakSelf.phoneIdentificationView.phoneTextField.placeholder = @"验证码有误,请重新输入";
                                                weakSelf.phoneIdentificationView.phoneTextField.font = [UIFont systemFontOfSize:13];
                                                [weakSelf.phoneIdentificationView.sendIdentificationBtn setEnabled:NO];
                                                
                                                return;
                                            }
                                            [weakSelf.phoneIdentificationAlertView close];
                                            
                                            [weakSelf displayVerifyCompelte];
                                        }];
}

#pragma mark - Display Verify Done

- (void)displayVerifyCompelte
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 60)]; // frame is set with UI
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"验证完成！";
    label.textColor = HXS_INFO_NOMARL_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    
    CustomIOSAlertView *verifyAlertView = [[CustomIOSAlertView alloc] init];
    verifyAlertView.containerView = label;
    verifyAlertView.buttonTitles = nil;
    verifyAlertView.useMotionEffects = YES;
    
    [verifyAlertView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [verifyAlertView close];
        
        [self finishPhoneIdentification:YES message:nil];
    });
}

@end
