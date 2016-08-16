//
//  HXSPaymentOrderViewController.m
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPaymentOrderViewController.h"
#import "HXSUtilities.h"

// Controllers
#import "HXSPaymentResultViewController.h"
#import "HXSSubscribeViewController.h"

// Model
#import "HXSPaymentOrderModel.h"
#import "HXSOrderRequest.h"

#import "HXSActionSheetEntity.h"

// Views
#import "HXSAmountTableViewCell.h"
#import "HXSPayMentTypeTableViewCell.h"
#import "HXSCheckButtonView.h"

// Others
#import "HXSWXApiManager.h"
#import "HXSAlipayManager.h"
#import "HXSCreditPayManager.h"
#import "HXSBestPayApiManager.h"



#define HXS_USAGE_EVENT_CONFIRM_PAY_TO_PAY  @"confirm_pay_to_pay"


@interface HXSPaymentOrderViewController () <UITableViewDelegate,
                                            UITableViewDataSource,
                                            HXSAlipayDelegate,
                                            HXSWechatPayDelegate,
                                            HXSBestPayApiManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, strong) NSArray *dataSource;

/**
 *  选择的支付类型
 */
@property (nonatomic, strong) NSNumber *selectedPayType;
@property (nonatomic, strong) HXSOrderInfo * orderInfo;

@property (nonatomic, assign) BOOL installMent;
@property (nonatomic, strong) HXSCheckButtonView *checkButtonView;

@end

@implementation HXSPaymentOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.dataSource      = nil;
    self.selectedPayType = nil;
    self.orderInfo       = nil;
}

#pragma mark - override
- (void)turnBack{
    [super turnBack];
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_PAYMENT_GO_BACK parameter:@{@"business_type":self.orderInfo.typeName}];
    
}
- (void)close{
    [super close];
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_PAYMENT_GO_BACK parameter:@{@"business_type":self.orderInfo.typeName}];
}

#pragma mark - Public Methods

+ (instancetype)createPaymentOrderVCWithOrderInfo:(HXSOrderInfo *)orderInfo installment:(BOOL)installment
{
    HXSPaymentOrderViewController *paymentOrderViewController = [HXSPaymentOrderViewController controllerFromXib];
    paymentOrderViewController.installMent = installment;
    paymentOrderViewController.orderInfo = orderInfo;
    
    return paymentOrderViewController;
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"支付订单";

    [self.navigationItem.leftBarButtonItem setAction:@selector(giveUpPayingOrder)];
}

- (void)initTableView
{
    [self.mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSAmountTableViewCell class]) bundle:nil]
          forCellReuseIdentifier:NSStringFromClass([HXSAmountTableViewCell class])];
    [self.mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPayMentTypeTableViewCell class]) bundle:nil]
          forCellReuseIdentifier:NSStringFromClass([HXSPayMentTypeTableViewCell class])];
    
    __weak typeof(self) weakSelf = self;
    [self.mTableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchPayTypeFormServer];
    }];
    
    [HXSLoadingView showLoadingInView:self.view];
    [self fetchPayTypeFormServer];
}


#pragma mark - Event Methods

- (void)fetchPayTypeFormServer
{
    WS(weakSelf);
    [HXSPaymentOrderModel fetchPayMethodsWith:@(self.orderInfo.type)
                                    payAmount:self.orderInfo.order_amount
                                  installment:@(self.installMent) complete:^(HXSErrorCode code, NSString *message, NSArray *payArr) {
                                      [weakSelf.mTableView endRefreshing];
                                      [HXSLoadingView closeInView:weakSelf.view];
                                      
                                      if (kHXSNoError != code
                                          || (0 >= payArr.count)) {
                                          if (weakSelf.isFirstLoading) {
                                              [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                           block:^{
                                                                               [weakSelf fetchPayTypeFormServer];
                                                                           }];
                                          } else {
                                              [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                 status:message
                                                                             afterDelay:2.0f];
                                          }
                                          
                                          return ;
                                      }
                                      
                                      weakSelf.firstLoading = NO;
                                      
                                      weakSelf.dataSource = payArr;
                                      [weakSelf.mTableView reloadData];
                                      
                                      [weakSelf updateSelectedPayType];
    }];
}

