//
//  HXSDigitalMobileItemListEntity.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDigitalMobileItemListEntity : HXBaseJSONModel

/** 组合商品ID */
@property (nonatomic, strong) NSNumber *itemIDIntNum;
/** 图片 */
@property (nonatomic, strong) NSString *iamgeURLStr;
/** 商品名 */
@property (nonatomic, strong) NSString *nameStr;
/** 最低价 */
@property (nonatomic, strong) NSNumber *lowPriceFloatNum;
/** 最低分期价 */
@property (nonatomic, strong) NSNumber *lowLoanPriceFloatNum;
/** 最低分期数 */
@property (nonatomic, strong) NSNumber *lowInstallmentNumIntNum;

+ (instancetype)createDigitalMobileItemListWithDic:(NSDictionary *)dic;

@end
