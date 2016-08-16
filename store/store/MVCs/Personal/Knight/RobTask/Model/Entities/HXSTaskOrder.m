//
//  HXSTaskOrder.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskOrder.h"

@implementation HXSTaskOrder

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"deliveryOrderIdStr",         @"delivery_order_id",
                             @"deliveryOrderSnStr",         @"delivery_order_sn",
                             @"rewardDoubleNum",            @"reward",
                             @"knightIdLongNum",            @"knight_id",
                             @"statusIntNum",               @"status",
                             @"orderSnStr",                 @"order_sn",
                             @"remarkStr",                  @"remark",
                             @"buyerName",                  @"buyer_name",
                             @"buyerPhone",                 @"buyer_phone",
                             @"buyerAddress",               @"buyer_address",
                             @"shopBossStr",                @"shop_boss",
                             @"shopPhoneStr",               @"shop_phone",
                             @"shopAddressStr",             @"shop_address",
                             @"minRewardDoubleNum",         @"min_reward",
                             @"maxRewardDoubleNum",         @"max_reward",
                             @"cancelTimeLongNum",          @"cancel_time",
                             @"shopIdLongNum",              @"shop_id",
                             @"dateNoNum",                  @"date_no",
                             nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSTaskOrder alloc] initWithDictionary:object error:nil];
}

- (double)buyerAddressAddHeight:(int)dwith{
    
    NSString *str  = [NSString stringWithFormat:@"送至：%@ %@",self.buyerAddress,self.buyerName];
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - dwith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if(ceilf(titleSize.height) <= 14)
        return 0;
    return ceilf(titleSize.height) - 14;
}

- (double)buyerAddressAddHeightRob:(int)dwith{
    
    NSString *str  = [NSString stringWithFormat:@"%@ %@",self.buyerAddress,self.buyerName];
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - dwith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
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

- (double)remarkAddHeightLessTwoLines:(int)dwith{
    
    NSString *str = self.remarkStr.length > 0 ? self.remarkStr:@"无";
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - dwith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if(ceilf(titleSize.height) <= 14)
        return 0;
    
    if(ceilf(titleSize.height) < 34)
        return ceilf(titleSize.height) - 14;
    
    return 34 - 14;
}

- (double)cellHeightWithBuyerAddressWidth:(int)buyerAddressdwidth shopAddressWidth:(int)shopAddressWidth remarkWidth:(int)remarkWidth {
    
    double cellHeight = 0;
    
    double buyerAddressAddHeight = [self buyerAddressAddHeight:buyerAddressdwidth];
    if(buyerAddressAddHeight > 14)
        cellHeight += buyerAddressAddHeight + 6;
    else
        cellHeight += buyerAddressAddHeight;
    
    double remarkAddHeight = [self remarkAddHeightLessTwoLines:remarkWidth];
    if(remarkAddHeight > 14)
        cellHeight += remarkAddHeight ;
    else
        cellHeight += remarkAddHeight;
    
    cellHeight  += [self shopAddressAddHeight:shopAddressWidth];
    
    return cellHeight;
}

@end
