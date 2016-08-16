//
//  HXSActionSheetModel.m
//  store
//
//  Created by ArthurWang on 15/12/8.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSActionSheetModel.h"

#import "HXSActionSheetEntity.h"
#import "HXMacrosUtils.h"

@implementation HXSActionSheetModel

#pragma mark - Public Methods

+ (void)fetchPayMethodsWith:(NSNumber *)orderTypeNum
                  payAmount:(NSNumber *)payAmountFloatNum
                installment:(NSNumber *)isInstallmentIntNum
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *payArr))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               orderTypeNum,                @"order_type",
                               payAmountFloatNum,           @"pay_amount",
                               [NSNumber numberWithInt:0],  @"device_type",  //0为iOS，1为Android
                               isInstallmentIntNum,         @"installment",
                               nil];
    
    [HXStoreWebService getRequest:HXS_PAY_METHODS
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"payTypeIntNum",       @"pay_type",
                                                @"nameStr",             @"name",
                                                @"iconURLStr",          @"icon",
                                                @"descriptionStr",      @"description",
                                                @"promotionStr",        @"promotion", nil];
                       
                       NSArray *methodsArr = nil;
                       if (DIC_HAS_ARRAY(data, @"paymethods")) {
                           methodsArr = [HXSActionSheetEntity createActionSheetEntityWithPaymentArr:[data objectForKey:@"paymethods"]];
                       }
                       
                       block(status, msg, methodsArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

@end
