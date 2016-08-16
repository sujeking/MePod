//
//  HXSSite.m
//  store
//
//  Created by chsasaw on 14/10/28.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSSite.h"

#import "HXMacrosUtils.h"

@implementation HXSSite

- (id)initWithDictionary:(NSDictionary *)dic {
    if(self = [super init]) {
        if (DIC_HAS_NUMBER(dic, @"site_id"))
        {
            self.site_id = [dic objectForKey:@"site_id"];
        }
        
        if(DIC_HAS_STRING(dic, @"site_name")) {
            self.name = [dic objectForKey:@"site_name"];
        }
        
        if(DIC_HAS_STRING(dic, @"name")) {
            self.name = [dic objectForKey:@"name"];
        }
        
        if(DIC_HAS_STRING(dic, @"sid")) {
            self.sid = [dic objectForKey:@"sid"];
        }
        
        if(DIC_HAS_STRING(dic, @"shop_name")) {
            self.shop_name = [dic objectForKey:@"shop_name"];
        }
        
        if(DIC_HAS_STRING(dic, @"zone_id")) {
            self.zoneId = [dic objectForKey:@"zone_id"];
        }
        
        if(DIC_HAS_STRING(dic, @"zone_name")) {
            self.zoneName = [dic objectForKey:@"zone_name"];
        }
        
        if(DIC_HAS_STRING(dic, @"redirect_scheme")) {
            self.redirectScheme = [dic objectForKey:@"redirect_scheme"];
        }
        
        if(DIC_HAS_STRING(dic, @"redirect_url")) {
            self.redirectUrl = [dic objectForKey:@"redirect_url"];
        }
        
        if(DIC_HAS_STRING(dic, @"city_id") || DIC_HAS_NUMBER(dic, @"city_id")) {
            self.cityId = [NSNumber numberWithInt:[[dic objectForKey:@"city_id"] intValue]];
        }
        
        if(DIC_HAS_STRING(dic, @"city_name")) {
            self.cityName = [dic objectForKey:@"city_name"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"status")) {
            self.status = [[dic objectForKey:@"status"] intValue];
        }
        
        if(DIC_HAS_STRING(dic, @"status_remark")) {
            self.status_remark = [dic objectForKey:@"status_remark"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"service_time_start")) {
            self.service_start_time = [[dic objectForKey:@"service_time_start"] intValue];
        }
        
        if (DIC_HAS_NUMBER(dic, @"service_time_end")) {
            self.service_end_time = [[dic objectForKey:@"service_time_end"] intValue];
        }
    }
    
    return self;
}

- (NSDictionary *)encodeAsDic {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if(self.site_id != nil) {
        [dic setObject:self.site_id forKey:@"site_id"];
    }
    
    if(self.name != nil) {
        [dic setObject:self.name forKey:@"site_name"];
    }
    
    if(self.sid != nil) {
        [dic setObject:self.sid forKey:@"sid"];
    }
    
    if(self.shop_name != nil) {
        [dic setObject:self.shop_name forKey:@"shop_name"];
    }
    
    if(self.zoneId != nil) {
        [dic setObject:self.zoneId forKey:@"zone_id"];
    }
    
    if(self.zoneName != nil) {
        [dic setObject:self.zoneName forKey:@"zone_name"];
    }
    
    if(self.redirectScheme != nil) {
        [dic setObject:self.redirectScheme forKey:@"redirect_scheme"];
    }
    
    if(self.redirectUrl != nil) {
        [dic setObject:self.redirectUrl forKey:@"redirect_url"];
    }
    
    if(self.cityId != nil) {
        [dic setObject:self.cityId forKey:@"city_id"];
    }
    
    if(self.cityName != nil) {
        [dic setObject:self.cityName forKey:@"city_name"];
    }
    
    [dic setObject:[NSNumber numberWithInt:self.status] forKey:@"status"];
    
    if(self.status_remark != nil) {
        [dic setObject:self.status_remark forKey:@"status_remark"];
    }
    
    [dic setObject:[NSNumber numberWithInt:self.service_start_time] forKey:@"service_start_time"];

    [dic setObject:[NSNumber numberWithInt:self.service_end_time] forKey:@"service_time_end"];
    
    return dic;
}

@end