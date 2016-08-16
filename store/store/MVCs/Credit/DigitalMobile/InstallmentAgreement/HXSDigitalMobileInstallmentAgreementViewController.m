//
//  HXSDigitalMobileInstallmentAgreementViewController.m
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileInstallmentAgreementViewController.h"
#import "HXSPayPasswordAlertView.h"
#import "HXSAgreementModel.h"
@interface HXSDigitalMobileInstallmentAgreementViewController ()<HXSPayPasswordAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) HXSAgreementModel *agreementModel;
@end

@implementation HXSDigitalMobileInstallmentAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"分期电子协议";
    
    self.view.backgroundColor = [UIColor colorWithRGBHex: 0xF4F5F6];
    NSURL *url = [NSURL URLWithString:[[ApplicationSettings instance] currentMobileStagingAgreementURL]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agree:(id)sender
{
    HXSPayPasswordAlertView *alert = [[HXSPayPasswordAlertView alloc] initWithTitle:@"支付密码验证"
                                                                            message:@""
                                                                           delegate:self
                                                                    leftButtonTitle:@"取消"
                                                                  rightButtonTitles:@"确定"];
    
    [alert show];
}


#pragma mark - HXSPayPasswordAlertViewDelegate

- (void)alertView:(HXSPayPasswordAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex passwd:(NSString *)passwd exemptionStatus:(NSNumber *)hasSelectedExemptionBoolNum
{
    if (1 == buttonIndex) {
        [alertView  close];
        [self checkInstallmentPwd:[NSString md5:passwd]];
    }
    
    if (0 == buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 分期密码验证

- (void)checkInstallmentPwd:(NSString *)pwdStr
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.agreementModel validatePayPWD:pwdStr Complete:^(HXSErrorCode code, NSString *message, NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (kHXSNoError == code) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            if ([weakSelf.delegate respondsToSelector:@selector(didPassPWD)]) {
                [weakSelf.delegate performSelector:@selector(didPassPWD) withObject:nil];
            }
            
        } else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒" message:message leftButtonTitle:@"确定" rightButtonTitles:nil];
            [alertView show];
        }
    }];
    
}


#pragma mark - Setter Getter Methods

- (HXSAgreementModel *)agreementModel
{
    if (nil == _agreementModel) {
        _agreementModel = [[HXSAgreementModel alloc] init];
    }
    
    return _agreementModel;
}

- (void)dealloc
{
    
}
@end
