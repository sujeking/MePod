//
//  HXSDigitalMobileAddressEntity.h
//  store
//
//  Created by ArthurWang on 16/3/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDigitalMobileTownAddressEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *townIDIntNum;
@property (nonatomic, strong) NSString *townNameStr;

+ (NSArray *)createAddressTownWithTownArr:(NSArray *)townArr;

@end

@interface HXSDigitalMobileCountryAddressEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *countryIDIntNum;
@property (nonatomic, strong) NSString *countryNameStr;

+ (instancetype)createAddressCountryWithDic:(NSDictionary *)dic;

@end

@interface HXSDigitalMobileCityAddressEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *cityIDIntNum;
@property (nonatomic, strong) NSString *cityNameStr;

+ (instancetype)createAddressCityWithDic:(NSDictionary *)dic;

@end

@interface HXSDigitalMobileAddressEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *provinceIDIntNum;
@property (nonatomic, strong) NSString *provinceNameStr;

+ (instancetype)createAddressProvinceWithDic:(NSDictionary *)dic;

@end
