//
//  HXSCreditPayManager.m
//  store
//
//  Created by hudezhi on 15/9/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSCreditPayManager.h"
#import "HXSUtilities.h"

#import "HXSPayPasswordAlertView.h"
#import "HXSBaiHuaHuaPayModel.h"
#import "HXSForgetPasswdVerifyController.h"
#import "HXSSubscribeViewController.h"
#import "HXSFinanceOperationManager.h"
#import "HXSMyBillViewController.h"

static HXSCreditPayManager * _creditPayInstance;


@implementation HXSCreditPayOrderInfo

- (NSDictionary *)dictionary
{
    NSMutableDictionary *paramsMDic = [[NSMutableDictionary alloc] initWithCapacity:6];
    
    [paramsMDic setObjectExceptNil:self.tradeTypeIntNum         forKey:@"type"];
    [paramsMDic setObjectExceptNil:self.orderTypeIntNum         forKey:@"sale_channel"];
    [paramsMDic setObjectExceptNil:self.orderSnStr              forKey:@"order_sn"];
    [paramsMDic setObjectExceptNil:self.amountFloatNum          forKey:@"amount"];
    [paramsMDic setObjectExceptNil:self.orderDescriptionStr     forKey:@"trading_comment"];
    [paramsMDic setObjectExceptNil:self.periodsIntNum           forKey:@"periods"];
    [paramsMDic setObjectExceptNil:self.callBackUrlStr          forKey:@"call_back_url"];

    return paramsMDic;
}

@end

// ===========================================================================

@interface HXSCreditPayManager () <UINavigationControllerDelegate>{
    UIViewController    *_getPayPasswdSourceController;
}

@property (nonatomic, strong) HXSCreditPayOrderInfo *orderInfo;

@property (nonatomic, copy) CreditCheckResultCallBack checkCompletion;

@property (nonatomic, copy) CreditPayResultCallBack getBackPayPasswdCompletion;

@end

@implementation HXSCreditPayManager

+ (HXSCreditPayManager *)instance
{
    @synchronized(self) {
       if (!_creditPayInstance) {
           _creditPayInstance = [[HXSCreditPayManager alloc] init];
         }
    }
    
    return _creditPayInstance;
}

#pragma mark - Private Methods

- (void)clearCallbackBlocks
{
    self.checkCompletion = nil;
//    self.payCompletion = nil;
}

- (void)actionCheckBlock:(HXSCreditCheckResultType) operation
{
    if (_checkCompletion) {
        _checkCompletion(operation);
        
        [self clearCallbackBlocks];
    }
}


#pragma mark - Private Credit Check Method

- (void)dealWithPayByAccountInfo:(HXSUserCreditcardInfoEntity *)creditcardInfoEntity
{
    switch ([creditcardInfoEntity.accountStatusIntNum integerValue]) {
        case kHXSCreditAccountStatusNotOpen: // // (0，未开通；1，已开通)
        case kHXSCreditAccountStatusChecking:
        case kHXSCreditAccountStatusCheckFailed:
        {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"59钱包"
                                                                              message:@"抱歉！您还未开通59钱包业务。"
                                                                      leftButtonTitle:@"取消"
                                                                    rightButtonTitles:@"去开通"];
            alertView.rightBtnBlock = ^{
                [HXSUsageManager trackEvent:HXS_USAGE_EVENT_BOX_APPLY_CREDIT_PAY parameter:nil];
                [self jumpToCreditPayViewController];
                [self clearCallbackBlocks];
            };
            
            [alertView show];
            
            return;
        }
            break;
            
        case kHXSCreditAccountStatusNormalFreeze:
        {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"59钱包"
                                                                              message:@"抱歉！您的59钱包因逾期已冻结，请选择其他付款方式。"
                                                                      leftButtonTitle:@"查看账单"
                                                                    rightButtonTitles:@"确定"];
            alertView.leftBtnBlock = ^{
                [self jumpToMyBillViewController];
                [self clearCallbackBlocks];
            };
            
            [alertView show];
            
            return;
        }
            break;
            
        case kHXSCreditAccountStatusAbnormalFreeze:
        {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"59钱包"
                                                                              message:@"您的支付密码输入错误次数过多，被冻结。"
                                                                      leftButtonTitle:@"查看账单"
                                                                    rightButtonTitles:@"确定"];
            alertView.leftBtnBlock = ^{
                [self jumpToMyBillViewController];
                [self clearCallbackBlocks];
            };
            
            [alertView show];
            
            return;
        }
            
        default:
            break;
    }
    
    
    NSString *titileStr = [[NSString alloc] initWithFormat:@"59钱包（剩余额度￥%0.2f）", [creditcardInfoEntity.availableConsumeDoubleNum floatValue]];
    if ([creditcardInfoEntity.availableConsumeDoubleNum floatValue] < [_orderInfo.amountFloatNum doubleValue]) {
        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:titileStr
                                                                          message:@"抱歉！本月59钱包额度不够您本次消费，请选择其他付款方式。"
                                                                  leftButtonTitle:@"知道啦"
                                                                rightButtonTitles:nil];
        
        [alertView show];
        
        [self clearCallbackBlocks];
        
        return;
    }
    
    [self actionCheckBlock:HXSCreditCheckSuccess];
}

