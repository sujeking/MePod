//
//  HXSStoreAppEntryEntity.m
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSStoreAppEntryEntity.h"

@implementation HXSStoreAppEntryEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"id":            @"entryIDIntNum",
                              @"title":         @"titleStr",
                              @"image":         @"imageURLStr",
                              @"image_width":   @"imageWidthIntNum",
                              @"image_height":  @"imageHeightIntNum",
                              @"link":          @"linkURLStr",
                              @"subtitle":      @"subtitleStr",
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)createStoreAppEntryEntityWithDic:(NSDictionary *)dic
{
    HXSStoreAppEntryEntity *entity = [[HXSStoreAppEntryEntity alloc] initWithDictionary:dic error:nil];
    
    
    return entity;
}

@end
