//
//  HXSCategoryModel.m
//  store
//
//  Created by  黎明 on 16/3/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCategoryModel.h"

@implementation HXSCategoryModel

+ (id)initWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init]) {

        [self  setValuesForKeysWithDictionary:dict];
    }

    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([@"category_id" isEqualToString:key]) {
        self.categoryId = value;
    }
    
    if ([@"category_name" isEqualToString:key]) {
        self.categoryName = value;
    }

    if ([@"category_type" isEqualToString:key]) {
        self.categoryType = value;
    }

}

@end
