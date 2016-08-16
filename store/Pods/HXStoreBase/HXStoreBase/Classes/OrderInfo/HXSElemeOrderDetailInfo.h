//
//  HXSElemeOrderDetailInfo.h
//  store
//
//  Created by hudezhi on 15/8/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HXSElemeOrderState)
{
    HXSElemeOrderStateWaitPay = -5,                 // 等待支付
    HXSElemeOrderStatPayFailed = -4,                // 支付失败
    HXSElemeOrderStateNotConfirm = 0,               // 等待餐厅确认
    HXSElemeOrderStateCanceled = -1,                // 订单已取消
    HXSElemeOrderStateOrderCreating = -2,           // 饿了么订单创建中的状态
    HXSElemeOrderStateOrderPaying = -3,             // 支付中
    HXSElemeOrderStateRestaurantConfirmed = 2,      // 餐厅已确认
    HXSElemeOrderStateFinished = 11,                // 完成
};


@interface HXSElemeOrderDetailFoodItem : NSObject

@property (nonatomic) NSString *foodName;
@property (nonatomic) float price;
@property (nonatomic) NSInteger quantity;
@property (nonatomic) float amount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

// ==============================================

@interface HXSElemeOrderDetailExtraItem : NSObject

@property (nonatomic) float amount; // 总价
@property (nonatomic) float price;  // 单价
@property (nonatomic) NSInteger quantity; // 数量
@property (nonatomic) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

// ==============================================

@interface HXSElemeOrderDetailActivityItem : NSObject

@property (nonatomic, strong) NSString *activityNameStr;
@property (nonatomic, strong) NSNumber *discountFloatNum;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

// ==============================================

@interface HXSElemeOrderDetailInfo : NSObject

@property (nonatomic) NSString *createTime;
@property (nonatomic) NSTimeInterval createTimeSeconds;
@property (nonatomic) NSInteger quantity;
@property (nonatomic) BOOL isOnlinePaid;
@property (nonatomic) NSString *orderSn;
@property (nonatomic) NSString *payTime;
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic) NSInteger payType;
@property (nonatomic, strong) NSNumber *refundStatusCodeNum;
@property (nonatomic, strong) NSString *refundStatusMsgStr;
@property (nonatomic) NSString *restaurantImage;
@property (nonatomic) NSString *restaurantName;

@property (nonatomic) NSArray *restaurantPhoneList;
@property (nonatomic) NSArray *servicePhoneList;

@property (nonatomic) HXSElemeOrderState orderStatus;
@property (nonatomic) double orderAmount;
@property (nonatomic) NSString *userAddress;
@property (nonatomic) NSString *userPhone;

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *deliverTime;

@property (nonatomic) NSArray  *foodList;
@property (nonatomic) NSArray  *extraList;
@property (nonatomic, strong) NSArray *activitiesArr;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)getPayType;

@end
