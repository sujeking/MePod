//
//  HXSUserMyBoxInfo.m
//  store
//
//  Created by ArthurWang on 15/11/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSUserMyBoxInfo.h"

#import "HXMacrosUtils.h"

@implementation HXSApplyBoxInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)  {
        if (DIC_HAS_STRING(dictionary, @"dorm_phone")) {
            _dormPhone = [dictionary objectForKey:@"dorm_phone"];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"status")) {
            _status = [[dictionary objectForKey:@"status"] integerValue];
        }
    }
    
    return self;
}

@end

@implementation HXSUserMyBoxInfo

@end
