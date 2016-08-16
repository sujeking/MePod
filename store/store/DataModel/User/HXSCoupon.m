//
//  HXSCoupon.m
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSCoupon.h"

@implementation HXSCoupon


+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"type",           @"type",
                                 @"couponCode",     @"code",
                                 @"activeTime",     @"active_time",
                                 @"expireTime",     @"expire_time",
                                 @"addTime",        @"add_time",
                                 @"discount",       @"discount",
                                 @"threshold",      @"threshold",
                                 @"text",           @"text",
                                 @"status",         @"status",
                                 @"tip",            @"tip",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSCoupon alloc] initWithDictionary:object];
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init]) {
        if(DIC_HAS_NUMBER(dic, @"type")) {
            self.type = [[dic objectForKey:@"type"] intValue];
        }
        
        if(DIC_HAS_NUMBER(dic, @"active_time")) {
            self.activeTime = [dic objectForKey:@"active_time"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"expire_time")) {
            self.expireTime = [dic objectForKey:@"expire_time"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"add_time")) {
            self.addTime = [dic objectForKey:@"add_time"];
        }
        
        if(DIC_HAS_STRING(dic, @"code")) {
            self.couponCode = [dic objectForKey:@"code"];
        }
        
        if(DIC_HAS_STRING(dic, @"image")) {
            self.image = [dic objectForKey:@"image"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"discount")) {
            self.discount = [dic objectForKey:@"discount"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"threshold")) {
            self.threshold = [dic objectForKey:@"threshold"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"available")) {
            self.available = [[dic objectForKey:@"available"] boolValue];
        }
        
        if(DIC_HAS_NUMBER(dic, @"rid")) {
            self.rid = [dic objectForKey:@"rid"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"rid_num")) {
            self.rid_num = [dic objectForKey:@"rid_num"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"rid_amount")) {
            self.rid_amount = [dic objectForKey:@"rid_amount"];
        }
        
        if(DIC_HAS_STRING(dic, @"text")) {
            self.text = [dic objectForKey:@"text"];
        }
        
        if(DIC_HAS_NUMBER(dic, @"status")) {
            self.status = [dic objectForKey:@"status"];
        }
        
        if(DIC_HAS_STRING(dic, @"tip")) {
            self.tip = [dic objectForKey:@"tip"];
        }
    }
    
    return self;
}

- (NSString *) getExpireString {
    return [NSString stringWithFormat:@"%@-%@", [HTDateConversion formatDate:[NSDate dateWithTimeIntervalSince1970:self.activeTime.integerValue] style:HXFormatDateStylePointDay], [HTDateConversion formatDate:[NSDate dateWithTimeIntervalSince1970:self.expireTime.integerValue] style:HXFormatDateStylePointDay]];
}

- (NSString *) getDiscountString {
    return  [NSString stringWithFormat:@"-￥%.2f", self.discount.floatValue];
}

- (NSString *) getCouponDesc {
    if(self.text && self.text.length > 0) {
        return self.text;
    }else if(self.type == 0) {
        return [self getDiscountString];
    }else {
        return self.couponCode;
    }
}

@end
