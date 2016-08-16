//
//  HXSForgetPasswdResetController.m
//  store
//
//  Created by hudezhi on 15/9/21.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSForgetPasswdResetController.h"

#import "HXSPersonalInfoModel.h"

@interface HXSForgetPasswdResetController ()

@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
- (IBAction)applyNewPasswd:(id)sender;

@end

@implementation HXSForgetPasswdResetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tintColor = [UIColor colorWithRGBHex:0x0065CD];
    
    [self setupTextFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTextFields
{
    [_passwdTextField addTarget:self action:@selector(checkButtonAbility) forControlEvents:UIControlEventEditingChanged];
}

- (void)checkButtonAbility
{
    _applyBtn.enabled = (_passwdTextField.text.length == 6);
}

- (IBAction)openPasswordClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    _passwdTextField.secureTextEntry = btn.selected;
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
    label.text = @"请设置6位数字的支付密码";
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = [UIColor colorWithRGBHex:0x999999];
    
    [header addSubview:label];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (IBAction)applyNewPasswd:(id)sender {
    [HXSPersonalInfoModel resetPayPassWord:_passwdTextField.text completion:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
        if (code == kHXSNoError) {
            if ([self.navigationController containedController:@"HXSPersonalInfoTableViewController"]) {
                [self backToController:@"HXSPersonalInfoTableViewController"];
            }
            else {
                [self backToControllerBeforeController:@"HXSForgetPasswdVerifyController"];
            }
        }
        else {
            
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:message
                                                                      leftButtonTitle:@"确定"
                                                                    rightButtonTitles:nil];
            [alertView show];

        }
    }];

}
@end
