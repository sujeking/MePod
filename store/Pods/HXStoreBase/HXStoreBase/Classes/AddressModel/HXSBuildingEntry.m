//
//  HXSBuildingEntry.m
//  store
//
//  Created by ArthurWang on 15/9/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBuildingEntry.h"

#import "HXMacrosUtils.h"

@implementation HXSBuildingEntry

- (id)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init]) {
        
        if(DIC_HAS_STRING(dic, @"nameStr")) {
            self.nameStr = [dic objectForKey:@"nameStr"];
        }
        
        if(DIC_HAS_STRING(dic, @"buildingNameStr")) {
            self.buildingNameStr = [dic objectForKey:@"buildingNameStr"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"dormentryIDNum")) {
            self.dormentryIDNum = [dic objectForKey:@"dormentryIDNum"];
        }
    }
    
    return self;
}

- (NSDictionary *)encodeAsDic
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if(self.nameStr) {
        [dic setObject:self.nameStr forKey:@"nameStr"];
    }
    
    if(self.buildingNameStr) {
        [dic setObject:self.buildingNameStr forKey:@"buildingNameStr"];
    }
    
    if (self.dormentryIDNum) {
        [dic setObject:self.dormentryIDNum forKey:@"dormentryIDNum"];
    }
    
    
    return dic;
}

@end
