//
//  HXSBillBorrowCashRecordItem.m
//  store
//
//  Created by hudezhi on 15/8/14.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBillBorrowCashRecordItem.h"

@implementation HXSBillBorrowCashRecordItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if(DIC_HAS_NUMBER(dictionary, @"installment_id")){
            self.installmentIdNum = [NSNumber numberWithInt:[[dictionary objectForKey:@"installment_id"]intValue]];
        }
        if(DIC_HAS_STRING(dictionary, @"installment_text")) {
            self.installmentTextStr = [dictionary objectForKey:@"installment_text"];
        }
        if(DIC_HAS_STRING(dictionary, @"installment_type")) {
            self.installmentTypeStr = [dictionary objectForKey:@"installment_type"];
        }
        if(DIC_HAS_STRING(dictionary, @"installment_image")) {
            self.installmentImageStr = [dictionary objectForKey:@"installment_image"];
        }
        if(DIC_HAS_NUMBER(dictionary, @"installment_date") || DIC_HAS_STRING(dictionary, @"installment_date")) {
            self.installmentDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"installment_date"] integerValue]];
        }
        if(DIC_HAS_NUMBER(dictionary, @"installment_amount")){
            self.installmentAmountNum = [NSNumber numberWithDouble:[[dictionary objectForKey:@"installment_amount"]doubleValue]];
        }
        if(DIC_HAS_NUMBER(dictionary, @"installment_number")){
            self.installmentNumberNum = [NSNumber numberWithInt:[[dictionary objectForKey:@"installment_number"]intValue]];
        }
        if(DIC_HAS_STRING(dictionary, @"installment_purpose")) {
            self.installmentPurposeStr = [dictionary objectForKey:@"installment_purpose"];
        }
        if(DIC_HAS_NUMBER(dictionary, @"installment_status")){
            self.installmentStatusNum = [NSNumber numberWithInt:[[dictionary objectForKey:@"installment_status"]intValue]];
        }
     }
    
    return self;
}


@end
