//
//  HXSCreditWalletViewController.m
//  store
//
//  Created by 沈露萍 on 16/2/22.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditWalletViewController.h"
#import "HXSCredit.h"

// Contrllers
#import "HXSLoginViewController.h"
#import "HXSBindTelephoneController.h"
#import "HXSWebViewController.h"
#import "HXSUpgradeCreditViewController.h"
#import "HXSDigitalMobileViewController.h"
#import "HXSForgetPasswdVerifyController.h"
#import "HXSSubscribeViewController.h"

// Views
#import "HXSBorrowView.h"
#import "HXSPayPasswordAlertView.h"

// Model
#import "HXSBorrowModel.h"

// common
#import "HXSFinanceOperationManager.h"



NSString * const activateInTimeStr = @"立即激活开通";
NSString * const lookBillStr       = @"查看账单";
NSString * const goShoppingStr     = @"先去逛逛";

static NSInteger const kHeightTipView = 60;

@interface HXSCreditWalletViewController ()<UITableViewDataSource,
                                            UITableViewDelegate,
                                            HXSBorrowViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomSeperateView;

@property (nonatomic, strong) HXSBorrowView *borrowView;
@property (nonatomic, assign) double         cashAmount;

@end

@implementation HXSCreditWalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = (nil == self.itemTitleStr) ? @"我的钱包" : self.itemTitleStr;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupBorrowView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_queations"] style:UIBarButtonItemStylePlain target:self action:@selector(borronInfoBtnPressed:)];
    
    /*  Don't use in version 5.0
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadBorrowView:)
                                                 name:kUserInfoUpdated
                                               object:nil];
    */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateBorrwoView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Override Methods

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Update Borrow Views

- (void)setupBorrowView
{
    if (_borrowView == nil) {
        _borrowView = [HXSBorrowView createBorrwViewWithDelegate:self];
        
        [self.bottomBtn addTarget:self
                           action:@selector(onClickBottomBtn:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)updateBorrwoView
{
    [self.borrowView updateBorrowView];
    
    [self updateBottomView];
}

- (void)updateBottomView
{
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    switch ([creditCardInfo.accountStatusIntNum intValue]) {
        case kHXSCreditAccountStatusNotOpen:
        {
            [self.bottomBtn setTitle:activateInTimeStr forState:UIControlStateNormal];
        }
            break;
        case kHXSCreditAccountStatusOpened:
        case kHXSCreditAccountStatusNormalFreeze:
        case kHXSCreditAccountStatusAbnormalFreeze:
        case kHXSCreditAccountStatusChecking:
        {
            //开通信用钱包申请审核中
            [self.bottomBtn setTitle:lookBillStr forState:UIControlStateNormal];
        }
            break;
        case kHXSCreditAccountStatusCheckFailed:
        {
            //开通信用钱包失败
            [self.bottomBtn setTitle:goShoppingStr forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Target Methods

- (void)onClickBottomBtn:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventBorrowCheckBill parameter:nil];
    
    if(![HXSUserAccount currentAccount].isLogin) {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            [_borrowView updateBorrowView];
        }];
    } else {
        if ([self.bottomBtn.titleLabel.text isEqualToString:goShoppingStr]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            RootViewController *rootVC = [AppDelegate sharedDelegate].rootViewController;
            [rootVC setSelectedIndex:kHXSTabBarWallet];
        } else if ([self.bottomBtn.titleLabel.text isEqualToString:activateInTimeStr]) {
            HXSSubscribeViewController *subscribeVC = [HXSSubscribeViewController createSubscribeVC];
            
            [self.navigationController pushViewController:subscribeVC animated:YES];
            
        } else {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HXSMyBillViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)borronInfoBtnPressed:(id)sender
{
    DLog(@"---------- Borrow Info Button Pressed.");
    NSString *url = [[ApplicationSettings instance] WalletFAQURLString];
    
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)displayBindTelephoneNumberView
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                      message:@"您还未绑定过手机，请先去绑定。"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"去绑定"];
    alertView.rightBtnBlock = ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo"
                                                             bundle:[NSBundle mainBundle]];
        
        HXSBindTelephoneController *telephoneVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSBindTelephoneController"];;
        
        [self.navigationController pushViewController:telephoneVC animated:YES];
    };
    
    [alertView show];
}

- (void)reloadBorrowView:(NSNotification *)notification
{
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource/UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    CGFloat heightOfWalletStatus = 0.0f;
    if ((kHXSCreditAccountStatusOpened == [creditCardInfo.accountStatusIntNum intValue])
        && (kHXSCreditLineStatusDone != [creditCardInfo.lineStatusIntNum intValue])) {
        heightOfWalletStatus = 260.0f;
    } else {
        heightOfWalletStatus = 210.f;
    }
    
    CGFloat heightOfBalanceView = SCREEN_WIDTH * 18 / 25;
    
    return heightOfBalanceView + kHeightTipView + heightOfWalletStatus;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.borrowView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -64) {
        scrollView.contentOffset = CGPointMake(0, -64);
    }
}


