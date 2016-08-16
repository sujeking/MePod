//
//  HXSBillRepaymentSchedule.m
//  store
//
//  Created by hudezhi on 15/8/15.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBillRepaymentSchedule.h"

@implementation HXSBillRepaymentScheduleItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if(DIC_HAS_NUMBER(dictionary, @"repayment_amount")){
            self.repaymentAmountNum = [dictionary objectForKey:@"repayment_amount"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"repayment_date") || DIC_HAS_STRING(dictionary, @"repayment_date")) {
            self.repaymentDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"repayment_date"] integerValue]];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"repayment_number")){
            self.repaymentNumberNum = [dictionary objectForKey:@"repayment_number"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"repayment_status")){
            self.repaymentStatusNum = [dictionary objectForKey:@"repayment_status"];
        }
    }
    return self;
}

@end


@implementation HXSBillRepaymentSchedule

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if(DIC_HAS_NUMBER(dictionary, @"installment_id")){
            self.installmentIdNum = [dictionary objectForKey:@"installment_id"];
        }
        
        if (DIC_HAS_STRING(dictionary, @"installment_text")) {
            self.installmentTextStr = [dictionary objectForKey:@"installment_text"];
        }
        
        if (DIC_HAS_STRING(dictionary, @"installment_type")) {
            self.installmentTypeStr = [dictionary objectForKey:@"installment_type"];
        }
        
        if (DIC_HAS_STRING(dictionary, @"installment_image")) {
            self.installmentImageStr = [dictionary objectForKey:@"installment_image"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"installment_date") || DIC_HAS_STRING(dictionary, @"installment_date")) {
            self.installmentDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"installment_date"] integerValue]];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"installment_amount")) {
            self.installmentAmountNum = [dictionary objectForKey:@"installment_amount"];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"installment_number")) {
            self.installmentNumberdNum = [dictionary objectForKey:@"installment_number"];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"repayment_number")) {
            self.repaymentNumberNum = [dictionary objectForKey:@"repayment_number"];
        }
        
        if (DIC_HAS_STRING(dictionary, @"installment_purpose")) {
            self.installmentPurposeStr = [dictionary objectForKey:@"installment_purpose"];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"installment_status")) {
            self.installmentStatusNum = [dictionary objectForKey:@"installment_status"];
        }
        
        
        if (DIC_HAS_ARRAY(dictionary, @"repayments")) {
            NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:5];
            for(NSDictionary *dic in [dictionary objectForKey:@"repayments"]) {
                HXSBillRepaymentScheduleItem *item = [[HXSBillRepaymentScheduleItem alloc] initWithDictionary:dic];
                [result addObject:item];
            }
            self.repaymentsArr = [NSArray arrayWithArray:result];
        }
        
    }
    
    return self;
}

@end
