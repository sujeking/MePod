//
//  HXSInstallmentEntity.m
//  store
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSInstallmentEntity.h"

@implementation HXSInstallmentEntity

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (DIC_HAS_NUMBER(dic, @"downpayment")) {
            self.downpayment = [dic objectForKey:@"downpayment"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"installment_money")) {
            self.installmentMoney = [dic objectForKey:@"installment_money"];
        }
        
        if (DIC_HAS_ARRAY(dic, @"installment_list")) {
            
            NSMutableArray *list = [[NSMutableArray alloc] init];
            NSArray *installmentList = [dic objectForKey:@"installment_list"];
            for (id installmentInfo in installmentList) {
                HXSInstallmentItemEntity *installmentItem = [[HXSInstallmentItemEntity alloc] initWithDictionary:installmentInfo];
                
                installmentItem.chargeMoney = [NSNumber numberWithFloat:installmentItem.installmentMoney.floatValue - self.installmentMoney.floatValue / installmentItem.installmentNum.floatValue];
                [list addObject:installmentItem];
            }
            
            self.installmentList = list;
        }
    }
    
    return self;
}

@end

@implementation HXSInstallmentItemEntity

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (DIC_HAS_NUMBER(dic, @"installment_num")) {
            self.installmentNum = [dic objectForKey:@"installment_num"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"installment_money")) {
            self.installmentMoney = [dic objectForKey:@"installment_money"];
        }
    }
    
    return self;
}

@end
