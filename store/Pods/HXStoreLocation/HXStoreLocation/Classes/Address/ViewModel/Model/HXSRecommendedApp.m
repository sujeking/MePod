//
//  HXSRecommendedApp.m
//  store
//
//  Created by ranliang on 15/6/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSRecommendedApp.h"

@implementation HXSRecommendedApp


- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
