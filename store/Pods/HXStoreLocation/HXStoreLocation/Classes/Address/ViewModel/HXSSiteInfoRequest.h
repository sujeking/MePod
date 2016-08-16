//
//  HXSSiteInfoRequest.h
//  store
//
//  Created by chsasaw on 14/11/21.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebService.h"

@class HXSSite,HXSCity;

@interface HXSSiteInfoRequest : NSObject

- (void)getSiteInfoWithToken:(NSString *)token
                      siteId:(NSNumber *)site_id
                    complete:(void (^)(HXSErrorCode code, NSString * message, HXSSite * site))block;

- (void)seletSite:(NSNumber *)site_id
        withToken:(NSString *)token
         complete:(void (^)(HXSErrorCode code, NSString * message, HXSSite * site))block;

/**
 * 根据学校获取城市信息
 */
- (void)fetchCityDetialInfoOfSite:(NSNumber *)site_id
                         complete:(void (^)(HXSErrorCode code, NSString * message, HXSCity * city))block;

@end