//
//  HXSLoginViewController.m
//  store
//
//  Created by chsasaw on 14-10-16.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSLoginViewController.h"

#import "HXSSinaWeiboManager.h"
#import "HXSRenrenManager.h"
#import "HXSQQSdkManager.h"
#import "HXSWXApiManager.h"
#import "HXSPhoneRegisterViewController.h"
#import "HXStoreLogin.h"
#import "HXSMediator+HXWebviewModule.h"


#define PASSWORD_MAX_LENGTH    20

@interface HXSLoginViewController ()<HXSThirdAccountDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField * nameField;
@property (nonatomic, weak) IBOutlet UITextField * passwordField;

@property (nonatomic, weak) IBOutlet HXSRoundedButton * loginBtn;

@property (nonatomic, weak) IBOutlet UIButton * weiboBtn;
@property (nonatomic, weak) IBOutlet UIButton * qqBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * qqWidth;
@property (nonatomic, weak) IBOutlet UIButton * weixinBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * wexinWidth;
@property (nonatomic, weak) IBOutlet UIButton * renrenBtn;

@property (nonatomic, copy) LoginCompletion completion;
@property (nonatomic, copy) void (^loginCanceled)(void);

@end

@implementation HXSLoginViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"forget_pwd"]) {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_FORGET_PASSWORD parameter:nil];
    }
    else if ([segue.destinationViewController isKindOfClass: NSClassFromString(@"HXSPhoneLoginViewController")]) {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LOGIN_VERIFYCODE parameter:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.loginBtn.enabled = NO;
    
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.nameField.delegate = self;
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.nameField.tintColor = HXS_TEXT_COLOR;
    
    self.passwordField.delegate = self;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.tintColor = HXS_TEXT_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLoginStatus)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    if(![HXSQQSdkManager sharedManager].isQQInstalled) {
        self.qqWidth.constant = 0;
        self.qqBtn.hidden = YES;
    }
    
    self.weixinBtn.hidden = ![HXSWXApiManager sharedManager].isWechatInstalled;
    if(![HXSWXApiManager sharedManager].isWechatInstalled) {
        self.wexinWidth.constant = 0;
        self.weixinBtn.hidden = YES;
    }
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    self.passwordField.secureTextEntry = YES;
    
    UIImage *leftItemImage = [UIImage imageNamed:@"address_close"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftItemImage
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(back)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginComplete:) name:kLoginCompleted object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginCompleted object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
}

-(void)hidenKeyboard
{
    [self.nameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Methods

- (void)actionCompletion
{
    if(self.completion) {
        self.completion();
        self.completion = nil;
    }
}

+ (void)showLoginController:(UIViewController *)fromController loginCompletion: (LoginCompletion)completion
{
    [HXSLoginViewController showLoginController:fromController
                                loginCompletion:completion
                                  loginCanceled:nil];
}

+ (void)showLoginController:(UIViewController *)fromController
            loginCompletion: (LoginCompletion)completion
              loginCanceled:(void (^)(void))cancelCompletion
{
    if([HXSUserAccount currentAccount].isLogin) {
        completion();
        return;
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePathStr = [bundle pathForResource:@"HXStoreLogin" ofType:@"bundle"];
    if (0 < [bundlePathStr length]) {
        bundle = [NSBundle bundleWithPath:bundlePathStr];
    }
    
    UINavigationController * nav = [[UIStoryboard storyboardWithName:@"Login" bundle:bundle] instantiateViewControllerWithIdentifier:@"HXSLoginViewControllerNavigation"];
    HXSLoginViewController *loginVc = nav.viewControllers[0];
    loginVc.completion = completion;
    loginVc.loginCanceled = cancelCompletion;
    
    [fromController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - Override Methods

- (void)back
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 if (self.loginCanceled) {
                                     self.loginCanceled();
                                     
                                     self.loginCanceled = nil;
                                 }
                             }];
}


#pragma mark - Target Methods

- (IBAction)onLoginClicked:(id)sender
{
    [self hidenKeyboard];

    [MBProgressHUD showInView:self.view];
    [[HXSUserAccount currentAccount] login:self.nameField.text password:self.passwordField.text];
}

- (IBAction)openPasswordClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LOGIN_SHOW_PASSWORD parameter:@{@"status":@"不可见"}];
    } else {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LOGIN_SHOW_PASSWORD parameter:@{@"status":@"可见"}];
    }
    
    self.passwordField.secureTextEntry = !btn.selected;
}

