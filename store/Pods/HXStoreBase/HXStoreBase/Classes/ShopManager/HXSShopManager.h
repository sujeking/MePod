//
//  HXSShopManager.h
//  store
//
//  Created by ArthurWang on 16/7/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSDormEntry.h"

@interface HXSShopManager : NSObject

@property (nonatomic, strong) HXSDormEntry *currentEntry;

+ (HXSShopManager *)shareManager;

@end
