//
//  HXSDigitalMobileInstallmentDetailEntity.m
//  store
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileInstallmentDetailEntity.h"

@implementation HXSDigitalMobileInstallmentDetailEntity

- (NSNumber *)getDownPayment
{
    return [NSNumber numberWithFloat:self.spend.floatValue * self.downpayment.percent.floatValue];
}

@end