- (void)updateSelectedPayType
{
    NSInteger indexOfSelected = 0;
    
    HXSActionSheetEntity *entity = [self.dataSource firstObject];
    if (entity.payTypeIntNum.intValue == kHXSOrderPayTypeCreditCard) {
        if ([self hasOpenedCreditcard]
            && [self cellCanBeSelected]) {
            indexOfSelected = 0;
        } else {
            if (1 < [self.dataSource count]) {
                indexOfSelected = 1;
            } else {
                [self.checkButtonView.checkButton setEnabled:NO];
                // Can not select any pay type
                return;
            }
        }
    } else {
        indexOfSelected = 0;
    }
    
    HXSActionSheetEntity *selectedEntity = self.dataSource[indexOfSelected];
    self.selectedPayType = selectedEntity.payTypeIntNum;
    
    [self.mTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfSelected inSection:1]
                                 animated:NO
                           scrollPosition:UITableViewScrollPositionTop];
    
    [self.checkButtonView.checkButton setEnabled:YES];
}

/**
 *  执行支付操作
 */
- (void)doPayAction
{
    WS(weakSelf);
    
    switch ([self.selectedPayType integerValue]) {
            //现金
        case kHXSOrderPayTypeCash:
        {
            [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHOOSE_PAYMENT_TYPE parameter:@{@"business_type":self.orderInfo.typeName,@"type":@"货到付款"}];
            
            if(self.orderInfo.type == kHXSOrderTypeDorm) {
                HXSOrderRequest *request = [[HXSOrderRequest alloc] init];
                [request changeOrderPayTypeWithToken:[HXSUserAccount currentAccount].strToken
                                            order_sn:self.orderInfo.order_sn
                                             payType:kHXSOrderPayTypeCash
                                            compelte:^(HXSErrorCode code, NSString *message, HXSOrderInfo *orderInfo) {
                                                if (code == kHXSNoError)
                                                {
                                                    [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                                                    [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2.0];
                                                    [self gotoPaymentResultViewControllerWithResult:YES];
                                                }
                                                else
                                                {
                                                    [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                                                    [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2.0];
                                                }
                                                
                                            }];
            }
            
        }
            break;
            // 支付宝
        case  kHXSOrderPayTypeZhifu:
        {
             [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHOOSE_PAYMENT_TYPE parameter:@{@"business_type":self.orderInfo.typeName,@"type":@"支付宝"}];
            [[HXSAlipayManager sharedManager] pay:self.orderInfo delegate:self];
        }
            break;
            // 微信公众号支付
        case kHXSOrderPayTypeWechat:
        {
            // Do nothing
        }
            break;
            // 白花花支付
        case  kHXSOrderPayTypeBaiHuaHua:
        {
            // Do nothing
        }
            break;
            // 支付宝扫码付
        case kHXSOrderPayTypeAlipayScan:
        {
            // Do nothing
        }
            break;
            // 微信刷卡支付
        case  kHXSOrderPayTypeWechatScan:
        {
            // Do nothing
        }
            break;
            // 微信App支付
        case kHXSOrderPayTypeWechatApp:
        {
            if ([[HXSWXApiManager sharedManager] isWechatInstalled]) {
                 [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHOOSE_PAYMENT_TYPE parameter:@{@"business_type":self.orderInfo.typeName,@"type":@"微信"}];
                [[HXSWXApiManager sharedManager] wechatPay:self.orderInfo delegate:self];
            } else {
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                  message:@"请先安装微信用户端, 再选择微信支付"
                                                                          leftButtonTitle:@"确认"
                                                                        rightButtonTitles:nil];
                
                [alertView show];
            }
        }
            break;
            // 信用钱包支付
        case kHXSOrderPayTypeCreditCard:
        {
            [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHOOSE_PAYMENT_TYPE parameter:@{@"business_type":self.orderInfo.typeName,@"type":@"59钱包"}];
            [self payOrderWithBaiHuaHua];
        }
            break;
            // 翼支付
        case  kHXSOrderPayTypeBestPay:
        {
            [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CONFIRM_PAY_TO_PAY parameter:@{@"pay_type":@"翼支付"}];
            [[HXSBestPayApiManager sharedManager] bestPayWithOrderInfo:self.orderInfo
                                                                  from:self
                                                              delegate:self];
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return [self.dataSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        HXSAmountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSAmountTableViewCell class]) forIndexPath:indexPath];
        cell.amountNum = self.orderInfo.order_amount;
        cell.userInteractionEnabled = NO;
        return cell;
    }
    else
    {
        HXSPayMentTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPayMentTypeTableViewCell class]) forIndexPath:indexPath];
        HXSActionSheetEntity *entity = self.dataSource[indexPath.row];
        cell.actionSheetEntity = entity;

        //检测是否开通了59钱包以及是否钱包金额充足
        if (entity.payTypeIntNum.intValue == kHXSOrderPayTypeCreditCard) {
            [cell getStoreCreditPayInfoWithPayAmount:self.orderInfo.order_amount];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 0)
    {
        return 0.1;
    }
    else
    {
        return 47;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    
    if (section == 0)
    {
        return 44;
    }
    else
    {
        return 62;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    else
    {
        return 100;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"HXSPayMentTypeTipView" owner:nil options:nil] firstObject];
        return titleView;
    }
    else
    {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        if (0 < [self.dataSource count])
        {
            return self.checkButtonView;
        }
    }
    
    return nil;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL canBeSelected = [self cellCanBeSelected];
    
    if (!canBeSelected) {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        HXSActionSheetEntity *entity = self.dataSource[indexPath.row];
        //如果59钱包没有开通，则点击的时候就进入开通页面
        if (entity.payTypeIntNum.intValue == kHXSOrderPayTypeCreditCard) {
            if (![self hasOpenedCreditcard]) {
                
                if(self.orderInfo.typeName)
                    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_OPEN_59WALLET_BUTTON_CLICK parameter:@{@"business_type":self.orderInfo.typeName}];
                
                [self goToOpenBankCardViewController];
                
                [self.checkButtonView.checkButton setEnabled:NO];
                
                self.selectedPayType = entity.payTypeIntNum;
                
                return;
            }
        }
        
        [self.checkButtonView.checkButton setEnabled:YES];
        
        self.selectedPayType = entity.payTypeIntNum;
    }
}


