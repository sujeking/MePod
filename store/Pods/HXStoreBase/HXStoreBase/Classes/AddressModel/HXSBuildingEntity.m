//
//  HXSBuildingEntity.m
//  store
//
//  Created by ArthurWang on 15/9/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBuildingEntity.h"

@implementation HXSBuildingShopEntity

+ (JSONKeyMapper*)keyMapper
{
    NSDictionary *shopsMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"shopTypeIntNum",    @"shop_type",
                                  @"shopStatusIntNum",  @"status",
                                  nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:shopsMapping];
}

@end


@implementation HXSBuildingNameEntity

+ (JSONKeyMapper*)keyMapper
{
    NSDictionary *buildingNameMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"buildingNameStr",    @"name",
                                         @"dormentryIDIntNum",  @"dormentry_id",
                                         @"shopsArr",           @"shops",
                                         nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:buildingNameMapping];
}

@end


@implementation HXSBuildingEntity

+ (NSArray *)createBuildingEntityWithGroupsArr:(NSArray *)groupsArr
{
    return [HXSBuildingEntity arrayOfModelsFromDictionaries:groupsArr];
}

+ (JSONKeyMapper*)keyMapper
{
    NSDictionary *nameMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"nameStr",        @"name",
                                 @"buildingsArr",   @"dormentries",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:nameMapping];
}

@end
