//
//  HXSCreditOrderEntity.m
//  store
//
//  Created by ArthurWang on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditOrderEntity.h"

@implementation HXSCreditOrderEntity

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        if (DIC_HAS_NUMBER(dic, @"total_count")) {
            self.totalCountIntNum = [dic objectForKey:@"total_count"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"page")) {
            self.pageIntNum = [dic objectForKey:@"page"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"num_per_page")) {
            self.numPerPageIntNum = [dic objectForKey:@"num_per_page"];
        }
        
        if (DIC_HAS_ARRAY(dic, @"orders")) {
            NSArray *ordersArr = [dic objectForKey:@"orders"];
            
            NSMutableArray *orderListMArr = [[NSMutableArray alloc] initWithCapacity:5];
            for (NSDictionary *orderDic in ordersArr) {
                HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] initWithDictionary:orderDic];
                
                [orderListMArr addObject:orderInfo];
            }
            
            self.orderListArr = orderListMArr;
        }
        
    }
    
    return self;
}

@end
