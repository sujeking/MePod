//
//  HXSDigitalMobileDetailEntity.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileDetailEntity.h"

@implementation HXSDigitalMobileDetailCommentEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *commentMapping = @{
                                     @"id":             @"commentIDIntNum",
                                     @"user_name":      @"userNameStr",
                                     @"user_portrait":  @"userPortraitUrlStr",
                                     @"content":        @"contentStr",
                                     @"comment_time":   @"commentTimeIntNum",
                                     @"site_name":      @"siteNameStr",
                                     };
    
    return [[JSONKeyMapper alloc] initWithDictionary:commentMapping];
}

+ (instancetype)createCommentEntityWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileDetailCommentEntity alloc] initWithDictionary:dic error:nil];
}

@end

@implementation HXSDigitalMobileDetailPromotionEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *promotionMapping = @{
                                       @"image":    @"promotionImageURLStr",
                                       @"name":     @"promotionNameStr",
                                       };
    
    return [[JSONKeyMapper alloc] initWithDictionary:promotionMapping];
}

@end

@implementation HXSDigitalMobileDetailImageEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *imageMapping = @{
                                   @"url":  @"imageURLStr",
                                   @"id":   @"imageIDIntNum",
                                   };
    
    return [[JSONKeyMapper alloc] initWithDictionary:imageMapping];
}

@end


@implementation HXSDigitalMobileDetailEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"name":                  @"nameStr",
                              @"item_id":               @"itemIDIntNum",
                              @"supplier":              @"supplierStr",
                              @"price":                 @"priceStr",
                              @"average_score":         @"averageScoreFloatNum",
                              @"introduction":          @"introductionHtmlStr",
                              @"images":                @"imagesArr",
                              @"promotions":            @"promotionsArr",
                              @"comments":              @"commentsArr",
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)createMobileDetailEntityWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileDetailEntity alloc] initWithDictionary:dic error:nil];
}


@end
