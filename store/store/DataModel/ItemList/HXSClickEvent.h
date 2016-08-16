//
//  HXSClickEvent.h
//  store
//
//  Created by chsasaw on 14/10/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EVENT_SCHEME_DORM           @"dorm"             //夜猫店
#define EVENT_SCHEME_BOX            @"box"              //零食盒
#define EVENT_SCHEME_CREDIT_PAY     @"credit_pay"       //白花花 （保留白花花入口）
#define EVENT_SCHEME_ORDER_DETAIL   @"order_detail"     //订单详情
#define EVENT_SCHEME_COUPON         @"coupon"           //消息中心跳到优惠券页面
#define EVENT_SCHEME_CREDIT         @"credit"           //消息中心跳转到积分页面
#define EVENT_SCHEME_CREDIT_CONSUME_BILL       @"credit_consume_bill"       // 信用钱包消费类账单
#define EVENT_SCHEME_CREDIT_INSTALLMENT_BILL   @"credit_installment_bill"   // 信用钱包分期类账单
#define EVENT_SCHEME_CREDIT_INSTALLMENT_RECORD @"credit_installment_record" // 信用钱包分期纪录
#define EVENT_SCHEME_CREDIT_WALLET             @"credit_wallet"             // 信用钱包页面
#define EVENT_SCHEME_TIP                       @"tip"                       // 3c分期购
#define EVENT_SCHEME_TIP_GROUP_ITEM            @"tip_group_item"            // 3c分期购商品详情  参数 group_id


@interface HXSClickEvent : NSObject

@property (nonatomic, copy)     NSString * title;
@property (nonatomic, copy)     NSString * eventUrl;
@property (nonatomic, copy)     NSString * scheme;
@property (nonatomic, strong)   NSDictionary * params;

+ (id)eventWithLocalDic:(NSDictionary *)dic;
+ (id)eventWithServerDic:(NSDictionary *)dic;

- (NSMutableDictionary *)encodeAsLocalDic;

@end

@protocol HXSClickEventDelegate <NSObject>

- (void)onStartEvent:(HXSClickEvent *)event;

@end