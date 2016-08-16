//
//  HXSAddressViewModel.h
//  store
//
//  Created by ArthurWang on 16/6/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXSAddressEntity;

@interface HXSAddressViewModel : NSObject

/*
 * 获取收货地址
 */
- (void)fetchAddressWithComplete:(void (^)(HXSErrorCode code, NSString *message, HXSAddressEntity *addressInfo))block;

/*
 * 获取所有街道
 */
- (void)fetchAddressTownWithCountry:(NSNumber *)townId
                       WithComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray *streeList))block;

/*
 * 获取所有学校
 */
- (void)fetchAllSchoolWithFirstAddress:(NSString *)firstAddressStr
                         secondAddress:(NSString *)secondAddressStr
                              complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *schoolList))block;

/*
 * 保存收货地址
 */
- (void)saveAddressInfo:(HXSAddressEntity *)addressInfo
               Complete:(void (^)(HXSErrorCode code, NSString *message, HXSAddressEntity *addressInfo))block;

/*
 * 获取学校下所有楼栋
 */
- (void)fetchAllBuilding:(NSNumber *)siteId
            WithComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray *buildingList))block;

@end
