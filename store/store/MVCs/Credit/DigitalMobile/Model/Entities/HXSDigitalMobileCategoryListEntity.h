//
//  HXSDigitalMobileCategoryListEntity.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDigitalMobileCategoryListEntity : HXBaseJSONModel

/** 分类id */
@property (nonatomic, strong) NSNumber *categoryIDIntNum;
/** 分类标题 */
@property (nonatomic, strong) NSString *categoryNameStr;

+ (instancetype)createDigitalMobileCategoryListWithDic:(NSDictionary *)categoriesDic;

@end
