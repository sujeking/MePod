//
//  HXSDigitalMobileAddressEntity.m
//  store
//
//  Created by ArthurWang on 16/3/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileAddressEntity.h"


@implementation HXSDigitalMobileTownAddressEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"town_id":        @"townIDIntNum",
                              @"name":           @"townNameStr",
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (NSArray *)createAddressTownWithTownArr:(NSArray *)townArr
{
    return [HXSDigitalMobileTownAddressEntity arrayOfModelsFromDictionaries:townArr error:nil];
}

@end

@implementation HXSDigitalMobileCountryAddressEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"country_id":        @"countryIDIntNum",
                              @"name":              @"countryNameStr",
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)createAddressCountryWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileCountryAddressEntity alloc] initWithDictionary:dic error:nil];
}

@end

@implementation HXSDigitalMobileCityAddressEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"city_id":       @"cityIDIntNum",
                              @"name":          @"cityNameStr",
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)createAddressCityWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileCityAddressEntity alloc] initWithDictionary:dic error:nil];
}

@end



@implementation HXSDigitalMobileAddressEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"province_id":       @"provinceIDIntNum",
                              @"name":              @"provinceNameStr",
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)createAddressProvinceWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileAddressEntity alloc] initWithDictionary:dic error:nil];
}

@end
