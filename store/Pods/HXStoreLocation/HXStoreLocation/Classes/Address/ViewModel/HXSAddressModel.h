//
//  HXSAddressModel.h
//  store
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXStoreWebServiceErrorCode.h"

#define HXS_LOCATION_DORMENTRY_LIST @"location/dormentry/list"
#define HXS_LOCATION_ZONE_LIST      @"location/zone/list"

@class HXSAddressEntity;

@interface HXSAddressModel : NSObject

/**
 *  获取学校下所有楼栋
 */
- (void)fetchAllBuilding:(NSNumber *)zoneId
            WithComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray *zoneList))block;

/**
 *  获取学下的所有楼区
 */
- (void)fetchAllZones:(NSNumber *)siteId
             complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *zoneList))block;
@end