#pragma mark - Jump To VCs Methods

/**
 *  59钱包是否开通
 *
 *  @return
 */
- (BOOL)hasOpenedCreditcard
{
    BOOL isOpen = YES;
    HXSUserCreditcardInfoEntity *creditcardInfoEntity = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    switch ([creditcardInfoEntity.accountStatusIntNum integerValue]) {
        case kHXSCreditAccountStatusNotOpen: // (0，未开通；1，已开通)
        case kHXSCreditAccountStatusChecking:
        case kHXSCreditAccountStatusCheckFailed: {
            isOpen = NO;
        }
            break;
        default:break;
    }
    return isOpen;
}

- (BOOL)cellCanBeSelected
{
    HXSUserCreditcardInfoEntity *creditcardInfoEntity = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    switch ([creditcardInfoEntity.accountStatusIntNum integerValue]) {
        case kHXSCreditAccountStatusNotOpen: // (0，未开通；1，已开通)
        case kHXSCreditAccountStatusOpened:
        case kHXSCreditAccountStatusChecking:
        case kHXSCreditAccountStatusCheckFailed:
        {
            return YES;
        }
            break;
            
        case kHXSCreditAccountStatusNormalFreeze:
        case kHXSCreditAccountStatusAbnormalFreeze:
        {
            return NO;
        }
            break;
            
        default:
            break;
    }
    
    float available = creditcardInfoEntity.availableLoanDoubleNum.floatValue;
    
    if ([self.orderInfo.order_amount floatValue] > available) { // 余额不足
        return NO;
    }
    
    return YES;
}

/**
 *  进入开通59钱包页面
 */
- (void)goToOpenBankCardViewController
{
    RootViewController *tabRootCtrl = [AppDelegate sharedDelegate].rootViewController;
    UINavigationController *nav = tabRootCtrl.currentNavigationController;
    
    if (nav)
    {   
        HXSSubscribeViewController *subscribeVC = [HXSSubscribeViewController createSubscribeVC];
        [nav pushViewController:subscribeVC animated:YES];
    }
}

