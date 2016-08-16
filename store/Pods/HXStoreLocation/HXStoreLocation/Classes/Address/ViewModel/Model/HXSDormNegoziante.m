//
//  HXSDormNegoziante.m
//  Pods
//
//  Created by 格格 on 16/6/27.
//
//

#import "HXSDormNegoziante.h"

@implementation HXSDormNegoziante

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"portrait":          @"portraitStr",
                              @"floor":             @"floorNum",
                              @"dorm_id":           @"dormIdNum",
                              @"dorm_name":         @"dormNameStr",
                              @"item_num":          @"itemNum",
                              @"dormentry_id":      @"dormentryIdNum"
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSDormNegoziante alloc] initWithDictionary:object error:nil];
}

@end
