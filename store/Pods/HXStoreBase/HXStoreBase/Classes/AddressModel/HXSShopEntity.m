//
//  HXSShopEntity.m
//  store
//
//  Created by ArthurWang on 16/1/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopEntity.h"

#import "HXMacrosUtils.h"

@implementation HXSPromotionsEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingPromotion = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"promotionImageStr",    @"promotion_image",
                                      @"promotionIdNum",       @"promotion_id",
                                      @"promotionNameStr",     @"promotion_name",
                                      @"promotionColorStr",    @"promotion_color", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingPromotion];
}

@end

@implementation HXSShopEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingShop = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"shopIDIntNum",           @"shop_id",
                                 @"statusIntNum",           @"status",
                                 @"dormNameStr",            @"dorm_name",
                                 @"shopNameStr",            @"shop_name",
                                 @"shopAddressStr",         @"shop_address",
                                 @"itemNumIntNum",          @"item_num",
                                 @"addressStr",             @"address",
                                 @"noticeStr",              @"notice",
                                 @"minAmountFloatNum",      @"min_amount",
                                 @"freeDeliveryAmountFloatNum", @"free_delivery_amount",
                                 @"deliveryFeeFloatNum",        @"delivery_fee",
                                 @"shopTypeIntNum",             @"shop_type",
                                 @"shopTypeImageUrlStr",        @"shop_type_image",
                                 @"deliveryStatusIntNum",       @"delivery_status",
                                 @"deliveryTimeStr",            @"delivery_time",
                                 @"shopLogoURLStr",             @"shop_logo",
                                 @"signaturesStr",              @"signatures",
                                 @"businesHoursStr",            @"business_hours",
                                 @"promotionsArr",              @"promotions", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingShop];
}

+ (instancetype)createShopEntiryWithData:(NSDictionary *)shopDic
{
    return [[HXSShopEntity alloc] initWithDictionary:shopDic error:nil];
}

- (CGFloat)getNoticeCellHight{
    
    int padding = 149;
    CGFloat noticeLabelHeight = [self.noticeStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - padding, 0)
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}
                                                               context:nil].size.height;
    return noticeLabelHeight;

}

@end