#pragma mark - Private Credit Pay Method

- (void)baiHuaHuaPayToService:(NSDictionary *)paramsDic
                        order:(HXSCreditPayOrderInfo *)order
                   completion:(CreditPayResultCallBack)completion
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    HXSBaiHuaHuaPayModel* payModel = [[HXSBaiHuaHuaPayModel alloc] init];
    
    [MBProgressHUD showInView:window];
    [payModel payCreditCardPayment:paramsDic
                         complete:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
                             [MBProgressHUD hideHUDForView:window animated:YES];
                             
                             if (kHXSPasswordAuthenticationFailedError == code) {
                                 HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                                   message:message
                                                                                           leftButtonTitle:@"忘记密码"
                                                                                         rightButtonTitles:@"重试"];
                                 alertView.leftBtnBlock = ^{
                                     if (completion) {

                                         [self jumpToGetPayPasswordVerifyViewController:completion];
                                     }
                                 };
                                 
                                 alertView.rightBtnBlock = ^{
                                     [self payOrder:order completion:completion];
                                 };
                                 
                                 [alertView show];
                                 
                             } else if (kHXSPasswordWasLocked == code){
                                 HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                                   message:message
                                                                                           leftButtonTitle:@"确定"
                                                                                         rightButtonTitles:nil];
                                 [alertView show];
                                 
                                 [[HXSUserAccount currentAccount].userInfo updateUserInfo];
                             } else if (kHXSNoError != code) {
                                 if (completion) {
                                     completion(HXSCreditPayFailed, message, info);
                                 }
                             } else {
                                 if (completion) {                                    
                                     completion(HXSCreditPaySuccess, message, info);
                                     [[HXSUserAccount currentAccount].userInfo updateUserInfo];
                                 }
                             }
                         }];
}

#pragma mark - Push Other VC Methods

- (void)jumpToMyBillViewController
{
    RootViewController *tabRootCtrl = [AppDelegate sharedDelegate].rootViewController;
    UINavigationController *nav = tabRootCtrl.currentNavigationController;
    
    if (nav)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay"
                                                         bundle:[NSBundle mainBundle]];
        HXSMyBillViewController *myBillVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSMyBillViewController"];    
        [nav pushViewController:myBillVC animated:YES];
    }
}

- (void)jumpToCreditPayViewController
{
    RootViewController *tabRootCtrl = [AppDelegate sharedDelegate].rootViewController;
    UINavigationController *nav = tabRootCtrl.currentNavigationController;
    
    if (nav) {
        // apply credit card
        HXSSubscribeViewController *subscribeVC = [HXSSubscribeViewController createSubscribeVC];
        
        [nav pushViewController:subscribeVC animated:YES];
    }
}

