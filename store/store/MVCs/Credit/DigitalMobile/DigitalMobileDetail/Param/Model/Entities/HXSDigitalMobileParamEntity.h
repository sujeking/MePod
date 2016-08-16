//
//  HXSDigitalMobileParamEntity.h
//  store
//
//  Created by ArthurWang on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDigitalMobileParamSKUPropertyEntity : HXBaseJSONModel

/** 商品属性值id */
@property (nonatomic, strong) NSNumber *propertyIDIntNum;
/** 商品属性值名称 */
@property (nonatomic, strong) NSString *valueNameStr;

@end


@protocol HXSDigitalMobileParamSKUEntity
@end

@interface HXSDigitalMobileParamSKUEntity : HXBaseJSONModel

/** 商品sku_id */
@property (nonatomic, strong) NSNumber *skuIDIntNum;
/** 商品名 */
@property (nonatomic, strong) NSString *nameStr;
/** 商品图片 */
@property (nonatomic, strong) NSString *skuImageURLStr;
/** 价格 */
@property (nonatomic, strong) NSNumber *priceFloatNum;
/** 赠送积分 */
@property (nonatomic, strong) NSNumber *integralFloatNum;

@property (nonatomic, strong) NSArray *propertiesArr;

@end

@interface HXSDigitalMobileParamPropertyValueEntity : HXBaseJSONModel


/** 商品属性值名称 */
@property (nonatomic, strong) NSString *valueNameStr;
/** cell 的宽度 */
@property (nonatomic, strong) NSNumber *widthFloatNum;

@end



@protocol HXSDigitalMobileParamPropertyEntity
@end

@interface HXSDigitalMobileParamPropertyEntity : HXBaseJSONModel

/** 商品属性id */
@property (nonatomic, strong) NSNumber *propertyIDIntNum;
/** 商品属性名称  */
@property (nonatomic, strong) NSString *propertyNameStr;

@property (nonatomic, strong) NSArray *valuesArr;

@end

@interface HXSDigitalMobileParamEntity : HXBaseJSONModel

@property (nonatomic, strong) NSArray<HXSDigitalMobileParamPropertyEntity> *availablePropertiesArr;
@property (nonatomic, strong) NSArray<HXSDigitalMobileParamSKUEntity> *skusArr;

+ (instancetype)createDigitailMobileParamEntityWithDic:(NSDictionary *)dic;

@end
