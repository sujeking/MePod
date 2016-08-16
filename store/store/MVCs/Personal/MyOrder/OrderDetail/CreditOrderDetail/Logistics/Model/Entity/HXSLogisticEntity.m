//
//  HXSLogisticEntity.m
//  store
//
//  Created by 沈露萍 on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSLogisticEntity.h"

@implementation HXSLogisticRecordsEntity

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (DIC_HAS_STRING(dict, @"msg_time")) {
            self.timeStr = [dict objectForKey:@"msg_time"];
        }
        if (DIC_HAS_STRING(dict, @"content")) {
            self.descStr = [dict objectForKey:@"content"];
        }
    }
    return self;
}

@end

@implementation HXSLogisticEntity

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (DIC_HAS_STRING(dict, @"jd_order_id")) {
            self.logisticNumberStr = [dict objectForKey:@"jd_order_id"];
        }
        
        if (DIC_HAS_ARRAY(dict, @"order_track")) {
            NSMutableArray *logisticRecordsMArr = [[NSMutableArray alloc] init];
            
            NSArray *logisticArr = [dict objectForKey:@"order_track"];
            for (NSDictionary *logisticDict in logisticArr) {
                HXSLogisticRecordsEntity *logisticRecordsEntity = [[HXSLogisticRecordsEntity alloc] initWithDict:logisticDict];
                
                [logisticRecordsMArr addObject:logisticRecordsEntity];
            }
            self.logisticRecordsMArr = logisticRecordsMArr;
        }
    }
    return self;
}

@end
