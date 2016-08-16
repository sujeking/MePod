//
//  HXMyLoan.h
//  store
//
//  Created by ArthurWang on 16/7/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#ifndef HXMyLoan_h
#define HXMyLoan_h

typedef NS_ENUM(NSInteger, HXSSubscribeStepIndex){
    kHXSSubscribeStepIndexID             = 0,   //身份信息
    kHXSSubscribeStepIndexStudent        = 1,   //学籍信息
    kHXSSubscribeStepIndexBankCard       = 2,   //银行卡信息
    kHXSSubscribeStepIndexAuthorize      = 3,   //授权信息
    kHXSSubscribeStepIndexSubmitSucc     = 4,   //提交成功
};


#endif /* HXMyLoan_h */
