//
//  HXSPhoneRegisterSetPasswdViewController.m
//  store
//
//  Created by hudezhi on 15/11/10.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSPhoneRegisterSetPasswdViewController.h"

#import "HXSPersonalInfoModel.h"
#import "HXStoreLogin.h"
#import "UIViewController+Extensions.h"


#define PASSWORD_MAX_LENGTH    20

@interface HXSPhoneRegisterSetPasswdViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic) BOOL isRegisting;

@end

@implementation HXSPhoneRegisterSetPasswdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _registerBtn.enabled = NO;
    self.passwdTextField.tintColor = HXS_TEXT_COLOR;
    [self.passwdTextField addTarget:self action:@selector(checkPasswordValidation) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark - override

- (void)back
{
    if (_isRegisting)
    {
        return ;
    }
    
    [self.view endEditing:YES];
    [super back];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginComplete:) name:kLoginCompleted object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginCompleted object:nil];
}

#pragma mark - private method

- (void)checkPasswordValidation
{
    _registerBtn.enabled = ([_passwdTextField.text trim].length >= 6);
}

- (void)hide
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - target/action

- (IBAction)registerBtnPressed:(id)sender
{
    [self.view endEditing:YES];
    
    _isRegisting = YES;
    
    [MBProgressHUD showInView:self.view];
    
    [[HXSUserAccount currentAccount] registerWithPassword:self.passwdTextField.text];
}

- (IBAction)openPasswordClicked:(UIButton*)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_REGISTER_SHOW_PASSWORD parameter:@{@"status":@"不可见"}];
    } else {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_REGISTER_SHOW_PASSWORD parameter:@{@"status":@"可见"}];
    }
    
    self.passwdTextField.secureTextEntry = btn.selected;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    NSMutableString *resultMStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMStr replaceCharactersInRange:range withString:string];
    
    if (PASSWORD_MAX_LENGTH < [resultMStr length]) {
        return NO;
    }
    
    if (textField.isSecureTextEntry) {
        textField.text = resultMStr;
        
        return NO;
    }

    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - KVO

- (void)loginComplete:(NSNotification *)notification
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if([HXSUserAccount currentAccount].isLogin) {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_REGISTER parameter:@{@"status":@"成功"}];
        
        [MBProgressHUD showDrawInViewWithoutIndicator:self.view status:@"注册成功" afterDelay:1.0f];
        
        [self performSelector:@selector(hide) withObject:nil afterDelay:1.1];
    }else {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_REGISTER parameter:@{@"status":@"失败"}];
        if([notification.userInfo.allKeys containsObject:@"msg"]) {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:[notification.userInfo objectForKey:@"msg"] afterDelay:1.0];
        }else {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:@"注册失败!" afterDelay:1.0];
        }
    }
}


@end
