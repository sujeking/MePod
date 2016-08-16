//
//  HXStoreWebServiceErrorCode.h
//  Pods
//
//  Created by ArthurWang on 16/6/12.
//
//

#ifndef HXStoreWebServiceErrorCode_h
#define HXStoreWebServiceErrorCode_h

typedef enum
{
    //未知错误
    kHXSUnknownError = -1,
    
    
    //服务器返回的错误
    kHXSNoError = 0,
    
    kHXSNormalError = 1,
    
    kHXSInvalidTokenError = 2,
    
    kHXSParamError = 3,
    
    kHXSItemNotExit = 4,
    
    kHXSSignError = 5,
    
    kHXSTimeoutError = 6,
    
    kHXSNeedVerifyCodeError = 7,
    
    kHXSPasswordAuthenticationFailedError = 8,
    
    kHXSPasswordWasLocked = 12,
    
    // coupon code
    kHXSCouponExpiredError = 100,
    
    kHXSCouponTimesLimitsError = 101,
    
    kHXSCouponDoNotMeetQuotaError = 102,
    
    kHXSCouponNotExistError = 103,
    
    kHXSCouponCheckoutTooFrequently = 104,
    
    kHXSCouponIsNotInDormError = 105,
    
    kHXSCouponMinimumAmountOfConsumptionError = 106,
    
    kHXSCouponHasBeenUsedError = 107,
    
    kHXSCouponNotUseTimeError = 108,
    
    kHXSCouponDontBelongAccountError = 109,
    
    kHXSCouponError = 199,
    
    //自定义错误
    kHXSNetWorkError = 200,
    
    kHXSRegisterAccountExist = 201,
    
    kHXSLoginNoAccountError = 202,
    
    kHXSLoginPasswordError = 203,
    
    kHXSItemIsEmpty = 342,
    
    kHXSNetworkingCancelError = -999,
    
    // 金融相关错误码
    kHXSFinanceLoginedInManyDeviceError = 400,
    kHXSFinanceBorrowLoanSerialNumRepeat = 402,
    //社区消息
    kHXCommunityNotMessage = 4960,
    
    // 信用购
    kHXSCreditCardErrorLessFiveTimes = 1100, // 填写信息错误,错误次数小于5次
    kHXSCreditCardErrorMoreFiveTimes = 1101, // 错误次数大于等于5次
    kHXSCreditCardDidNotApply        = 1102, // 该用户没有申请开通信用钱包
    kHXSCreditCardIsApplying         = 1103, // 该用户申请开通信用钱包正在受理
    kHXSCreditCardHasOpened          = 1104, // 该用户已经申请开通信用钱包
    
    // 社区
    kCommunityBanWordError           = 4903, //社区发帖敏感词
    
    // 打印
    kPrintWelfarePaper               = 117, // 打印店，福利纸已经用完
    
}HXSErrorCode;


#endif /* HXStoreWebServiceErrorCode_h */
