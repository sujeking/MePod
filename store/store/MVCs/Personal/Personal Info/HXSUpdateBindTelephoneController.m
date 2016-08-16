//
//  HXSUpdateBindTelephoneController.m
//  store
//
//  Created by hudezhi on 15/9/21.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSUpdateBindTelephoneController.h"
#import "HXSRegisterVerifyButton.h"
#import "HXSPersonalInfoModel.h"

@interface HXSUpdateBindTelephoneController ()
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@property (weak, nonatomic) IBOutlet HXSRegisterVerifyButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;

@end

@implementation HXSUpdateBindTelephoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"更换绑定";
    
    [self setupTextFields];
    
    self.tableView.tintColor = [UIColor colorWithRGBHex:0x0065CD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)back
{
    if ([self.navigationController containedController:@"HXSPersonalInfoTableViewController"]) {
        [self backToController:@"HXSPersonalInfoTableViewController"];
    }
    else {
        [self backToControllerBeforeController:@"HXSForgetPasswdVerifyController"];
    }
}

#pragma mark - private method

- (void)setupTextFields
{
    [_telephoneTextField addTarget:self action:@selector(checkButtonAbility) forControlEvents:UIControlEventEditingChanged];
    [_verifyCodeTextField addTarget:self action:@selector(checkButtonAbility) forControlEvents:UIControlEventEditingChanged];
    
    [self checkButtonAbility];
}

- (void)checkButtonAbility
{
    _verifyBtn.enabled = (_telephoneTextField.text.length == 11);
    _applyBtn.enabled = (_telephoneTextField.text.length == 11) && (_verifyCodeTextField.text.length > 0);
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
    label.text = @"请输入新的手机号，并验证";
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = [UIColor colorWithRGBHex:0x999999];
    
    [header addSubview:label];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - target/action

- (IBAction)verifyCodeBtnPressed:(id)sender {
    
    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    NSString* bindPhone = basicInfo.phone;
    
    if ([bindPhone isEqualToString:_telephoneTextField.text]) {
        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                          message:@"该手机已绑定"
                                                                  leftButtonTitle:@"确定"
                                                                rightButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [_verifyBtn countingSeconds:MESSAGE_CODE_WAITING_TIME];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [MBProgressHUD showInView:window];
    [HXSPersonalInfoModel sendAuthCodeWithPhone: _telephoneTextField.text verifyType: HXSVerifyPhoneBind complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (code != kHXSNoError) {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:message
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

- (IBAction)applyNewBindTelephone:(id)sender {

    [HXSPersonalInfoModel modifyBindTelephone: _telephoneTextField.text verifyCode:_verifyCodeTextField.text completion:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
        if (code == kHXSNoError) {
            HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
            HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
            basicInfo.phone = _telephoneTextField.text;
            
            [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
            
            [self back];
        }
        else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:message
                                                                      leftButtonTitle:@"确定"
                                                                    rightButtonTitles:nil];
            [alertView show];
            self.verifyCodeTextField.text = nil;
            [self checkButtonAbility];
        }
    }];
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
