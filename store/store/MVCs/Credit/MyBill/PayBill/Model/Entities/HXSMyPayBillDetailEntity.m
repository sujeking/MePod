//
//  HXSMyPayBillDetailEntities.m
//  store
//
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillDetailEntity.h"

@implementation HXSMyPayBillDetailEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingPayBillDetail = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"textStr",               @"text",
                                          @"timeStrNum",            @"time",
                                          @"amountNum",             @"amount",
                                          @"typeNum",               @"type",
                                          @"urlStr",                @"image",nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingPayBillDetail];
}

@end

@implementation HXSMyPayBillEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingPayBill = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"billIDNum",                  @"bill_id",
                                    @"billTimeNum",                @"bill_time",
                                    @"billAmountNum",              @"bill_amount",
                                    @"billStatusNum",              @"status",
                                    @"billServiceFeeDescStr",      @"service_fee_desc",
                                    @"installmentStatusNums",      @"installment_status",
                                    @"installmentAmountNum",       @"installment_amount",
                                    @"detailArr",                  @"bill_details", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingPayBill];
}

@end;

