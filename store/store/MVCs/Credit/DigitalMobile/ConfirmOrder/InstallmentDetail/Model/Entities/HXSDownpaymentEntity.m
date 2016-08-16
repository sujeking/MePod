//
//  HXSDownpaymentEntity.m
//  store
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  首付比例信息

#import "HXSDownpaymentEntity.h"

@implementation HXSDownpaymentEntity

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (DIC_HAS_STRING(dic, @"percent_desc")) {
            self.percentDesc = [dic objectForKey:@"percent_desc"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"percent")) {
            self.percent = [dic objectForKey:@"percent"];
        }
    }
    
    return self;
}

@end
