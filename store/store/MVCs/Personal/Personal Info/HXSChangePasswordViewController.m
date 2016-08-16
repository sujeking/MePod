//
//  HXSChangePasswordViewController.m
//  store
//
//  Created by ranliang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSChangePasswordViewController.h"
#import "HXSWebViewController.h"

// Views

// Model
#import "HXSPersonalInfoModel.h"
#import "HXSPayPasswordUpdateModel.h"


#define PASSWORD_MAX_LENGTH    20

//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
//数字
#define NUM @"0123456789"

@interface HXSChangePasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *theNewPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswdBtn;
@property (weak, nonatomic) IBOutlet UILabel *theNewPasswordTipLabel;

@property (nonatomic, strong) HXSPersonalInfoModel *personalInfoModel;
@property (nonatomic, strong) HXSPayPasswordUpdateModel *payPasswordUpdateModel;

@end

@implementation HXSChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configMode];
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    [self updateSubmitButtonStatus];
    
    [self initialTextFieldStatus];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.oldPasswordTextField.delegate    = nil;
    self.theNewPasswordTextField.delegate = nil;
}


#pragma mark - Initial Methods

- (void)configMode
{
    switch (self.mode) {
        case HXSChangePasswordLogin: {
            self.title = _hasOldPassword ? @"修改登录密码" : @"设置登录密码";
            _forgetPasswdBtn.hidden = !_hasOldPassword;
            [_forgetPasswdBtn setTitle:@"忘记登录密码？" forState:UIControlStateNormal];
            break;
        }
            
        case HXSChangePasswordPay: {
            BOOL hasPayPasswd = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
            _forgetPasswdBtn.hidden = !hasPayPasswd;
            self.title = hasPayPasswd ? @"修改支付密码" : @"设置支付密码";
            [_forgetPasswdBtn setTitle:@"忘记支付密码？" forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
    
    NSString *submitTitle = _hasOldPassword ? @"提交修改" : @"完成设置";
    [_submitBtn setTitle:submitTitle forState:UIControlStateNormal];
    _theNewPasswordTipLabel.text = _hasOldPassword ? @"新密码" : @"输入密码";
}

- (void)initialTextFieldStatus
{
    self.oldPasswordTextField.delegate    = self;
    self.theNewPasswordTextField.delegate = self;
    
    if (self.mode == HXSChangePasswordLogin) {
        _oldPasswordTextField.placeholder = @"6-20位字母或数字";
        _theNewPasswordTextField.keyboardType = UIKeyboardTypeDefault;
        _theNewPasswordTextField.placeholder = @"6-20位字母或数字";
    }
    else {
        _oldPasswordTextField.placeholder = @"6位数字";
        _oldPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _theNewPasswordTextField.placeholder = @"6位数字";
        _theNewPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    
    [self.oldPasswordTextField setTintColor:[UIColor blackColor]];
    [self.theNewPasswordTextField setTintColor:[UIColor blackColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

#pragma mark - Target/Action

- (IBAction)openPasswordClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    _theNewPasswordTextField.secureTextEntry = btn.selected;
}

#pragma mark - Setter Getter Methods

- (HXSPersonalInfoModel *)personalInfoModel
{
    if (nil == _personalInfoModel) {
        _personalInfoModel = [[HXSPersonalInfoModel alloc] init];
    }
    
    return _personalInfoModel;
}

- (HXSPayPasswordUpdateModel *)payPasswordUpdateModel
{
    if (nil == _payPasswordUpdateModel) {
        _payPasswordUpdateModel = [[HXSPayPasswordUpdateModel alloc] init];
    }
    
    return _payPasswordUpdateModel;
}


#pragma mark - UITableViewDelegate / UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, tableView.width - 15.0, 50)];
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = [UIColor colorWithRGBHex:0x999999];
    if (_mode == HXSChangePasswordLogin) {
        label.text = _hasOldPassword ? @"请先输入原密码进行验证，再设置新密码" : @"请设置6-20位字母或数字";
    }
    else {
        label.text = _hasOldPassword ? @"请先输入原密码进行验证，再设置新密码" : @"请设置6数字的支付密码";
    }
    
    [header addSubview:label];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.hasOldPassword) {
        return 1;
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *fixedIndexPath = indexPath;
    if(!_hasOldPassword) {
        fixedIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    }
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:fixedIndexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 17, 0, 0);
    
    return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.oldPasswordTextField) {
        [self.theNewPasswordTextField becomeFirstResponder];
        [self.oldPasswordTextField resignFirstResponder];
    }else if(textField == self.theNewPasswordTextField) {
        [self.theNewPasswordTextField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMStr replaceCharactersInRange:range withString:string];
    
    if (0 < [resultMStr length]) {
        BOOL result = [self validatePasswordString:resultMStr];
        
        if (!result) {
            return NO;
        }
    }
    
    if (PASSWORD_MAX_LENGTH < [resultMStr length]) {
        return NO;
    }
    
    if (textField.isSecureTextEntry) {
        textField.text = resultMStr;
        
        return NO;
    }
    
    return YES;
}


#pragma mark - Target Methods
- (IBAction)forgetPasswdBtnTapped:(id)sender {
    if (self.mode == HXSChangePasswordPay) {
        HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
        HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
        
        if (basicInfo.phone.length < 1) {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:@"请先绑定手机号"
                                                                      leftButtonTitle:@"确定"
                                                                    rightButtonTitles:nil];
            [alertView show];
            return;
        }
        
        [self performSegueWithIdentifier:@"HXSForgetPasswdVerifySegue" sender:nil];
    }
    else {
        HXSWebViewController *webVCtrl = [HXSWebViewController controllerFromXib];
        NSString *urlText = [[ApplicationSettings instance] currentForgetPasswordURL];
        webVCtrl.url = [NSURL URLWithString:urlText];
        [self.navigationController pushViewController:webVCtrl animated:YES];
    }
}

- (IBAction)submitButtonTapped:(UIButton *)sender
{
    [MBProgressHUD showInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    switch (self.mode) {
        case HXSChangePasswordPay:
        {
            self.payPasswordUpdateModel.oldPasswd = self.oldPasswordTextField.text;
            self.payPasswordUpdateModel.passwd = self.theNewPasswordTextField.text;
            
            [self.payPasswordUpdateModel updatePayPassWord:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                
                if (kHXSNoError != code) {
                    [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                       status:message
                                                   afterDelay:1.5f];
                    return ;
                }
                
                [HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum = [NSNumber numberWithInteger:1];
                // update user info in basic info class.
                [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
                
                [weakSelf performSegueWithIdentifier:@"changePasswdVCToPersonalInfoTableVC" sender:self];
            }];
        }
            break;
            
        case HXSChangePasswordLogin:
        {
            [self.personalInfoModel updateLoginPassword:self.oldPasswordTextField.text
                                                 passwd:self.theNewPasswordTextField.text
                                          comfirePasswd:self.theNewPasswordTextField.text
                                               complete:^(HXSErrorCode code, NSString *message, NSDictionary *passwordDic) {
                                                   [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                   
                                                   if (kHXSNoError != code) {
                                                       [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                          status:message
                                                                                      afterDelay:1.5f];
                                                       return ;
                                                   }
                                                   
                                                   HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
                                                   HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
                                                   basicInfo.passwordFlag = 1;
                                                   
                                                   // update user info in basic info class.
                                                   [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
                                                   
                                                   [weakSelf performSegueWithIdentifier:@"changePasswdVCToPersonalInfoTableVC" sender:weakSelf];
                                               }];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textField = [notification object];
    
    NSString *textStr = [NSString stringWithFormat:@"%@", textField.text];
    
    BOOL result = [self validatePasswordString:textStr];
    if (!result) {
        switch (self.mode) {
            case HXSChangePasswordLogin: {
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
                NSString *filteredStr = [[textStr componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                
                textField.text = filteredStr;
                
                break;
            }
                
            case HXSChangePasswordPay: {
                
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUM] invertedSet];
                NSString *filteredStr = [[textStr componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                
                textField.text = filteredStr;
                
                break;
            }
        }
    }
    
    [self updateSubmitButtonStatus];
}


#pragma mark - Private Methods

- (void)updateSubmitButtonStatus
{
    if (self.hasOldPassword) {
        if (_mode == HXSChangePasswordPay) {
            self.submitBtn.enabled = (self.oldPasswordTextField.text.length == 6) && (self.theNewPasswordTextField.text.length == 6);
        }
        else {
            self.submitBtn.enabled = ((self.oldPasswordTextField.text.length >= 6)
                                      && (self.oldPasswordTextField.text.length <= 20)
                                      && (self.theNewPasswordTextField.text.length >= 6)
                                      && (self.theNewPasswordTextField.text.length <= 20));
        }
    } else {
        if (_mode == HXSChangePasswordPay) {
            self.submitBtn.enabled = (self.theNewPasswordTextField.text.length == 6);
        }
        else {
            self.submitBtn.enabled = ((self.theNewPasswordTextField.text.length >= 6)
                                      && (self.theNewPasswordTextField.text.length <= 20));
        }
        
        self.oldPasswordTextField.text = nil;
    }
}

- (BOOL)validatePasswordString:(NSString *)resultMStr
{
    BOOL result = YES;
    
    switch (self.mode) {
        case HXSChangePasswordLogin: {
            NSString *regex = @"^[a-zA-Z0-9]+$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            result = [pred evaluateWithObject:resultMStr];
            
            break;
        }
            
        case HXSChangePasswordPay: {
            NSString *regex = @"^[0-9]+$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            result = [pred evaluateWithObject:resultMStr];
            
            break;
        }
    }
    
    return result;
}

@end
