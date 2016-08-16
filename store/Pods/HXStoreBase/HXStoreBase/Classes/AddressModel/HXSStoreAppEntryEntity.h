//
//  HXSStoreAppEntryEntity.h
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

@interface HXSStoreAppEntryEntity : HXBaseJSONModel

/** 入口id */
@property (nonatomic, strong) NSNumber *entryIDIntNum;
/** 入口名称 */
@property (nonatomic, strong) NSString *titleStr;
/** 入口图片 */
@property (nonatomic, strong) NSString *imageURLStr;
/** 图片宽 */
@property (nonatomic, strong) NSNumber *imageWidthIntNum;
/** 图片高 */
@property (nonatomic, strong) NSNumber *imageHeightIntNum;
/** 点击链接 */
@property (nonatomic, strong) NSString *linkURLStr;
/** 副标题 */
@property (nonatomic, strong) NSString *subtitleStr;

+ (instancetype)createStoreAppEntryEntityWithDic:(NSDictionary *)dic;

@end
