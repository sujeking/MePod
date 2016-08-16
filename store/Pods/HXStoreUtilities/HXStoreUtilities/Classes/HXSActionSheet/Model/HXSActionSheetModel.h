//
//  HXSActionSheetModel.h
//  store
//
//  Created by ArthurWang on 15/12/8.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebService.h"

@interface HXSActionSheetModel : NSObject

+ (void)fetchPayMethodsWith:(NSNumber *)orderTypeNum
                  payAmount:(NSNumber *)payAmountFloatNum
                installment:(NSNumber *)isInstallmentIntNum
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *payArr))block;

@end
