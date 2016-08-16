//
//  HXSSite.h
//  store
//
//  Created by chsasaw on 14/10/28.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HXSSiteStatusOpen = 1,
    HXSSiteStatusClosed = 0,
} HXSSiteStatus;

@interface HXSSite : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSNumber * site_id;

@property (nonatomic, copy) NSNumber * sid;
@property (nonatomic, copy) NSString * shop_name;
@property (nonatomic, copy) NSNumber * zoneId;
@property (nonatomic, copy) NSString * zoneName;
@property (nonatomic, copy) NSNumber * cityId;
@property (nonatomic, copy) NSString * cityName;
@property (nonatomic, assign) HXSSiteStatus status;
@property (nonatomic, copy) NSString * redirectScheme;
@property (nonatomic, copy) NSString * redirectUrl;
@property (nonatomic, copy) NSString * status_remark;
@property (nonatomic, assign) int service_start_time;
@property (nonatomic, assign) int service_end_time;

@property (nonatomic, assign) int delivery_policy;// 0:既支持立即送出，也支持预约时间；1:仅支持预约时间
@property (nonatomic, assign) int free_delivery_fee;
@property (nonatomic, assign) int delivery_fee;
@property (nonatomic, assign) int min_delivery_fee;

- (id)initWithDictionary:(NSDictionary *)dic;
- (NSDictionary *)encodeAsDic;

@end