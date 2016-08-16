//
//  HXSPhoneLoginViewController.m
//  store
//
//  Created by chsasaw on 15/4/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPhoneLoginViewController.h"

#import "HXSLoginViewController.h"
#import "HXSRegisterVerifyButton.h"
#import "HXStoreLogin.h"


#define LENGTH_CELL_PHONE              11
#define VERIFIED_CODE_MAX_LENGTH       6

@interface HXSPhoneLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet HXSRegisterVerifyButton *verifyBtn;
@property (nonatomic, assign) IBOutlet UIButton *loginBtn;
@property (nonatomic, assign) IBOutlet UITextField *phoneTextField;
@property (nonatomic, assign) IBOutlet UITextField *verifyTextField;

@property (nonatomic, assign) BOOL hasRegisteredFlag;   // 0 didn't register,  1 has registered

@end

@implementation HXSPhoneLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationStatus];
    
    [self initialTextFieldAndButtons];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.phoneTextField.delegate  = nil;
    self.verifyTextField.delegate = nil;
}

#pragma mark - Initial Methods

- (void)initialNavigationStatus
{
    self.navigationItem.title = @"短信验证码登录";
    
    [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"btn_back_normal"]];
    [self.navigationItem.leftBarButtonItem setTitle:@""];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 5);
}

- (void)initialTextFieldAndButtons
{
    self.phoneTextField.layer.masksToBounds = YES;
    self.phoneTextField.delegate = self;
    self.phoneTextField.returnKeyType = UIReturnKeyNext;
    self.phoneTextField.tintColor = HXS_TEXT_COLOR;
    [self.phoneTextField addTarget:self action:@selector(checkPhoneAndVerifyCodeInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
    self.verifyTextField.layer.masksToBounds = YES;
    self.verifyTextField.delegate = self;
    self.verifyTextField.returnKeyType = UIReturnKeyDone;
    self.verifyTextField.tintColor = HXS_TEXT_COLOR;
    [self.verifyTextField addTarget:self action:@selector(checkPhoneAndVerifyCodeInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
    self.verifyBtn.enabled = NO;
}

- (void)checkPhoneAndVerifyCodeInfoValidation
{
    if (!_verifyBtn.isCounting) {
        _verifyBtn.enabled = (_phoneTextField.text.length == 11);
    }
}


#pragma mark - Target Methods

- (IBAction)onClickGetVerifyCode:(HXSRegisterVerifyButton *)button
{
    if (button.isCounting) {
        return;
    }
    
    [self.phoneTextField resignFirstResponder];
    
    if (self.phoneTextField.text.length > 0)
    {
        [self sendIdenfication];
        [button countingSeconds:MESSAGE_CODE_WAITING_TIME];
    }
}

- (IBAction)onLogInClicked:(id)sender
{
    [self hidenKeyboard];
    
    if(LENGTH_CELL_PHONE > [self.phoneTextField.text length]) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入11位手机号码" afterDelay:1.0];
        
        return;
    }else if(VERIFIED_CODE_MAX_LENGTH > [self.verifyTextField.text length]) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入6位验证码" afterDelay:1.0];
        
        return;
    } else {
        // Do nothing
    }
    
    [self sendVerificationCode];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        [self.phoneTextField resignFirstResponder];
        [self.verifyTextField becomeFirstResponder];
    } else if (textField == self.verifyTextField) {
        [self.verifyTextField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMStr replaceCharactersInRange:range withString:string];
    
    if (textField == self.phoneTextField) {
        if (LENGTH_CELL_PHONE < [resultMStr length]) {
            return NO;
        }
    } else if (textField == self.verifyTextField) {
        if (VERIFIED_CODE_MAX_LENGTH < [resultMStr length] ) {
            return NO;
        }
    }
    
    if (textField.isSecureTextEntry) {
        textField.text = resultMStr;
        
        return NO;
    }
    
    return YES;
}

- (void)hidenKeyboard
{
    [self.view endEditing:YES];

    [self.phoneTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
}


#pragma mark - Connect Service

- (void)sendIdenfication
{
    [MBProgressHUD showInView:self.view];
    [HXSPersonalInfoModel sendAuthCodeWithPhone:self.phoneTextField.text
                                     verifyType:HXSVerifyAppLogin
                                       complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           if (kHXSNoError != code) {
                                               [MBProgressHUD showInViewWithoutIndicator:self.view
                                                                                  status:message
                                                                              afterDelay:2.0];

                                               return ;
                                           }
                                           
                                           if (DIC_HAS_NUMBER(authInfo, @"register_flag")) {
                                               self.hasRegisteredFlag = [[authInfo objectForKey:@"register_flag"] boolValue];
                                           }
                                       }];
}

- (void)sendVerificationCode
{
    [MBProgressHUD showInView:self.view];
    [HXSPersonalInfoModel verifAuthCodeWithPhone:self.phoneTextField.text
                                            code:self.verifyTextField.text
                                      verifyType:HXSVerifyAppLogin
                                        complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                            if (kHXSNoError != code) {
                                                self.verifyTextField.text = nil;
                                                [MBProgressHUD showInViewWithoutIndicator:self.view
                                                                                   status:message
                                                                               afterDelay:1.0];
                                                
                                                return;
                                            }
                                            
                                            [self loginComplete];
                                        }];
}

#pragma mark - Display Verify Done

- (void)loginComplete
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (self.hasRegisteredFlag) {
        [MBProgressHUD showDrawInViewWithoutIndicator:self.view status:@"登录成功" afterDelay:1.0f];
    } else {
        [MBProgressHUD showDrawInViewWithoutIndicator:self.view status:@"注册成功" afterDelay:1.0];
    }
    
    // update user info in basic info class.
    [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BEGIN_MAIN_THREAD
        HXSLoginViewController *loginVc = (HXSLoginViewController*)[self.navigationController firstViewControllerOfClass:@"HXSLoginViewController"];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [loginVc actionCompletion];
        }];
        END_MAIN_THREAD
    });
    
    

}

@end
