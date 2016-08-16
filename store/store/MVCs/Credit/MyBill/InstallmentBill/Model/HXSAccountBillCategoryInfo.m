//
//  HXSAccountBillCategoryItem.m
//  store
//
//  Created by hudezhi on 15/8/15.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSAccountBillCategoryInfo.h"

@implementation HXSAccountBillCategoryItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.categoryName = dictionary[@"bill_category_name"];
        self.categoryCode = [dictionary[@"bill_category_code"] integerValue];
        self.amount = [dictionary[@"amount"] doubleValue];
        
        id date = dictionary[@"bill_time"];
        if ([date isKindOfClass:[NSString class]]) {
            NSString *text = date;
            NSDate *d = [text dateWithFormat:@"YYYY-MM-dd"];
            self.billDate = [NSString stringWithFormat:@"%li月%li日", (long)[d month], (long)[d day]];
        }
        else if ([date isKindOfClass:[NSNumber class]]) {
            double seconds = [date doubleValue];
            self.billDate = [NSDate YMDFromSecondsSince1970:(seconds/1000.f)];
        }
    }
    
    return self;
}

@end

/*
 * ================================================================
 */

@implementation HXSAccountBillCategoryInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (DIC_HAS_STRING(dictionary, @"tail_number")) {
            self.tailNumber = [NSString stringWithFormat:@"%@", dictionary[@"tail_number"]];
        }
        NSArray *list = dictionary[@"bills"];
        if (list.count > 0) {
            NSMutableArray* resultList = [NSMutableArray array];
            for (NSDictionary *dic in list) {
                HXSAccountBillCategoryItem *item = [[HXSAccountBillCategoryItem alloc] initWithDictionary:dic];
                [resultList addObject:item];
            }
            
            self.billCategoryList = [NSArray arrayWithArray:resultList];
        }
    }
    
    return self;
}

@end