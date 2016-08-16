//
//  HXSAddressEntity.m
//  store
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAddressEntity.h"

#import "HXMacrosUtils.h"

@implementation HXSAddressEntity

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (DIC_HAS_STRING(dic, @"name")) {
            self.name = [dic objectForKey:@"name"];
        }
        
        if (DIC_HAS_STRING(dic, @"phone")) {
            self.phone = [dic objectForKey:@"phone"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"province_id")) {
            self.provinceId = [dic objectForKey:@"province_id"];
        }
        
        if (DIC_HAS_STRING(dic, @"province")) {
            self.province = [dic objectForKey:@"province"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"city_id")) {
            self.cityId = [dic objectForKey:@"city_id"];
        }
        
        if (DIC_HAS_STRING(dic, @"city")) {
            self.city = [dic objectForKey:@"city"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"county_id")) {
            self.countyId = [dic objectForKey:@"county_id"];
        }
        
        if (DIC_HAS_STRING(dic, @"county")) {
            self.county = [dic objectForKey:@"county"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"town_id")) {
            self.townId = [dic objectForKey:@"town_id"];
        }
        
        if (DIC_HAS_STRING(dic, @"town")) {
            self.town = [dic objectForKey:@"town"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"site_id")) {
            self.siteId = [dic objectForKey:@"site_id"];
        }
        
        if (DIC_HAS_STRING(dic, @"site")) {
            self.site = [dic objectForKey:@"site"];
        }
        
        if (DIC_HAS_NUMBER(dic, @"dormentry_id")) {
            self.dormentryId = [dic objectForKey:@"dormentry_id"];
        }
        
        if (DIC_HAS_STRING(dic, @"dormentry")) {
            self.dormentry = [dic objectForKey:@"dormentry"];
        }
        
        if (DIC_HAS_STRING(dic, @"dormitory")) {
            self.dormitory = [dic objectForKey:@"dormitory"];
        }
        
        if (DIC_HAS_STRING(dic, @"postcode")) {
            self.postcode = [dic objectForKey:@"postcode"];
        }
    }
    
    return self;
}

- (NSString *)getAddressCode
{
    if (self.provinceId.intValue < 5) {
        return [NSString stringWithFormat:@"%@_%@_%@_0",self.provinceId,self.cityId,self.countyId];
    }else {
        return [NSString stringWithFormat:@"%@_%@_%@_%@",self.provinceId,self.cityId,self.countyId,self.townId];
    }
}

- (NSString *)getAddressName
{
    if (self.provinceId.intValue < 5) {
        return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.province,self.city,self.county,self.site,self.dormentry,self.dormitory];
    }else {
        return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@",self.province,self.city,self.county,self.town,self.site,self.dormentry,self.dormitory];
    }
}

- (NSMutableDictionary *)getDictionary
{
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:self.name forKey:@"name"];
    [postData setObject:self.phone forKey:@"phone"];
    [postData setObject:self.provinceId forKey:@"province_id"];
    [postData setObject:self.province forKey:@"province"];
    [postData setObject:self.cityId forKey:@"city_id"];
    [postData setObject:self.city forKey:@"city"];
    [postData setObject:self.countyId forKey:@"county_id"];
    [postData setObject:self.county forKey:@"county"];
    
    if (self.townId == nil) {
        self.townId = @0;
    }
    
    if (self.town == nil) {
        self.town = @"";
    }
    
    [postData setObject:self.townId forKey:@"town_id"];
    [postData setObject:self.town forKey:@"town"];
    [postData setObject:self.siteId forKey:@"site_id"];
    [postData setObject:self.site forKey:@"site"];
    [postData setObject:self.dormentryId forKey:@"dormentry_id"];
    [postData setObject:self.dormentry forKey:@"dormentry"];
    [postData setObject:self.dormitory forKey:@"dormitory"];
    [postData setObject:self.postcode forKey:@"postcode"];
    
    return postData;
}

@end
