//
//  HXSClickEvent.m
//  store
//
//  Created by chsasaw on 14/10/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSClickEvent.h"

#define HXS_EVENT_TITLE         @"title"
#define HXS_EVENT_URL           @"link"
#define HXS_EVENT_PARAMS        @"param"
#define HXS_EVENT_SCHEME        @"scheme"

@implementation HXSClickEvent

- (id)init {
    if(self = [super init]) {
        
    }
    
    return self;
}

+ (id)eventWithLocalDic:(NSDictionary *)dic {
    HXSClickEvent * event = [[HXSClickEvent alloc]initWithLocalDic:dic];
    
    return event;
}

+ (id)eventWithServerDic:(NSDictionary *)dic {
    HXSClickEvent * event = [[HXSClickEvent alloc]initWithServerDic:dic];
    
    return event;
}

- (id)initWithLocalDic:(NSDictionary *)dic {
    if(self = [super init]) {
        
        if(DIC_HAS_STRING(dic, HXS_EVENT_TITLE)) {
            self.title = [dic objectForKey:HXS_EVENT_TITLE];
        }
        
        if(DIC_HAS_STRING(dic, HXS_EVENT_URL)) {
            self.eventUrl = [dic objectForKey:HXS_EVENT_URL];
        }
        
        if(DIC_HAS_STRING(dic, HXS_EVENT_SCHEME)) {
            self.scheme = [dic objectForKey:HXS_EVENT_SCHEME];
        }
        
        if(DIC_HAS_DIC(dic, HXS_EVENT_PARAMS)) {
            self.params = [dic objectForKey:HXS_EVENT_PARAMS];
        }
    }
    
    return self;
}

- (id)initWithServerDic:(NSDictionary *)dic {
    if(self = [super init]) {
        
        if(DIC_HAS_STRING(dic, HXS_EVENT_TITLE)) {
            self.title = [dic objectForKey:HXS_EVENT_TITLE];
        }
        
        if(DIC_HAS_STRING(dic, HXS_EVENT_URL)) {
            self.eventUrl = [dic objectForKey:HXS_EVENT_URL];
        }
        
        if(DIC_HAS_STRING(dic, HXS_EVENT_SCHEME)) {
            self.scheme = [dic objectForKey:HXS_EVENT_SCHEME];
        }
        
        if(DIC_HAS_DIC(dic, HXS_EVENT_PARAMS)) {
            self.params = [dic objectForKey:HXS_EVENT_PARAMS];
        }
    }
    
    return self;
}

- (NSMutableDictionary *)encodeAsLocalDic {
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    if(self.title != nil) {
        [diction setObject:self.title forKey:HXS_EVENT_TITLE];
    }
    
    if(self.eventUrl != nil) {
        [diction setObject:self.eventUrl forKey:HXS_EVENT_URL];
    }
    
    if(self.params != nil) {
        [diction setObject:self.params forKey:HXS_EVENT_PARAMS];
    }
    
    if(self.scheme != nil) {
        [diction setObject:self.scheme forKey:HXS_EVENT_SCHEME];
    }
    
    return diction;
}

@end