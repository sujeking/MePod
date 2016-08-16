//
//  HXSMyPayBillListEntities.m
//  store
//
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillListEntity.h"

@implementation HXSMyPayBillListEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingPayBillList = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"billIDNum",                  @"bill_id",
                                        @"billTimeNum",                @"bill_time",
                                        @"billAmountNum",              @"bill_amount",
                                        @"billStatusNum",              @"status",
                                        @"billServiceFeeDescStr",      @"service_fee_desc",
                                        @"billTypeNum",                @"type",
                                        @"installmentStatusNums",      @"installment_status",
                                        @"installmentAmountNum",       @"installment_amount",
                                        nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingPayBillList];
}

@end
