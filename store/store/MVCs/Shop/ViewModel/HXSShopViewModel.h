//
//  HXSShopViewModel.h
//  store
//
//  Created by ArthurWang on 16/1/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSStoreAppEntryEntity.h"
#import "HXSShopEntity.h"


@interface HXSShopViewModel : NSObject

//进入夜猫店
- (void)loadDromViewControllerWithShopEntity:(HXSShopEntity *)model
                                        from:(UIViewController *)superViewController;
//进入饮品店
- (void)loadDrinkViewControllerWithShopEntity:(HXSShopEntity *)model
                                         from:(UIViewController *)superViewController;
//进入打印店
- (void)loadPrintViewControllerWithShopEntity:(HXSShopEntity *)model
                                         from:(UIViewController *)superViewController;
//进入web页面
- (void)loadWebViewControllerWith:(NSURL *)urlStr
                             from:(UIViewController *)superViewController;


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


/**
 *  店铺详情
 *
 *  @param siteIdIntNum      学校id
 *  @param dormentryIdIntNum 楼栋id
 *  @param shopIDIntNum      店铺id
 *  @param block             返回的结果
 */
- (void)fetchShopInfoWithSiteId:(NSNumber *)siteIdIntNum
                       shopType:(NSNumber *)shopTypeNum
                    dormentryId:(NSNumber *)dormentryIdIntNum
                         shopId:(NSNumber *)shopIDIntNum
             complete:(void (^)(HXSErrorCode status, NSString *message, HXSShopEntity *shopEntity))block;


/**
 *  获取店铺首页的入口
 *
 *  @param siteIdIntNum      学校id
 *  @param typeIntNum        0- 店铺首页轮播 1-首页的店铺入口列表
 *  @param block      返回的结果
 */
- (void)fetchStoreAppEntriesWithSiteId:(NSNumber *)siteIdIntNum
                                  type:(NSNumber *)typeIntNum
                              complete:(void (^)(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr))block;

@end
