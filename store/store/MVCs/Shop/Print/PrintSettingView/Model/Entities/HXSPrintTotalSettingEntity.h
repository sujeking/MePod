//
//  HXSPrintTotalSettingEntity.h
//  store
//  打印样式、缩印样式
//  Created by J006 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSPrintSettingEntity.h"

@interface HXSPrintTotalSettingEntity : HXBaseJSONModel

@property (nonatomic, strong) NSArray<HXSPrintSettingEntity>          *printSettingArray;
@property (nonatomic, strong) NSArray<HXSPrintSettingReducedEntity>   *reduceSettingArray;

@end
