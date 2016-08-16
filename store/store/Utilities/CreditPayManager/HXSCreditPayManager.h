//
//  HXSCreditPayManager.h
//  store
//
//  Created by hudezhi on 15/9/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCreditPayOrderInfo : NSObject

@property (nonatomic, strong) NSNumber *tradeTypeIntNum;   // 交易类型 1-日常 2-取现 3-分期购
@property (nonatomic, strong) NSString *orderSnStr;
@property (nonatomic, strong) NSNumber *orderTypeIntNum;
@property (nonatomic, strong) NSNumber *amountFloatNum;
@property (nonatomic, strong) NSNumber *discountFloatNum;
@property (nonatomic, strong) NSString *orderDescriptionStr;
@property (nonatomic, strong) NSNumber *periodsIntNum;    // 分期数--非必需，默认1
@property (nonatomic, strong) NSString *callBackUrlStr;

- (NSDictionary *)dictionary;

@end

// =========================================================================================================================================

typedef NS_ENUM(NSInteger, HXSCreditCheckResultType)
{
    HXSCreditCheckSuccess = 0,
    
//    HXSCreditCheckCheckBill,        // 白花花已冻结 点击查看账单
//    HXSCreditCheckRegisterPay,      // 白花花未开通 点击去开通
//    HXSCreditCheckBalanceOut,       // 白花花余额不足
};

typedef NS_ENUM(NSInteger, HXSCreditPayResulType)
{
    HXSCreditPaySuccess = 0,
    
    HXSCreditPayCanceled,          // 点击了左边的取消按钮
    HXSCreditPayGetPasswdBack,     // 白花花忘记密码 点击了“忘记密码”
    HXSCreditPayFailed,            // 支付失败
};


typedef void (^CreditCheckResultCallBack)(HXSCreditCheckResultType operation);
typedef void (^CreditPayResultCallBack)(HXSCreditPayResulType operation, NSString *message, NSDictionary *info);


@interface HXSCreditPayManager : NSObject

+ (HXSCreditPayManager *)instance;

// 需要先检查白花花状态(余额,是否冻结等),根据结果来决定是否能继续下订单(有这个根据白花花结果来下订单的过程,所以中间会断掉,产品是傻逼~), HXSCreditCheckSuccess 为能继续下订单
- (void)checkCreditPay:(CreditCheckResultCallBack) completion;

- (void)payOrder:(HXSCreditPayOrderInfo *)order completion:(CreditPayResultCallBack)completion;


@end
