//
//  HXSSlideItem.m
//  store
//
//  Created by chsasaw on 14/10/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSSlideItem.h"

@implementation HXSSlideItem

- (id)initWithLocalDic:(NSDictionary *)dic {
    if(self = [super initWithLocalDic:dic]) {
    }
    
    return self;
}

- (id)initWithServerDic:(NSDictionary *)dic {
    if(self = [super initWithServerDic:dic]) {
        
    }
    
    return self;
}

- (NSMutableDictionary *)encodeAsLocalDic {
    NSMutableDictionary * dictionary = [super encodeAsLocalDic];
    
    return dictionary;
}

@end
