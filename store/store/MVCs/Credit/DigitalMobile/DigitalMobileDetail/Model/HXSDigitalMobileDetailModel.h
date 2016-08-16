//
//  HXSDigitalMobileDetailModel.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSDigitalMobileDetailEntity.h"
#import "HXSDigitalMobileAddressEntity.h"

@interface HXSDigitalMobileDetailModel : NSObject

/**
 *  分期购商品详情
 *
 *  @param itemIDIntNum 组合商品id
 *  @param block        返回结果
 */
- (void)fetchItemDetailWithItemID:(NSNumber *)itemIDIntNum
                         complete:(void (^)(HXSErrorCode status, NSString *message, HXSDigitalMobileDetailEntity *entity))block;

/**
 *  分期购一级地址信息
 *
 *  @param block  返回结果
 */
- (void)fetchAddressProvince:(void (^)(HXSErrorCode status, NSString *message, NSArray *addressArr))block;

/**
 *  分期购二级地址信息
 *
 *  @param block  返回结果
 */
- (void)fetchAddressCityWithProvice:(NSNumber *)proviceIDIntNum
                          completed:(void (^)(HXSErrorCode status, NSString *message, NSArray *addressArr))block;

/**
 *  分期购三级地址信息
 *
 *  @param block  返回结果
 */
- (void)fetchAddressCountryWithCity:(NSNumber *)cityIDIntNum
                          completed:(void (^)(HXSErrorCode status, NSString *message, NSArray *addressArr))block;



@end
