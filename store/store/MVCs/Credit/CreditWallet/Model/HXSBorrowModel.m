//
//  HXSBorrowModel.m
//  store
//
//  Created by hudezhi on 15/8/17.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowModel.h"

#import "HXSBorrowPurposeItem.h"
#import "HXSFinanceOperationManager.h"

@implementation HXSBorrowModel

+ (void)getCreditAccountInfo:(void (^)(HXSErrorCode, NSString *, HXSUserCreditcardInfoEntity *))block
{
    NSString *deviceToken = [HXSUserAccount currentAccount].strToken;
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              deviceToken, SYNC_USER_TOKEN, nil];
    
    [HXStoreWebService getRequest:HXS_CREDIT_CARD_INFO
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           HXSUserCreditcardInfoEntity *infoEntity = [HXSUserCreditcardInfoEntity createEntityWithDictionary:data];
                           block(status, msg, infoEntity);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

+ (void)getBorrowPurpose:(void (^)(HXSErrorCode code, NSString *message, NSArray *payInfo))block
{
    NSString *deviceToken = [HXSUserAccount currentAccount].strToken;
    
    NSDictionary *paramDic = @{SYNC_USER_TOKEN:deviceToken};
    
    [HXStoreWebService getRequest:HXS_BORROW_PURPOSE_TYPE
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           NSArray *list = [data objectForKey:@"list"];
                           if(list.count > 0) {
                               NSMutableArray *result = [NSMutableArray array];
                               for(NSDictionary *purposeDic in list) {
                                   HXSBorrowPurposeItem *item = [[HXSBorrowPurposeItem alloc] initWithDictionary:purposeDic];
                                   [result addObject:item];
                               }
                               
                               block(status, msg, result);
                           }
                           else {
                               block(status, msg, nil);
                           }
                           
                       } else {
                           block(status, msg, nil);
                       }                   }
                   failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                           block(status, msg, nil);
                       }];
}

+ (void)getInstallmentMonthlyInfoWithLoanAmount:(double)loanAmountNum
                                       complete:(void (^)(HXSErrorCode code, NSString *message, HXSBorrowMonthlyMortgageInfo *payInfo))block
{
    NSDictionary *paramDic = @{
                               @"loan_amount":[NSString stringWithFormat:@"%f", loanAmountNum],
                               };
    [HXStoreWebService getRequest:HXS_CREDIT_CARD_INSTALLMENT
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           HXSBorrowMonthlyMortgageInfo *info = [[HXSBorrowMonthlyMortgageInfo alloc] initWithDictionary:data];
                           block(status, msg, info);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

+ (void)applyEncashmentWithPassword:(NSString *)passwordStr
                           complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block
{
    NSString *passwordMD5Str = nil;
    if ((nil != passwordStr)
        && (0 < [passwordStr length]) ) {
        passwordMD5Str = [NSString md5:passwordStr];
    } else {
        passwordMD5Str = @"";
    }
    
    HXSFinanceOperationManager *mgr = [HXSFinanceOperationManager sharedManager];
    
    NSDictionary *paramsDic = @{
                                @"purpose_type_code":           mgr.borrowInfo.purpose.purposeCode,
                                @"purpose_type_name":           mgr.borrowInfo.purpose.purposeName,
                                @"encashment_amount":           [NSNumber numberWithFloat:mgr.borrowInfo.amount],
                                @"installment_number":          mgr.borrowInfo.installmentSelectEntity.installmentNum,
                                @"exemption_status":            [NSNumber numberWithInt:0],
                                @"pay_password":                passwordMD5Str,
                                @"app_encashment_serialno":     mgr.borrowSerialNum,
                                };
    
    [HXStoreWebService postRequest:HXS_CREDITCARD_ENCASHMENT_INSTALLMENT_APPLY
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError == status) {
                           block(status, msg, data);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

+ (void)submitCreditcardContactsList:(NSDictionary *)contactList
                            complete:(void (^) (HXSErrorCode code, NSString *message, NSDictionary *dict))block
{
    
    [HXStoreWebService postRequest:HXS_CREDIT_CARD_CONTACTS_AUTH
                 parameters:contactList
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (status == kHXSNoError) {
                            block(status, msg, data);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    }];
}

+ (void)submitContactInfo:(HXSContactInfoEntity *)contactInfoEntity
                 complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *contactInfo))block
{
    NSDictionary *paramDic = @{@"parents_name":contactInfoEntity.parentNameStr,
                               @"parents_phone":contactInfoEntity.parentTelephoneStr,
                               @"roommate_name":contactInfoEntity.roommateNameStr,
                               @"roommate_phone":contactInfoEntity.roommateTelephoneStr,
                               @"classmates_name":contactInfoEntity.classmateNameStr,
                               @"classmates_phone":contactInfoEntity.classmateTelephoneStr
                               };
    [HXStoreWebService postRequest:HXS_CREDIT_CARD_EMERGENCY_CONTACTS_UPDATE
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (status == kHXSNoError) {
                            block(status,msg, data);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    }];
}
@end
