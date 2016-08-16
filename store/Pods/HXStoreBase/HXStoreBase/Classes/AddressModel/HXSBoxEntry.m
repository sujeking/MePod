//
//  HXSBoxEntry.m
//  store
//
//  Created by ArthurWang on 15/8/11.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBoxEntry.h"

#import "HXMacrosUtils.h"

@implementation HXSBoxEntry

- (id)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init]) {
        
        if(DIC_HAS_NUMBER(dic, @"box_id")) {
            self.boxID = [dic objectForKey:@"box_id"];
        }
        
        if(DIC_HAS_STRING(dic, @"code")) {
            self.boxCodeStr = [dic objectForKey:@"code"];
        }
        
        if(DIC_HAS_STRING(dic, @"room")) {
            self.roomStr = [dic objectForKey:@"room"];
        }
    }
    
    return self;
}

- (NSDictionary *)encodeAsDic
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if(self.boxID) {
        [dic setObject:self.boxID forKey:@"box_id"];
    }
    
    if(self.boxCodeStr) {
        [dic setObject:self.boxCodeStr forKey:@"code"];
    }
    
    if(self.roomStr) {
        [dic setObject:self.roomStr forKey:@"room"];
    }
    
    return dic;
}

@end
