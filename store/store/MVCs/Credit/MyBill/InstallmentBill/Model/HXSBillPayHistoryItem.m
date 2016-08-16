//
//  HXSBillPayHistoryItem.m
//  store
//
//  Created by hudezhi on 15/8/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBillPayHistoryItem.h"

@implementation HXSBillPayHistoryItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.billDate = dictionary[@"bill_time"];
    }
    
    return self;
}

@end
