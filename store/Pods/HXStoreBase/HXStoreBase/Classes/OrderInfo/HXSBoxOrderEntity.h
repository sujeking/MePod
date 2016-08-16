//
//  HXSBoxOrderEntity.h
//  store
//
//  Created by ArthurWang on 15/8/12.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"
#import "HXSOrderInfo.h"

@protocol HXSBoxOrderItemEntity
@end

@interface HXSBoxOrderItemEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *img;

@end

@protocol HXSBoxOrderDiscountEntity
@end

@interface HXSBoxOrderDiscountEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *discountTitleStr;
@property (nonatomic, strong) NSNumber *discountFloatNum;

@end

@interface HXSBoxOrderEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *boxID;
@property (nonatomic, strong) NSString *boxCodeStr;
@property (nonatomic, strong) NSNumber *type; // 5 盒子
@property (nonatomic, strong) NSNumber *payType;
@property (nonatomic, strong) NSNumber *source;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *refundStatusCodeIntNum;  // 0为无退款，1为退款中，2为已退款
@property (nonatomic, strong) NSString *refundStatusMsgStr;      // 字段内容可能为空
@property (nonatomic, strong) NSNumber *dormID;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSNumber *totalDiscount;
@property (nonatomic, strong) NSNumber *foodAmount;
@property (nonatomic, strong) NSNumber *foodNum;
@property (nonatomic, strong) NSNumber *orderAmount;
@property (nonatomic, strong) NSNumber *orderID;
@property (nonatomic, strong) NSString *orderSNStr;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *cancelTime;
@property (nonatomic, strong) NSString *remarkStr;
@property (nonatomic, strong) NSNumber *UID;
@property (nonatomic, strong) NSString *ipStr;
@property (nonatomic, strong) NSString *attachStr;         //  备注

//支付
@property (nonatomic, strong) NSArray *orderPayArr;
@property (nonatomic, strong) NSArray<HXSBoxOrderItemEntity> *itemsArr;
@property (nonatomic, strong) NSArray<HXSBoxOrderDiscountEntity> *discountArr;

@property (nonatomic, strong) NSString *tips;

@property (nonatomic, strong) NSArray<HXSOrderActivitInfo> *activityInfos;


+ (instancetype)createBoxOrderEntityWithDic:(NSDictionary *)boxOrderDic;

+ (NSArray *)createBoxOrderArrWithArr:(NSArray *)boxOrderArr;

- (NSString *)getStatus;
- (NSString *)getPayType;


@end
