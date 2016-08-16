//
//  HXSBuildingEntity.h
//  store
//
//  Created by ArthurWang on 15/9/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

@protocol HXSBuildingShopEntity
@end

@interface HXSBuildingShopEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *shopTypeIntNum;     // 店铺类型(0-夜猫店、1-饮品店、2-打印店)
@property (nonatomic, strong) NSNumber *shopStatusIntNum;   // 0-关店、1-开店、2-自动

@end

@protocol HXSBuildingNameEntity
@end

@interface HXSBuildingNameEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *buildingNameStr;  // D1
@property (nonatomic, strong) NSNumber *dormentryIDIntNum;

@property (nonatomic, strong) NSArray<HXSBuildingShopEntity> *shopsArr;

@end


@interface HXSBuildingEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *nameStr;

@property (nonatomic, strong) NSArray<HXSBuildingNameEntity> *buildingsArr;

+ (NSArray *)createBuildingEntityWithGroupsArr:(NSArray *)groupsArr;

@end