#pragma mark - HXSBorrowViewDelegate

- (void)gotoWalletView
{
    [HXSUsageManager trackEvent:kUsageEventBorrowCashNow parameter:nil];
    
    if(![HXSUserAccount currentAccount].isLogin) {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            [_borrowView updateBorrowView];
        }];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        RootViewController *rootVC = [AppDelegate sharedDelegate].rootViewController;
        [rootVC setSelectedIndex:kHXSTabBarWallet];
    }
}

- (void)gotoEncashmentView
{
    // Must bind telephone at first
    BOOL hasPayPasswd = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
    HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
    if ((!hasPayPasswd) && (basicInfo.phone.length < 1)) {
        [self displayBindTelephoneNumberView];
        
        return;
    }
    
    [HXSFinanceOperationManager sharedManager].borrowSerialNum = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [self applyEncashment];
}

- (void)gotoInsatallmentView
{
    HXSDigitalMobileViewController *digitalMobileVC = [HXSDigitalMobileViewController controllerFromXib];
    
    [self.navigationController pushViewController:digitalMobileVC animated:YES];
}

- (void)gotoUpgradeView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HXSUpgradeCreditViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Jump Methods

- (void)jumpToGetPayPasswordVerifyViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo"
                                                         bundle:[NSBundle mainBundle]];
    HXSForgetPasswdVerifyController *passwdVc = [storyboard instantiateViewControllerWithIdentifier:@"HXSForgetPasswdVerifyController"];
    [self.navigationController pushViewController:passwdVc animated:YES];
}

- (void)applyEncashment
{
    __weak typeof(self) weakSelf = self;
    
    HXSPayPasswordAlertView *passwordAlertView = [[HXSPayPasswordAlertView alloc] initWithTitle:@"支付密码验证"
                                                                                        message:@""
                                                                                leftButtonTitle:@"取消"
                                                                              rightButtonTitles:@"确认"];
    
    passwordAlertView.rightBtnBlock = ^(NSString *passwordStr, NSNumber *hasSelectedExemptionBoolNum) {
        [MBProgressHUD showInView:weakSelf.view];
        [HXSBorrowModel applyEncashmentWithPassword:passwordStr
                                           complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                               
                                               if (kHXSPasswordAuthenticationFailedError == code) {
                                                   HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                                                     message:message
                                                                                                             leftButtonTitle:@"忘记密码"
                                                                                                           rightButtonTitles:@"重试"];
                                                   alertView.leftBtnBlock = ^{
                                                       [weakSelf jumpToGetPayPasswordVerifyViewController];
                                                   };
                                                   
                                                   alertView.rightBtnBlock = ^{
                                                       [weakSelf applyEncashment];
                                                   };
                                                   
                                                   [alertView show];
                                                   
                                               } else if (kHXSNoError != code) {
                                                   
                                                   [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                      status:message
                                                                                  afterDelay:1.0f];
                                                   
                                                   return ;
                                               } else {
                                                   HXSFinanceOperationManager *mgr = [HXSFinanceOperationManager sharedManager];
                                                   [mgr clearBorrowInfo];
                                                   
                                                   
                                                   // Update user info
                                                   [[HXSUserAccount currentAccount].userInfo updateUserInfo];
                                                   
                                                   [weakSelf performSegueWithIdentifier:@"segueEncashResult"
                                                                                 sender:[NSNumber numberWithDouble:weakSelf.cashAmount]];
                                               }
                                           }];
    };
    
    
    [passwordAlertView show];
}

@end
