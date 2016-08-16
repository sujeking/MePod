//
//  HXSPrintSettingEntity.h
//  store
//
//  Created by J006 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXMacrosEnum.h"
#import "HXBaseJSONModel.h"

@protocol HXSPrintSettingEntity
@end

@interface HXSPrintSettingEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *printNameStr;//"name":str,  //样式名称
@property (nonatomic, readwrite) HXSDocumentSetPrintType printTypeNum;//"type":int,  //样式编号
@property (nonatomic, strong) NSNumber *unitPriceNum;//"unit_price":double  //单价
@property (nonatomic, strong) NSNumber *pageSideTypeNum;//"page_side":int  //一张纸打几面(是否双面打印， 1单面打印  2双面打印)

@end

@protocol HXSPrintSettingReducedEntity
@end

@interface HXSPrintSettingReducedEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *reduceedNameStr;//"name":str,  //缩印名称
@property (nonatomic, readwrite) HXSDocumentSetReduceType reduceedTypeNum;//"type":int,  //缩印编号
@property (nonatomic, strong) NSNumber *reduceedNum;//"reduced":int,  //缩印倍数

@end
