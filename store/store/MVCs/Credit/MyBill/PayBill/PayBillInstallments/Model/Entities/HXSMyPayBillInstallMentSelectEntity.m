//
//  HXSMyPayBillInstallMentSelectEntity.m
//  store
//
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillInstallMentSelectEntity.h"

@implementation HXSMyPayBillInstallMentSelectEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingList = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"monthlyPaymentsNum",            @"monthly_payments",
                                 @"installmentNum",                @"installment_number",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingList];
}

@end
