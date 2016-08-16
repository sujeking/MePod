//
//  HXSSiteListRequest.h
//  store
//
//  Created by chsasaw on 14/10/28.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebService.h"

@interface HXSSiteListRequest : NSObject

- (void)getCityListWithToken:(NSString *)token
                    complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * array))block;

- (void)getSiteListWithToken:(NSString *)token
                   onlyStore:(BOOL)onlyStore
                      cityId:(NSNumber *)cityId
                    complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * array))block;

- (void)searchSiteListWithToken:(NSString *)token
                       keywords:(NSString *)keywords
                       complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * array))block;

- (void)postionSiteListWithToken:(NSString *)token
                        latitude:(double)latitude
                       longitude:(double)longitude
                        complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * array))block;

- (void)cancel;

@end