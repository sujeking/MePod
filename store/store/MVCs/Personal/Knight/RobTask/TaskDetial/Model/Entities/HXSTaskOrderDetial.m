//
//  HXSTaskOrderDetial.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskOrderDetial.h"

@implementation HXSTaskItem

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"idIntNum",@"id",
                                 @"nameStr",@"name",
                                 @"imageStr",@"image",
                                 @"priceDoubleNum",@"price",
                                 @"amountDoubleNum",@"amount",
                                 @"quantityIntNum",@"quantity",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

@end

@implementation HXSTaskOrderDetial

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"deliveryOrderStr",           @"delivery_order_id",
                             @"knightIdStr",                @"knight_id",
                             @"orderSnStr",                 @"order_sn",
                             @"statusIntNum",               @"status",
                             @"createTimeLongNum",          @"create_time",
                             @"confirmTimeLongNum",         @"confirm_time",
                             @"claimTimeLongNum",           @"claim_time",
                             @"finishTimeLongNum",          @"finish_time",
                             @"minRewardDoubleNum",         @"min_reward",
                             @"maxRewardDoubleNum",         @"max_reward",
                             @"rewardDoubleNum",            @"reward",
                             @"buyerNamestr",               @"buyer_name",
                             @"buyerPhoneStr",              @"buyer_phone",
                             @"buyerAddressStr",            @"buyer_address",
                             @"remarkStr",                  @"remark",
                             @"shopBossStr",                @"shop_boss",
                             @"shopPhoneStr",               @"shop_phone",
                             @"shopAddressStr",             @"shop_address",
                             @"itemIntNum",                 @"item_num",
                             @"itemAmountDoubleNum",        @"item_amount",
                             @"deliveryOrderUrlStr",        @"delivery_order_url",
                             @"cancelTimeLongNum",          @"cancel_time",
                             @"itemsArr",                   @"items",
                             nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSTaskOrderDetial alloc] initWithDictionary:object error:nil];
}

- (double)buyerAddressAddHeight:(int)dwith{
    
    CGSize titleSize = [self.buyerAddressStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - dwith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if(ceilf(titleSize.height) <= 14)
        return 0;
    return ceilf(titleSize.height) - 14;
}

- (double)shopAddressAddHeight:(int)dwith{
    CGSize titleSize = [self.shopAddressStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - dwith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if(ceilf(titleSize.height) <= 14)
        return 0;
    
    return ceilf(titleSize.height) - 14;
}

- (double)remarkAddHeight:(int)dwith{
    CGSize titleSize = [self.remarkStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - dwith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if(ceilf(titleSize.height) <= 14)
        return 0;
    
    return ceilf(titleSize.height) - 14;
}

@end
