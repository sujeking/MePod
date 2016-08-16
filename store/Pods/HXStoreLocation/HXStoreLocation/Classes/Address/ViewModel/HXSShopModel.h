//
//  HXSShopModel.h
//  store
//
//  Created by ArthurWang on 16/1/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSStoreAppEntryEntity.h"
#import "HXSShopEntity.h"
#import "HXStoreWebServiceErrorCode.h"


@interface HXSShopModel : NSObject

/**
 *  店铺列表
 *
 *  @param siteIdIntNum      学校id
 *  @param dormentryIDIntNum 楼栋id
 *  @param type              0夜猫店 1饮品店 2打印店 3云超市 4水果店 99表示全部
 *  @param isCrossBuilding   0不跨楼栋，居住在本楼的所有店铺 1支持跨楼栋的店铺，配送到本楼的店铺
 *  @param block             返回的结果
 */

- (void)fetchShopListWithSiteId:(NSNumber *)siteIdIntNum
                      dormentry:(NSNumber *)dormentryIDIntNum
                           type:(NSNumber *)typeIntNum
                  crossBuilding:(NSNumber *)isCrossBuilding
                       complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *shopsArr))block;

@end
