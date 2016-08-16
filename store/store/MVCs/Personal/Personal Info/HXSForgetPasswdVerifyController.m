//
//  HXSForgetPasswdVerifyController.m
//  store
//
//  Created by hudezhi on 15/9/21.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSForgetPasswdVerifyController.h"

// Views
#import "HXSRegisterVerifyButton.h"

// Model
#import "HXSPersonalInfoModel.h"


#define VERIFIED_CODE_MAX_LENGTH 6


@interface HXSForgetPasswdVerifyController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@property (weak, nonatomic) IBOutlet HXSRegisterVerifyButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *findBackBtn;
- (IBAction)getVerifyCode:(id)sender;

@end

@implementation HXSForgetPasswdVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"忘记支付密码";
    self.tableView.tintColor = [UIColor colorWithRGBHex:0x0065CD];
    
    [self setupTextFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    
    if (basicInfo.phone.length > 1) {
        _phoneTextField.text = basicInfo.phone;
        _phoneTextField.enabled = NO;
    }
    else {
        _phoneTextField.enabled = YES;
    }
    
    [self checkButtonAbility];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    
    if (basicInfo.phone.length < 1) {
        
        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                          message:@"您还未绑定过手机，请先去绑定。"
                                                                  leftButtonTitle:@"取消"
                                                                rightButtonTitles:@"去绑定"];
        alertView.rightBtnBlock = ^ {
            [self jumpToBindTelephone];
        };
        
        alertView.leftBtnBlock = ^ {
            
        };
        
        [alertView show];
        
        return;
    }
}

- (void)dealloc
{
    self.verifyCodeTextField.delegate = nil;
}

#pragma mark - override

- (void)back
{
    if ([self.navigationController containedController:@"HXSPersonalInfoTableViewController"]) {
        [self backToController:@"HXSPersonalInfoTableViewController"];
    }
    else {
        [self backToControllerBeforeController:NSStringFromClass([self class])];
    }
}

#pragma mark - private method

- (void)setupTextFields
{
    self.verifyCodeTextField.delegate = self;
    
    [_phoneTextField addTarget:self action:@selector(checkButtonAbility) forControlEvents:UIControlEventEditingChanged];
    [_verifyCodeTextField addTarget:self action:@selector(checkButtonAbility) forControlEvents:UIControlEventEditingChanged];
    
    [self checkButtonAbility];
}

- (void)checkButtonAbility
{
    _verifyBtn.enabled = (_phoneTextField.text.length == 11);
    _findBackBtn.enabled = (_phoneTextField.text.length == 11) && (_verifyCodeTextField.text.length == 6);
}

- (void)jumpToBindTelephone
{
    if (self.navigationController) {
        HXSForgetPasswdVerifyController *passwdVc = [self.storyboard instantiateViewControllerWithIdentifier:@"HXSBindTelephoneController"];
        [self.navigationController pushViewController:passwdVc animated:YES];
    }
}

#pragma mark - Target Methods

- (IBAction)getVerifyCode:(id)sender {
    [_verifyBtn countingSeconds:MESSAGE_CODE_WAITING_TIME];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [MBProgressHUD showInView:window];
    [HXSPersonalInfoModel sendAuthCodeWithPhone: _phoneTextField.text verifyType: HXSVerifyForgetPayPasswd complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (code != kHXSNoError) {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:@"请先绑定手机号"
                                                                      leftButtonTitle:@"确定"
                                                                    rightButtonTitles:nil];
            [alertView show];
            self.verifyCodeTextField.text = nil;
            [self checkButtonAbility];
        }
        else {
            DLog(@"---------- Send message success");
        }
    }];
}

- (IBAction)getPasswordBack:(id)sender {
    [self.view endEditing:YES];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [MBProgressHUD showInView:window];
    [HXSPersonalInfoModel verifyTelephoneForForgetPayPasswd:_phoneTextField.text verifyCode: _verifyCodeTextField.text completion:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (code == kHXSNoError) {
            [self performSegueWithIdentifier:@"HXSForgetPasswdResetSegue" sender:nil];
        }
        else {
            [MBProgressHUD showInViewWithoutIndicator:window status:message afterDelay:1.0f];
            
            self.verifyCodeTextField.text = nil;
            [self checkButtonAbility];
        }
    }];
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
    label.text = @"请先验证绑定手机号";
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = [UIColor colorWithRGBHex:0x999999];
    
    [header addSubview:label];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMStr replaceCharactersInRange:range withString:string];
    
    if (VERIFIED_CODE_MAX_LENGTH < [resultMStr length]) {
        return NO;
    }
    
    return YES;
}



@end
