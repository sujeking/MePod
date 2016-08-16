//
//  HXSDigitalMobileParamEntity.m
//  store
//
//  Created by ArthurWang on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileParamEntity.h"

@implementation HXSDigitalMobileParamSKUPropertyEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *skuPropertyMapping = @{
                                         @"property_id":        @"propertyIDIntNum",
                                         @"value_name":         @"valueNameStr",
                                         };
    
    return [[JSONKeyMapper alloc] initWithDictionary:skuPropertyMapping];
}

@end

@implementation HXSDigitalMobileParamSKUEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *skuMapping = @{
                                 @"sku_id":     @"skuIDIntNum",
                                 @"name":       @"nameStr",
                                 @"image":      @"skuImageURLStr",
                                 @"price":      @"priceFloatNum",
                                 @"integral":   @"integralFloatNum",
                                 @"properties": @"propertiesArr",
                                 };
    
    return [[JSONKeyMapper alloc] initWithDictionary:skuMapping];
}

@end

@implementation HXSDigitalMobileParamPropertyValueEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *valueMapping = @{@"value_name":   @"valueNameStr"};
    
    return [[JSONKeyMapper alloc] initWithDictionary:valueMapping];
}

@end

@implementation HXSDigitalMobileParamPropertyEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *propertyMapping = @{
                                      @"property_id":       @"propertyIDIntNum",
                                      @"property_name":     @"propertyNameStr",
                                      @"values":            @"valuesArr",
                                      };
    
    return [[JSONKeyMapper alloc] initWithDictionary:propertyMapping];
}

@end


@implementation HXSDigitalMobileParamEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"available_properties":  @"availablePropertiesArr",
                              @"skus":                  @"skusArr",
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)createDigitailMobileParamEntityWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileParamEntity alloc] initWithDictionary:dic error:nil];
}

@end