/**
 *  白花花 分期支付
 */
- (void)payOrderWithBaiHuaHua
{
    WS(weakSelf);
 
    HXSCreditPayOrderInfo *order = [[HXSCreditPayOrderInfo alloc] init];
    
    order.tradeTypeIntNum        = [NSNumber numberWithInteger:kHXStradeTypeNormal];
    order.orderSnStr             = self.orderInfo.order_sn;
    order.orderTypeIntNum        = @(self.orderInfo.type);
    order.amountFloatNum         = self.orderInfo.order_amount;
    order.discountFloatNum       = self.orderInfo.discount;
    order.orderDescriptionStr    = self.orderInfo.orderDescriptionStr;
    order.periodsIntNum          = [NSNumber numberWithInteger:1];
    order.callBackUrlStr         = self.orderInfo.attach;

  
    [[HXSCreditPayManager instance] payOrder:order completion:^(HXSCreditPayResulType operation, NSString *message, NSDictionary *info) {
        
        switch (operation) {
            case HXSCreditPayCanceled:
                // Do nothing
                break;
                
            case HXSCreditPaySuccess:
            {
                [weakSelf gotoPaymentResultViewControllerWithResult:YES];
            }
                break;
                
            case HXSCreditPayGetPasswdBack:
            case HXSCreditPayFailed:
            {
                [MBProgressHUD showInView:weakSelf.view
                               customView:nil
                                   status:message
                               afterDelay:1.5f
                            completeBlock:^{
                                [weakSelf gotoPaymentResultViewControllerWithResult:NO];
                            }];
            }
                break;
                
            default:
                break;
        }
    }];
}

/**
 *  跳转到支付结果页面 【非货到付款】
 */
- (void)gotoPaymentResultViewControllerWithResult:(BOOL)result
{
    self.orderInfo.paytype = self.selectedPayType.intValue;
    
    HXSPaymentResultViewController *paymentResultViewController = [HXSPaymentResultViewController createPaymentResultVCWithOrderInfo:self.orderInfo result:result];
    
    [self replaceCurrentViewControllerWith:paymentResultViewController animated:YES];
}

- (void)giveUpPayingOrder
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                      message:@"确认放弃支付吗？"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确认"];
    __weak typeof(self) weakSelf = self;
    
    alertView.rightBtnBlock = ^(void){
        [weakSelf gotoPaymentResultViewControllerWithResult:NO];
    };
    
    [alertView show];
}

#pragma mark - HXSAlipayDelegate

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result
{
    
    BOOL payResult = NO;
    
    if (status.intValue == 9000) { // 支付成功
        payResult = YES;
    } else {
        payResult = NO;
    }
    
    [self gotoPaymentResultViewControllerWithResult:payResult];
}

#pragma mark - HXSWechatPayDelegate

- (void)wechatPayCallBack:(HXSWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result {
    
    BOOL payResult = NO;
    
    if (HXSWechatPayStatusSuccess == status) {
        payResult = YES;
    } else {
        payResult = NO;
    }
    
    [self gotoPaymentResultViewControllerWithResult:payResult];
}

#pragma mark  - HXSBestPayApiManagerDelegate

- (void)bestPayCallBack:(HXSBestPayStatus)status message:(NSString *)message result:(NSDictionary *)result {
    BOOL payResult = NO;
    
    if (kHXSBestPayStatusSuccess == status)
    {
        payResult = YES;
    }
    else
    {
        payResult = NO;
    }

    [self gotoPaymentResultViewControllerWithResult:payResult];
}


#pragma mark - Setter Getter Methods

- (HXSCheckButtonView *)checkButtonView
{
    if (nil == _checkButtonView) {
        __weak typeof(self) weakSelf = self;
        _checkButtonView = [[[NSBundle mainBundle] loadNibNamed:@"HXSCheckButtonView" owner:nil options:nil] firstObject];
        [_checkButtonView setPaymentAction:^{
            [weakSelf doPayAction];
        }];
    }
    
    return _checkButtonView;
}


@end