- (IBAction)qqLogin:(id)sender {
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LOGIN_THIRDPARTY parameter:@{@"type":@"QQ"}];
    
    [HXSQQSdkManager sharedManager].delegate = self;
    [[HXSQQSdkManager sharedManager] logIn];
}

- (IBAction)weiboLogin:(id)sender {
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LOGIN_THIRDPARTY parameter:@{@"type":@"微博"}];
    
    [HXSSinaWeiboManager sharedManager].delegate = self;
    [[HXSSinaWeiboManager sharedManager] logIn];
}

- (IBAction)renrenLogin:(id)sender {
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LOGIN_THIRDPARTY parameter:@{@"type":@"人人"}];
    
    [HXSRenrenManager sharedManager].delegate = self;
    [[HXSRenrenManager sharedManager] logIn];
}

- (IBAction)weixinLogin:(id)sender {
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LOGIN_THIRDPARTY parameter:@{@"type":@"微信"}];
    
    [HXSWXApiManager sharedManager].delegate = self;
    [[HXSWXApiManager sharedManager] logIn];
}

- (IBAction)onClickForgotPassword:(id)sender
{
    NSString *urlText = [[ApplicationSettings instance] currentForgetPasswordURL];
    
    UIViewController *viewController = [[HXSMediator sharedInstance] HXSMediator_webviewViewController:@{@"url":urlText}];
    
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - HXSThirdAccountDelegate
- (void)thirdAccountDidLogin:(HXSAccountType)type
{
    [self clearDelegateWithType:type];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"绑定帐号中...";
    
    [[HXSUserAccount currentAccount] loginWithThirdAccount:[HXSAccountManager sharedManager].accountID token:[HXSAccountManager sharedManager].accountToken];
}

- (void)thirdAccountLoginCancelled:(HXSAccountType)type
{
    [self clearDelegateWithType:type];
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.labelText = @"用户取消";
    [hud hide:YES afterDelay:1.0];
}

- (void)thirdAccountLoginFailed:(HXSAccountType)type
{
    [self clearDelegateWithType:type];
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.labelText = @"登录失败";
    [hud hide:YES afterDelay:1.0];
}

- (void)thirdAccountDidLogout:(HXSAccountType)type {
    
}

#pragma mark Clear Delegate
- (void)clearDelegateWithType:(HXSAccountType)type
{
    [HXSAccountManager sharedManager].accountType = type;
    
    switch (type) {
        case kHXSWeixinAccount:
            [HXSWXApiManager sharedManager].delegate = nil;
            break;
            
        case kHXSSinaWeiboAccount:
            [HXSSinaWeiboManager sharedManager].delegate = nil;
            break;
            
        case kHXSQQAccount:
            [HXSQQSdkManager sharedManager].delegate = nil;
            break;
            
        case kHXSRenrenAccount:
            [HXSRenrenManager sharedManager].delegate = nil;
            break;
            
        default:
            break;
    }
}

#pragma mark - HXSUserAccountDelegate
- (void)onLoginComplete:(NSNotification *)noti
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    NSDictionary * dic = [noti userInfo];
    if([HXSUserAccount currentAccount].isLogin) {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LOGIN parameter:@{@"status":@"成功"}];
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.labelText = [dic objectForKey:@"msg"];
        [hud hide:YES afterDelay:1.0];
        
        if (self.completion) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self actionCompletion];
            }];
        }
        else {
            [self back];
        }
    }else {
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LOGIN parameter:@{@"status":@"失败"}];
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.labelText = [dic objectForKey:@"msg"];
        [hud hide:YES afterDelay:1.0];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.nameField) {
        [self.passwordField becomeFirstResponder];
        [self.nameField resignFirstResponder];
    }else if(textField == self.passwordField) {
        [self.passwordField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMStr replaceCharactersInRange:range withString:string];
    
    if (textField == self.passwordField) {
        if (PASSWORD_MAX_LENGTH < [resultMStr length]) {
            return NO;
        }
    }
    
    if (textField.isSecureTextEntry) {
        textField.text = resultMStr;
        
        [self updateLoginStatus];
        return NO;
    }
    
    return YES;
}


#pragma mark - Private Methods

- (void)updateLoginStatus
{
    if ((0 < [self.nameField.text length])
        && (0 < [self.passwordField.text length])) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}



@end