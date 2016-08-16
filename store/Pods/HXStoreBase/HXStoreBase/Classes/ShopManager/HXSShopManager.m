//
//  HXSShopManager.m
//  store
//
//  Created by ArthurWang on 16/7/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopManager.h"

@implementation HXSShopManager

#pragma mark - Initial Methods

+ (HXSShopManager *)shareManager
{
    static HXSShopManager *shopManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shopManager = [[HXSShopManager alloc] init];
    });
    
    return shopManager;
}

@end
