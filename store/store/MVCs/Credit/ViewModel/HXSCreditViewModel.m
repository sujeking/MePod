//
//  HXSCreditViewModel.m
//  store
//
//  Created by ArthurWang on 16/7/22.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditViewModel.h"

#define HXS_URL_CREDIT_CARD_LOAN_INFO @"creditcard/loan/info"

@implementation HXSCreditViewModel

- (void)fetchLoanInfo:(void (^)(HXSErrorCode status, NSString *message, NSArray *itemsArr))block
{
    [HXStoreWebService getRequest:HXS_URL_CREDIT_CARD_LOAN_INFO
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  
                                  return ;
                              }
                              
                              NSArray *itemArr = [HXSCreditCardLoanInfoModel createCreditCardLoanInfoEntityArrWithArr:[data objectForKey:@"installment"]];
                              
                              block(status, msg, itemArr);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

@end
