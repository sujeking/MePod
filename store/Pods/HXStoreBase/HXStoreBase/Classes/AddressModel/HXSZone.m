//
//  HXSZone.m
//  store
//
//  Created by chsasaw on 14/10/28.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSZone.h"

#import "HXSSite.h"
#import "HXMacrosUtils.h"

@implementation HXSZone

- (id)initWithDictionary:(NSDictionary *)dic {
    if(self = [super init]) {
        if(DIC_HAS_STRING(dic, @"name")) {
            self.name = [dic objectForKey:@"name"];
        }else {
            self.name = @"";
        }
        
        NSArray * zoneSites = [dic objectForKey:@"sites"];
        self.sites = [NSMutableArray array];
        if(!zoneSites || ![zoneSites isKindOfClass:[NSArray class]]) {
            return self;
        }
        for(NSDictionary * siteDic in zoneSites) {
            HXSSite * site = [[HXSSite alloc] initWithDictionary:siteDic];
            [self.sites addObject:site];
        }
    }
    
    return self;
}

- (NSDictionary *)encodeAsDic {
    NSMutableDictionary * zoneDic = [NSMutableDictionary dictionary];
    [zoneDic setObject:self.name forKey:@"name"];
    
    NSMutableArray * sites = [NSMutableArray array];
    for(HXSSite * site in self.sites) {
        
        [sites addObject:[site encodeAsDic]];
    }
    [zoneDic setObject:sites forKey:@"sites"];
    
    return zoneDic;
}

@end
