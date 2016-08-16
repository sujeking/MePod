//
//  HXSStoreOrderEntity.m
//  store
//
//  Created by BeyondChao on 16/4/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSStoreOrderEntity.h"

@implementation HXSStoreOrderEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *orderMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"attachStr",          @"attach",
                                  @"orderSn",            @"order_sn",
                                  @"status",             @"status",
                                  @"orderType",          @"type",
                                  @"payType",            @"paytype",
                                  @"payStatus",          @"paystatus",
                                  @"itemNum",            @"item_num",
                                  @"itemAmount",         @"item_amount",
                                  @"couponDiscount",     @"coupon_discount",
                                  @"promotionDiscount",  @"promotion_discount",
                                  @"totalDiscount",             @"discount",
                                  @"orderAmount",               @"order_amount",
                                  @"orderCreateTime",           @"create_time",
                                  @"cancelTime",                @"cancel_time",
                                  @"orderPayTime",              @"paytime",
                                  @"deliveryTime",              @"delivery_time",
                                  @"deliveryFeeNum",            @"delivery_fee",
                                  @"userPhone",                 @"phone",
                                  @"address",                   @"address",
                                  @"refundStatusMsg",           @"refund_status_msg",
                                  @"couponCode",                @"coupon_code",
                                  @"remark",                    @"remark",
                                  @"sellerContact",             @"shop_contact",
                                  @"knightName",                @"knight_name",
                                  @"knightContact",             @"knight_contact",
                                  @"storeOrderItems",           @"items",
                                  nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:orderMapping];
}

+ (instancetype)orderEntityWithDictionary:(NSDictionary *)orderDict
{
    return [[HXSStoreOrderEntity alloc] initWithDictionary:orderDict error:nil];
}

@end
