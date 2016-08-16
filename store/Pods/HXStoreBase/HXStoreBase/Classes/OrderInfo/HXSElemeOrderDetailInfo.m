//
//  HXSElemeOrderDetailInfo.m
//  store
//
//  Created by hudezhi on 15/8/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSElemeOrderDetailInfo.h"

#import "NSDate+Extension.h"
#import "NSString+HXSOrderPayType.h"

@implementation HXSElemeOrderDetailFoodItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.foodName = dictionary[@"name"];
        self.price = [dictionary[@"price"] floatValue];
        self.quantity = [dictionary[@"quantity"] integerValue];
        self.amount = [dictionary[@"item_amount"] floatValue];
    }
    
    return self;
}

@end

// ==============================================

@implementation HXSElemeOrderDetailExtraItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.amount = [dictionary[@"item_amount"] floatValue];
        self.name = dictionary[@"name"];
        self.price = [dictionary[@"price"] floatValue];
        self.quantity = [dictionary[@"quantity"] integerValue];
    }
    
    return self;
}

@end

// ==============================================

@implementation HXSElemeOrderDetailActivityItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.activityNameStr = dictionary[@"activity_name"];
        self.discountFloatNum = dictionary[@"discount"];
    }
    
    return self;
}

@end

// ==============================================

@implementation HXSElemeOrderDetailInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        long long mseconds = [dictionary[@"create_time"] longLongValue];
        self.createTimeSeconds = [dictionary[@"create_time"] doubleValue];
        self.createTime = [NSDate stringFromSecondsSince1970:mseconds format:@"YYYY-MM-dd HH:mm:ss"];
        self.quantity = [dictionary[@"food_num"] integerValue];
        self.isOnlinePaid = [dictionary[@"is_online_paid"] boolValue];
        self.orderSn = dictionary[@"order_sn"];
        
        mseconds = [dictionary[@"pay_time"] longValue];
        if (mseconds > 0) {
            self.payTime = [NSDate stringFromSecondsSince1970:mseconds format:@"YYYY-MM-dd HH:mm:ss"];
        }
        self.orderType = [dictionary[@"type"] integerValue];
        self.payType = [dictionary[@"pay_type"] integerValue];
        self.refundStatusCodeNum = dictionary[@"refund_status_code"];
        self.refundStatusMsgStr = dictionary[@"refund_status_msg"];
        self.restaurantImage = dictionary[@"restaurant_image"];
        self.restaurantName = dictionary[@"restaurant_name"];
        
        self.restaurantPhoneList = dictionary[@"restaurant_phones"];
        self.servicePhoneList = dictionary[@"service_phones"];
        
        self.orderStatus = [dictionary[@"status"] integerValue];
        self.orderAmount = [dictionary[@"total_amount"] doubleValue];
        self.userAddress = dictionary[@"user_address"];
        self.userPhone = dictionary[@"user_phone"];
        self.userName = dictionary[@"user_name"];
        self.deliverTime = dictionary[@"deliver_time"];
        
        NSArray *list = dictionary[@"food_items"];
        if (list.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for(NSDictionary *dic in list) {
                HXSElemeOrderDetailFoodItem *item = [[HXSElemeOrderDetailFoodItem alloc] initWithDictionary:dic];
                [array addObject:item];
            }
            
            self.foodList = [NSArray arrayWithArray:array];
        }
        
        list = dictionary[@"extra_items"];
        if (list.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in list) {
                HXSElemeOrderDetailExtraItem *item = [[HXSElemeOrderDetailExtraItem alloc] initWithDictionary:dic];
                [array addObject:item];
            }
            
            self.extraList = [NSArray arrayWithArray:array];
        }
        
        list = dictionary[@"preferential_activities"];
        if (0 < list.count) {
            NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:5];
            for (NSDictionary *dic in list) {
                HXSElemeOrderDetailActivityItem *item = [[HXSElemeOrderDetailActivityItem alloc] initWithDictionary:dic];
                [mArr addObject:item];
            }
            
            self.activitiesArr = [NSArray arrayWithArray:mArr];
        }
    }
    
    return self;
}

- (NSString *)getPayType
{
    if (0.0 >= self.orderAmount) {
        return @"无";
    }
    
    return [NSString payTypeStringWithPayType:self.payType];
}

@end
