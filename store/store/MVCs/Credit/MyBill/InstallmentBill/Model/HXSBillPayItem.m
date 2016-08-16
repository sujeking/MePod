//
//  HXSBillPayItem.m
//  store
//
//  Created by hudezhi on 15/8/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBillPayItem.h"

@implementation HXSBillPayGoodsItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (DIC_HAS_NUMBER(dictionary, @"amount")) {
            self.amount = [dictionary[@"amount"] doubleValue];
        }
        if (DIC_HAS_STRING(dictionary, @"expend_desc")) {
            self.goodsDescription = dictionary[@"expend_desc"];
        }
        
        // 现在是string, 可能会改成long, 到时候可与不改
        id date = dictionary[@"expend_time"];
        if ([date isKindOfClass:[NSString class]]) {
            self.payDate = date;
        }
        else if ([date isKindOfClass:[NSNumber class]]) {
            double seconds = [date doubleValue];
            self.payDate = [NSDate YMDFromSecondsSince1970:(seconds/1000.0f)];
        }
    }
    
    return self;
}

@end

// ================== HXSBillPayItem ==================

@implementation HXSBillPayItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init] ;
    if (self) {
        if (DIC_HAS_STRING(dictionary, @"bill_time")) {
            self.billDate = dictionary[@"bill_time"];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"bill_amount")) {
            self.billAmount = [dictionary[@"bill_amount"] doubleValue];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"exceed_flag")) {
            self.isOverTime = [dictionary[@"exceed_flag"] boolValue];
        }
        
        if (DIC_HAS_STRING(dictionary, @"service_fee_desc")) {
            self.serviceFeeDescription = dictionary[@"service_fee_desc"];
        }
        
        if (DIC_HAS_ARRAY(dictionary, @"bills")) {
            NSArray *list = dictionary[@"bills"];
            if (list.count > 0) {
                NSMutableArray* resultList = [NSMutableArray array];
                for (NSDictionary *dic in list) {
                    HXSBillPayGoodsItem *item = [[HXSBillPayGoodsItem alloc] initWithDictionary:dic];
                    [resultList addObject:item];
                }
            
                self.goodsList = [NSArray arrayWithArray:resultList];
            }
        }
    }
    
    return self;
}

@end
