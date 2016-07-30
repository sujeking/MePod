//
//  HXSBillBaseModel.m
//  store
//
//  Created by  黎明 on 16/7/28.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBillBaseModel.h"

@implementation HXSBillBaseModel

+ (instancetype)initWithDict:(id)object
{
    return [[self alloc] initWithDict:object];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (instancetype)initWithDict:(id)object
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:[self resetDictionary:object]];
    }
    return self;
}

#pragma mark Privte Method

- (NSMutableDictionary *)resetDictionary:(id)origDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSDictionary *origDictionary = [[NSDictionary alloc] init];
    
    
    if ([origDict isKindOfClass:[NSDictionary class]])
    {
        origDictionary = origDict;
    }
    else if([origDict isKindOfClass:[NSArray class]])
    {
        origDictionary = [(NSArray *)origDict firstObject];
    }
    
    for (int i = 0; i < origDictionary.allValues.count; i++)
    {
        id value = origDictionary.allValues[i];
        
        NSString *key = origDictionary.allKeys[i];
        
        key = [self modifyKeysWith:key];
        
        if ([value isKindOfClass:[NSString class]])
        {
            NSString *keys = [key stringByAppendingString:@"Str"];
            [dict setObject:value forKey:keys];
        }
        
        if ([value isKindOfClass:[NSNumber class]])
        {
            NSString *keys = [key stringByAppendingString:@"Num"];
            [dict setObject:value forKey:keys];
        }
        if ([value isKindOfClass:[NSArray class]])
        {
            NSString *keys = [key stringByAppendingString:@"Arr"];
            [dict setObject:value forKey:keys];
        }
        if ([value isKindOfClass:[NSDictionary class]])
        {
            [dict setObject:value forKey:key];
        }
    }
    return dict;
}


- (NSString *)modifyKeysWith:(NSString *)key
{
    NSArray *aaaArray = [key componentsSeparatedByString:@"_"];
    
    NSString *string = @"";
    
    for (int i = 0;i < aaaArray.count;i++) {
        NSString *str = aaaArray[i];
        
        if (i != 0) {
            str = [str capitalizedString];
        }
        string = [string stringByAppendingString:str];
    }
    
    return string;
}

@end
