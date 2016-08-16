//
//  HXSDigitalMobileModel.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSDigitalMobileCategoryListEntity.h"
#import "HXSDigitalMobileItemListEntity.h"

#import "HXSCreditEntity.h"

typedef NS_ENUM(NSInteger, HXSCreditCardLayoutType){
    kHXSCreditCardLayoutTypeWallet        = 1,
    kHXSCreditCardLayoutTypeDigitalMobile = 2,
};

@interface HXSDigitalMobileModel : NSObject

/**
 *  获取信用购的卡片列表
 *
 *  @param cityIDNum 城市id
 *  @param block     返回的结果
 */
- (void)fetchCreditlayoutWithCityID:(NSNumber *)cityIDNum
                               type:(NSNumber *)typeIntNum
                           complete:(void (^)(HXSErrorCode status, NSString *message, HXSCreditEntity *creditLayoutEntity))block;

/**
 *  分期购轮播
 *
 *  @param cityIDStr 城市ID
 *  @param block     返回结果
 */
- (void)fetchTipSlideWithCityID:(NSString *)cityIDStr
                       complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *slideArr))block;

/**
 *  分期购分类
 *
 *  @param block 返回结果
 */
- (void)fetchTipCategoryList:(void (^)(HXSErrorCode status, NSString *message, NSArray *categoryListArr))block;

/**
 *  分期购分类商品列表
 *
 *  @param categoryIDIntNum 分类ID
 *  @param block            返回结果
 */
- (void)fetchTipItemListWithCategoryID:(NSNumber *)categoryIDIntNum
                              complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *itemsArr))block;

/**
 *  热门商品获取
 *
 *  @param block 返回结果
 */
- (void)fetchHotItems:(void (^)(HXSErrorCode status, NSString *message, NSArray *itemsArr))block;

@end
