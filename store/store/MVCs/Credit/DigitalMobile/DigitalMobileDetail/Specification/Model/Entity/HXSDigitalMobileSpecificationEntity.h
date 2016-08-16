//
//  HXSDigitalMobileSpecificationEntity.h
//  store
//
//  Created by ArthurWang on 16/3/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDigitalMobileSpecificationEntity : HXBaseJSONModel

/** 组合商品ID */
@property (nonatomic, strong) NSNumber *itemIDIntNum;
/** html规格参数 */
@property (nonatomic, strong) NSString *paramHTMLStr;
/** html图文详情 */
@property (nonatomic, strong) NSString *pictureDetailHTMLStr;

+ (instancetype)createSpecificationEntityWithDic:(NSDictionary *)dic;

@end
