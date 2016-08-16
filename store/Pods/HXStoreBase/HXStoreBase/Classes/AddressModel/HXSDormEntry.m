    //
//  HXSDormEntry.m
//  store
//
//  Created by chsasaw on 15/2/2.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormEntry.h"

#import "HXMacrosEnum.h"

@implementation HXSDormEntry

- (id)initWithShopEntity:(HXSShopEntity *)shopEntity
{
    if(self = [super init]) {
        self.shopEntity = shopEntity;
    }
    
    return self;
}

- (NSString *)getStatusDesc {
    if([self.shopEntity.statusIntNum integerValue] == kHXSShopStatusClosed) {
        return @"休息中";
    }else if(([self.shopEntity.statusIntNum integerValue] == kHXSShopStatusOpen)
             || ([self.shopEntity.statusIntNum integerValue] == kHXSShopStatusBook)) {
        return @"营业中";
    }else {
        return @"申请做店长";
    }
}

@end
