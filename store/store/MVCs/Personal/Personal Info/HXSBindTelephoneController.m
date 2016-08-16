//
//  HXSBindTelephoneController.m
//  store
//
//  Created by hudezhi on 15/9/21.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSBindTelephoneController.h"

// Views
#import "HXSRegisterVerifyButton.h"
#import "HXSBindTelephoneFooterView.h"

// Model
#import "HXSPersonalInfoModel.h"


#define VERIFIED_CODE_MAX_LENGTH 6
#define IPHONE_NUMBER_MAX_LENGTH 11


@interface HXSBindTelephoneController () <UITextFieldDelegate>
{
    HXSBindTelephoneFooterView *_bindFooterView;
}

@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet HXSRegisterVerifyButton *verifyBtn;

@property (weak, nonatomic) IBOutlet UILabel *telephoneTitleLabel;

@end

@implementation HXSBindTelephoneController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    
    _bindFooterView = [HXSBindTelephoneFooterView bindTelephoneFooterView];
    _bindFooterView.isUpdate = _isUpdate;
    
    if (_isUpdate) {
        self.title = @"更换绑定";
        _telephoneTitleLabel.text = @"原绑定手机";
        _telephoneTextField.text = basicInfo.phone;
        _telephoneTextField.enabled = NO;
        [_bindFooterView.nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else{
        self.title = @"手机绑定";
        _telephoneTitleLabel.text = @"新手机号";
        [_bindFooterView.nextStepBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    
    [_bindFooterView.nextStepBtn addTarget:self action:@selector(nextStepBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bindFooterView.serviceCallBtn addTarget:self action:@selector(bindTelephoneServiceCallBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupTextFields];
    self.tableView.tintColor = [UIColor colorWithRGBHex:0x0065CD];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _bindFooterView.frame = CGRectMake(0, 0, self.tableView.width, self.tableView.height - 90 - 114);
    self.tableView.tableFooterView = _bindFooterView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.telephoneTextField.delegate  = nil;
    self.verifyCodeTextField.delegate = nil;
}

#pragma mark - override

- (void)back
{
    if ([self.navigationController containedController:@"HXSForgetPasswdVerifyController"]) {
        [self backToControllerBeforeController:@"HXSForgetPasswdVerifyController"];
    }
    else if ([self.navigationController containedController:@"HXSPersonalInfoTableViewController"]) {
        [self backToController:@"HXSPersonalInfoTableViewController"];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - private method

- (void)setupTextFields
{
    self.telephoneTextField.delegate  = self;
    self.verifyCodeTextField.delegate = self;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, tableView.width - 15.0, 50)];
    label.text = _isUpdate ? @"请先验证原绑定手机号" : @"请输入新的手机号，并验证";
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = [UIColor colorWithRGBHex:0x999999];
    
    [header addSubview:label];
    
    return header;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMStr replaceCharactersInRange:range withString:string];
    
    if (textField == self.verifyCodeTextField) {
        if (VERIFIED_CODE_MAX_LENGTH < [resultMStr length]) {
            return NO;
        }
    } else if (textField == self.telephoneTextField) {
        if (IPHONE_NUMBER_MAX_LENGTH < [resultMStr length]) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - target/action

- (IBAction)getVerifyCode:(id)sender {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (_telephoneTextField.text.length != 11) {
        [MBProgressHUD showInViewWithoutIndicator:window status:@"输入正确的手机号" afterDelay:2.0];
        return;
    }
    
    [_verifyBtn countingSeconds:MESSAGE_CODE_WAITING_TIME];
    
    [HXSLoadingView showLoadingInView:window];
    [HXSPersonalInfoModel sendAuthCodeWithPhone: _telephoneTextField.text verifyType: HXSVerifyPhoneBind complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
        [HXSLoadingView closeInView:window];
        if (code != kHXSNoError) {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:message
                                                                      leftButtonTitle:@"确定"
                                                                    rightButtonTitles:nil];
            [alertView show];
            self.verifyCodeTextField.text = nil;
        }
        else {
            DLog(@"---------- Send message success");
        }
    }];
}

- (void)nextStepBtnPressed:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (_telephoneTextField.text.length != 11) {
        [MBProgressHUD showInViewWithoutIndicator:window status:@"输入正确的手机号" afterDelay:2.0];
        return;
    }
    
    if (_verifyCodeTextField.text.length != 6) {
        [MBProgressHUD showInViewWithoutIndicator:window status:@"输入6位数字验证码" afterDelay:2.0];
        return;
    }
    
    [self.view endEditing:YES];
    if (_isUpdate) {
        [HXSPersonalInfoModel verifyOldBindTelephone:_telephoneTextField.text verifyCode:_verifyCodeTextField.text completion:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
            if (code == kHXSNoError) {
                [self performSegueWithIdentifier:@"HXSUpdateBindTelephoneSegue" sender:nil];
            }
            else {
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                  message:message
                                                                          leftButtonTitle:@"确定"
                                                                        rightButtonTitles:nil];
                [alertView show];
                self.verifyCodeTextField.text = nil;
            }
        }];
    }
    else {
        [HXSPersonalInfoModel modifyBindTelephone:_telephoneTextField.text verifyCode:_verifyCodeTextField.text completion:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
            if (code == kHXSNoError) {
                HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
                HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
                basicInfo.phone = _telephoneTextField.text;
                
                [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
                
                [self backToController:@"HXSPersonalInfoTableViewController"];
            }
            else {
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                  message:message
                                                                          leftButtonTitle:@"确定"
                                                                        rightButtonTitles:nil];
                [alertView show];
                self.verifyCodeTextField.text = nil;
            }
        }];
    }
}

- (void)bindTelephoneServiceCallBtnPressed
{
    [self.view endEditing:YES];
    
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc] initWithTitle:@"提示" message:@"拨打 4001185959 吗?" leftButtonTitle:@"取消" rightButtonTitles:@"确定"];
    alert.rightBtnBlock = ^{
        NSString *phoneNumber = @"tel://4001185959";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

    };
    
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