- (void)jumpToGetPayPasswordVerifyViewController:(CreditPayResultCallBack)completion
{
    RootViewController *tabRootCtrl = [AppDelegate sharedDelegate].rootViewController;
    UINavigationController *nav = tabRootCtrl.currentNavigationController;
    
    if (nav) {
        _getPayPasswdSourceController = nav.topViewController;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo"
                                                             bundle:[NSBundle mainBundle]];
        HXSForgetPasswdVerifyController *passwdVc = [storyboard instantiateViewControllerWithIdentifier:@"HXSForgetPasswdVerifyController"];
        [nav pushViewController:passwdVc animated:YES];
        
       nav.delegate = self;
        
        self.getBackPayPasswdCompletion = completion;
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if (viewController == _getPayPasswdSourceController) {
//        if (self.getBackPayPasswdCompletion) {
//            self.getBackPayPasswdCompletion(HXSCreditPayGetPasswdBack, nil, nil);
//            self.getBackPayPasswdCompletion = nil;
//        }
//    }
}

#pragma mark - Public Method

- (void)checkCreditPay:(CreditCheckResultCallBack) completion
{
    self.checkCompletion = completion;
    
    HXSUserCreditcardInfoEntity *creditcardInfoEntity = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    [self dealWithPayByAccountInfo:creditcardInfoEntity];
}

- (void)payOrder:(HXSCreditPayOrderInfo *)order completion:(CreditPayResultCallBack)completion
{
    self.orderInfo = order;
    
    // judge should display alert view
    BOOL isOnExemptionStatus = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.exemptionStatusIntNum boolValue];
    if (isOnExemptionStatus
        && (G_EXEMPTION_MIN_AMOUNT >= [order.amountFloatNum floatValue])) {
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[order dictionary]];
        [paramsDic setObjectExceptNil:[NSNumber numberWithInteger:1] forKey:@"exemption_status"];
        [self baiHuaHuaPayToService:paramsDic
                              order:order
                         completion:completion];
        return; // don't display the inputting password alert view
    }
    
    
    // alert view
    HXSUserCreditcardInfoEntity *creditcardInfoEntity = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    NSString *title = [[NSString alloc] initWithFormat:@"59钱包（剩余额度￥%0.2f）", [creditcardInfoEntity.availableConsumeDoubleNum floatValue]];
    
    NSString *messageStr = [NSString stringWithFormat:@"￥%0.2f", [order.amountFloatNum doubleValue]];
    
    __weak typeof(self) weakSelf = self;
    HXSPayPasswordAlertView *alertView = [[HXSPayPasswordAlertView alloc] initWithTitle:title
                                                                                message:messageStr
                                                                        leftButtonTitle:@"取消"
                                                                      rightButtonTitles:@"付款"];
    if (!isOnExemptionStatus
        && (G_EXEMPTION_MIN_AMOUNT >= [order.amountFloatNum floatValue])) {
        alertView.displayExemptionBtnBoolNum = [NSNumber numberWithBool:YES];
    }
    
    alertView.rightBtnBlock = ^(NSString *passwordStr, NSNumber *hasSelectedExemptionBoolNum){
        
        NSString *passwordMD5Str          = [NSString md5:passwordStr];
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[order dictionary]];
        [paramsDic setObjectExceptNil:passwordMD5Str forKey:@"pay_password"];
        [paramsDic setObjectExceptNil:[NSNumber numberWithInteger:0] forKey:@"exemption_status"];
        if (nil != hasSelectedExemptionBoolNum) {
            [paramsDic setObjectExceptNil:hasSelectedExemptionBoolNum forKey:@"exemption_open"];
        }
        
        [weakSelf baiHuaHuaPayToService:paramsDic
                                  order:order
                             completion:completion];
        
    };
    
    alertView.leftBtnBlock = ^(NSString *passwordStr, NSNumber *hasSelectedExemptionBoolNum) {
        if (completion) {
            completion(HXSCreditPayCanceled, nil, nil);
        }
    };
    
    [alertView show];
}




@end
