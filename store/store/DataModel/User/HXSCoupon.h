//
//  HXSCoupon.h
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HXSCouponTypeCash = 0,//现金券
    HXSCouponTypeMaterial = 1,//实物券
    HXSCouponTypeOther = 2,
} HXSCouponType;

@interface HXSCoupon : HXBaseJSONModel

@property (nonatomic, assign) HXSCouponType type;   // 0表示抵价券, 1表示抵物券
@property (nonatomic, copy) NSString * couponCode;  // 优惠码
@property (nonatomic, copy) NSNumber * activeTime;  // 生效时间
@property (nonatomic, copy) NSNumber * expireTime;  // 过期时间
@property (nonatomic, copy) NSNumber * addTime;     // 生成时间

@property (nonatomic, copy) NSNumber * discount;  // 优惠额度
@property (nonatomic, copy) NSNumber * threshold; // 消费最低限额
@property (nonatomic, assign) BOOL available;
@property (nonatomic, copy) NSNumber * rid;
@property (nonatomic, copy) NSNumber * rid_num;
@property (nonatomic, copy) NSNumber * rid_amount;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, strong) NSNumber *status; // 0 未到使用时间 1 正常 2 使用过 3 过期
@property (nonatomic, strong) NSString *tip; //优惠券使用条件说明

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

- (id)initWithDictionary:(NSDictionary *)dic;

- (NSString *) getExpireString;
- (NSString *) getCouponDesc;


@end