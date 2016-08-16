//
//  HXSDormEntry.h
//  store
//
//  Created by chsasaw on 15/2/2.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSShopEntity.h"

@interface HXSDormEntry : NSObject

@property (nonatomic, strong) HXSShopEntity *shopEntity;

- (id)initWithShopEntity:(HXSShopEntity *)shopEntity;

@end