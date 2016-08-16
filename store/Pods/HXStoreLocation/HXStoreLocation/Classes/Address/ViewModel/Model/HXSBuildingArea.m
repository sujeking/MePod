//
//  HXSBuildingArea.m
//  Pods
//
//  Created by 格格 on 16/7/15.
//
//

#import "HXSBuildingArea.h"

#import "HXSBuildingEntity.h"
#import "HXStoreLocation.h"

@implementation HXSBuildingArea

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *areaDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"name",               @"name",
                             @"buildingsArr",       @"dormentries", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:areaDic];
}


+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBuildingArea alloc] initWithDictionary:object error:nil];
}



- (NSDictionary *)encodeAsDic
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if(self.name != nil) {
        [dic setObject:self.name forKey:@"name"];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    if(self.buildingsArr){
        for(NSDictionary *dic in self.buildingsArr) {
            NSDictionary *buildingDic = [self encodeBuildingNameEntity:dic];
            [arr addObject:buildingDic];
        }
    }
    [dic setObject:arr forKey:@"buildingsArr"];
    return dic;
}

- (NSDictionary *)encodeBuildingShopEntity:(HXSBuildingShopEntity *)entity
{
     NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if(entity.shopTypeIntNum != nil) {
        [dic setObject:entity.shopTypeIntNum forKey:@"shopTypeIntNum"];
    }
    if(entity.shopStatusIntNum != nil) {
        [dic setObject:entity.shopStatusIntNum forKey:@"shopStatusIntNum"];
    }
    return dic;
}

- (NSDictionary *)encodeBuildingNameEntity:(HXSBuildingNameEntity *)entity
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if(entity.buildingNameStr != nil) {
        [dic setObject:entity.buildingNameStr forKey:@"buildingNameStr"];
    }
    if(entity.dormentryIDIntNum != nil) {
        [dic setObject:entity.dormentryIDIntNum forKey:@"dormentryIDIntNum"];
    }
    NSMutableArray *shopArr = [NSMutableArray array];
    if(entity.shopsArr != nil) {
        for(HXSBuildingShopEntity *temp in entity.shopsArr){
            [shopArr addObject:[self encodeBuildingShopEntity:temp]];
        }
    }
    [dic setObject:shopArr forKey:@"shopsArr"];
    return dic;
}

@end
