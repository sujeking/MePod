//
//  HXSConfirmOrderEntity.m
//  store
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSConfirmOrderEntity.h"
#import "HXSInstallmentEntity.h"

@implementation HXSConfirmOrderEntity

- (NSMutableDictionary *)getDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.goodsId forKey:@"sku_id"];
    [dic setObject:self.goodsName forKey:@"sku_name"];
    [dic setObject:self.goodsProperty forKey:@"sku_attr"];
    [dic setObject:self.goodsNum forKey:@"sku_num"];
    [dic setObject:self.addressInfo.name forKey:@"user_name"];
    [dic setObject:self.addressInfo.phone forKey:@"user_phone"];
    
    NSString *address = [self.addressInfo getAddressName];
    [dic setObject:address forKey:@"user_address"];
    
    NSString *addressCode = [self.addressInfo getAddressCode];
    [dic setObject:addressCode forKey:@"address_code"];
    
    if (self.remark == nil) {
        self.remark = @"";
    }
    
    [dic setObject:self.remark forKey:@"remark"];
    [dic setObject:[NSNumber numberWithInt:3] forKey:@"source"];
    [dic setObject:[NSNumber numberWithBool:self.isInstallment.boolValue] forKey:@"is_installment"];
    if (self.isInstallment.boolValue) {
        [dic setObject:[NSNumber numberWithFloat:self.total.floatValue * self.installmentInfo.downpayment.percent.floatValue] forKey:@"down_payment"];
        [dic setObject:self.installmentInfo.installment.installmentNum forKey:@"installment_num"];
    } else {
        [dic setObject:self.total forKey:@"down_payment"];
        [dic setObject:@0 forKey:@"installment_num"];
    }
    
    [dic setObject:self.addressInfo.siteId forKey:@"site_id"];
    
    return dic;
}

- (NSNumber *)getToTalAccount
{
    return [NSNumber numberWithFloat:self.total.floatValue - self.coupon.discount.floatValue];
}

- (NSNumber *)getDownPayment
{
    return [NSNumber numberWithFloat:[[self getToTalAccount] floatValue] * self.installmentInfo.downpayment.percent.floatValue];
}

@end
