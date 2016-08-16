//
//  HXSCity.m
//  store
//
//  Created by chsasaw on 14/10/28.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSCity.h"

#import "HXSZone.h"
#import "HXSSite.h"

#import "HXMacrosUtils.h"

@implementation HXSCity

- (id) initWithDictionary:(NSDictionary *)dic {
    if(self = [super init]) {
        
        if(DIC_HAS_STRING(dic, @"city")) {
            self.name = [dic objectForKey:@"city"];
        }else {
            self.name = @"";
        }
        
        if(DIC_HAS_STRING(dic, @"city_id")) {
            self.city_id = [NSNumber numberWithInteger:[[dic objectForKey:@"city_id"] integerValue]];
        }else if(DIC_HAS_NUMBER(dic, @"city_id")) {
            self.city_id = [dic objectForKey:@"city_id"];
        }else {
            self.city_id = @(0);
        }
        
        if(DIC_HAS_STRING(dic, @"spell_short")) {
            self.spell_short = [dic objectForKey:@"spell_short"];;
        }
        
        if(DIC_HAS_STRING(dic, @"spell_all")) {
            self.spell_all = [dic objectForKey:@"spell_all"];;
        }
        
        if(DIC_HAS_STRING(dic, @"section_title")) {
            self.sectionTitle = [dic objectForKey:@"section_title"];
        }
        
        if(DIC_HAS_STRING(dic, @"province_id")) {
            self.provinceId = [dic objectForKey:@"province_id"];
        }
        
        if (DIC_HAS_STRING(dic, @"province")) {
            self.provinceName = [dic objectForKey:@"province"];
        }
    }
    
    return self;
}

- (NSDictionary *)encodeAsDic {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.name forKey:@"city"];
    [dic setObject:self.city_id forKey:@"city_id"];
    
    if(self.sectionTitle) {
        [dic setObject:self.sectionTitle forKey:@"section_title"];
    }
    
    if(self.spell_short) {
        [dic setObject:self.spell_short forKey:@"spell_short"];
    }
    
    if(self.spell_all) {
        [dic setObject:self.spell_all forKey:@"spell_all"];
    }
    
    return dic;
}

@end
